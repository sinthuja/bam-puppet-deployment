class cassandra_setup::cassandra ( $version,
                      $owner  = "kurumba",
                      $group  = "kurumba",
                      $target = "/mnt/${server_ip}") {
	
	$deployment_code		= "cassandra"

	$setup_version 	        	= $version
        $maintenance_mode   		= "true"

	$service_code 			= "cassandra"
        $cassandra_home			= "${target}/apache-cassandra-${setup_version}"

        $service_templates      	= ["conf/cassandra.yaml"]

        $common_templates      		= []


	tag ($service_code)

        define push_templates ( $directory, $target ) {
        
                file { "${target}/${name}":
                        owner   => $owner,
                        group   => $group,
                        mode    => 755,
                        content => template("${directory}/${name}.erb"),
                        ensure  => present,
                }
        }

	clean { $deployment_code:
		mode		=> $maintenance_mode,
                target          => $cassandra_home,
	}

	initialize { $deployment_code:
		repo		=> $cassandra_package_repo,
		version         => $setup_version,
		mode		=> $maintenance_mode,
		service		=> $service_code,
		local_dir       => $local_package_dir,
		owner		=> $owner,
		target   	=> $target,
		require		=> Cassandra_Setup::Clean[$deployment_code],
	}

	deploy { $deployment_code:
		service		=> $service_code,
		owner		=> $owner,
		group		=> $group,
		target		=> $cassandra_home,
		require		=> Cassandra_Setup::Initialize[$deployment_code],
	}
	
	push_templates { 
		$service_templates: 
		target		=> $cassandra_home,
		directory 	=> $service_code,
		require 	=> Cassandra_Setup::Deploy[$deployment_code];

		$common_templates:
		target          => $cassandra_home,
                directory       => "common",
		require 	=> Cassandra_Setup::Deploy[$deployment_code],
	}

       
	start { $deployment_code:
		owner		=> $owner,
                target          => $cassandra_home,
		require		=> [ Cassandra_Setup::Initialize[$deployment_code],
				     Cassandra_Setup::Deploy[$deployment_code],
				     Push_templates[$service_templates],
				     Push_templates[$common_templates], 
				   ],
	}
      
}

