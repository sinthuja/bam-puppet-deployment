class mysql_server {
  $password = $mysql_root_password
 
  package { "mysql-server":
      ensure => installed 
  }

  service { 'mysql':
     ensure => running,
     pattern => 'mysql',
     require => Package['mysql-server'],
  }

  exec { "Set MySQL server root password":
    subscribe => [ Package["mysql-server"]],
    refreshonly => true,
    unless => "mysqladmin -uroot -p$password status",
    path => "/bin:/usr/bin",
    command => "mysqladmin -uroot password $password",
  }

  file { '/etc/mysql/my.cnf':
    ensure  => present,
    content => template('mysql/my.cnf.erb')
  }  

   exec { 'Restart MySQL' :
    subscribe => [ File["/etc/mysql/my.cnf"]],
    refreshonly => true,
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command => "/etc/init.d/mysql restart",
  }

   exec {
      'Create mysql user root@%':
         subscribe => [ Exec["Set MySQL server root password"]],
         refreshonly => true,
         path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
         command => "/usr/bin/mysql -uroot -p${password} -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by '$password'; FLUSH PRIVILEGES;\"",
   }
   
  exec { 'Creating script location' :
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command => "mkdir -p /opt/sql/scripts";
  }

   
   file { '/opt/sql/scripts/':
	                owner           => $owner,
	                group           => $group,
	                source          => ["puppet:///modules/mysql/scripts"],
        	        sourceselect    => all,
			ignore		=> ".svn",
                        mode            => 755,
                	ensure          => present,
                        require         => Exec['Creating script location'],
	                recurse         => true;
   }
    
  file { '/opt/sql/scripts/distributed_bam_setup.sql':
                        content         => template('mysql/distributed_bam_setup.sql.erb'),
                        ensure          => present,
                        require         => Exec['Creating script location'];
   }


  file { '/opt/sql/scripts/clean_distributed_bam_setup.sql':
                        content         => template('mysql/clean_distributed_bam_setup.sql.erb'),
                        ensure          => present,
                        require         => Exec['Creating script location'];
   }


   exec {
      'Create Database':
         subscribe => [ Exec["Create mysql user root@%"],
                        File["/opt/sql/scripts/"],
                        File["/opt/sql/scripts/distributed_bam_setup.sql"]],
         refreshonly => true,
         path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
         command => "/usr/bin/mysql -uroot -p${password} -e \"source /opt/sql/scripts/distributed_bam_setup.sql;\"",
         require => [ File['/opt/sql/scripts/'], 
                      File['/opt/sql/scripts/distributed_bam_setup.sql'],
                      File['/opt/sql/scripts/clean_distributed_bam_setup.sql']];
   }


 
}

