class system_config {

	include hosts
	include apt
        include java
	
	user { "kurumba": 
  		password   => "ZZZZZZZZZZZZZZZZZZZZ",
  		ensure     => present,                            
 	 	managehome => true,
	}

	file {  "/root/bin":
                owner   => root,
                group   => root,
                ensure  => "directory";

		"/root/bin/firewall":
                owner   => root,
                group   => root,
                ensure  => "directory",
                require => File["/root/bin"];

		"/root/bin/puppet_init.sh":
                owner   => root,
                group   => root,
                mode    => 0755,
                source  => "puppet:///modules/common/bin/puppet_init.sh",
                require => File["/root/bin/firewall"];

		"/root/bin/puppet_clean.sh":
                owner   => root,
                group   => root,
                mode    => 0755,
                content => template("common/puppet_clean.sh.erb"),
                require => File["/root/bin/firewall"];

                "/etc/security/limits.conf":
                owner   => root,
                group   => root,
                mode    => 0755,
                content => template("common/limits.conf.erb");


                "/etc/sysctl.conf":
                owner   => root,
                group   => root,
                mode    => 0755,
                content => template("common/sysctl.conf.erb")

        }

}

