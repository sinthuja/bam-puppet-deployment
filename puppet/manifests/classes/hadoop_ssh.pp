class hadoop_ssh {

	include hosts
	include apt

#         user { "hadoopuser":
#                password   => "hadoop",
#                ensure     => present,
#                managehome => true,
#        }

	
	user { "${hadoop_user}": 
  		password   => "${hadoop_pw}",
  		ensure     => present,                            
 	 	managehome => true,
	}


	define createuser ($uid,$realname,$pass) {
 
		user { $title:
		ensure => 'present',
		uid => $uid,
		gid => $title,
		shell => '/bin/bash',
		home => "/home/${title}",
		comment => $realname,
		password => $pass,
		managehome => true,
		require => Group[$title],
	}
 
	group { $title:
		gid => $uid,
	}
 
	file { "/home/${title}":
		ensure => directory,
		owner => $title,
		group => $title,
		mode => 0750,
		require => [ User[$title], Group[$title] ],
	}
     
    }
   

    define authorized_keys ($sshkeys, $ensure = "present", $home = '') {
    # This line allows default homedir based on $title variable.
    # If $home is empty, the default is used.
    $homedir = $home ? {'' => "/home/${title}", default => $home}
    file {
        "${homedir}/.ssh":
            ensure  => "directory",
            owner   => $title,
            group   => $title,
            mode    => 700,
            require => User[$title];

        "${homedir}/.ssh/authorized_keys":
            ensure  => $ensure,
            owner   => $ensure ? {'present' => $title, default => undef },
            group   => $ensure ? {'present' => $title, default => undef },
            mode    => 600,
            require => File["${homedir}/.ssh"],
            content => template("hadoop/authorized_keys.erb");
    }
   }

   authorized_keys {"${hadoop_user}":
    sshkeys => [
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLMY0AQjTr5hD4o8yav9mppievIPqcDXWEKwmXGwZNUfxtlM/Ve47svrqrZyAbd20IveWm7opnH5NRpj9FA31tVUcPBMLEOUIwjkioR9RHMd5p3F7Sl+e36thyRwERxMMGJNIR0pL9DQDoqzqgQzUPAOu9mx0zI7f/80OJU+6tAnWD3hVQF3uhTykwhGc1q+74cV+SVtjRJ9syiux95BQJNe9LdUTwZ/uxiKCl5c6q2gPdOfN83HkIi35URSKBUDaBjb0BRqNd1S2yfUueOnug87q20PRAY5tZTQkT9jVL1jySNtrxxRTSaUwbJbKFE6FyfwBBaPB6gIyZXdgpBV57 hadoop@hadoopbase',
    ],
}
}

