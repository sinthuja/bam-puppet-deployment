class setup::bam_receiver ( $version, 
		   $offset=0, 
		   $cluster_port=4000, 
		   $maintenance_mode=true, 
		   $depsync=false, 
		   $owner=root,
		   $group=root,
		   $target="/mnt" ) {
	
	$deployment_code	= "bam"

	$setup_version 	= $version
	$service_code 		= "bam_receiver"
        $registry_database      = "bam_reg_db"
	$carbon_home		= "${target}/wso2${deployment_code}-${setup_version}"

	$service_templates 	=  ["conf/advanced/streamdefn.xml", "conf/data-bridge/data-bridge-config.xml"]


        $common_templates      = ["conf/registry.xml", "conf/datasources/master-datasources.xml", "conf/datasources/bam-datasources.xml",
                                  "conf/user-mgt.xml", "conf/carbon.xml", "conf/axis2/axis2.xml"]


	tag ($service_code)

        define push_templates ( $directory, $target ) {
        
                file { "${target}/repository/${name}":
                        owner   => $owner,
                        group   => $group,
                        mode    => 755,
                        content => template("${directory}/${name}.erb"),
                        ensure  => present,
                }
        }

	clean { $deployment_code:
		mode		=> $maintenance_mode,
                target          => $carbon_home,
	}

	initialize { $deployment_code:
		repo		=> $package_repo,
		version         => $setup_version,
		mode		=> $maintenance_mode,
		service		=> $service_code,
		local_dir       => $local_package_dir,
		owner		=> $owner,
		target   	=> $target,
		require		=> Setup::Clean[$deployment_code],
	}

	deploy { $deployment_code:
		service		=> $service_code,
		security	=> "true",
		owner		=> $owner,
		group		=> $group,
		target		=> $carbon_home,
		require		=> Setup::Initialize[$deployment_code],
	}
	
	push_templates { 
		$service_templates: 
		target		=> $carbon_home,
		directory 	=> $service_code,
		require 	=> Setup::Deploy[$deployment_code];

		$common_templates:
		target          => $carbon_home,
                directory       => "common",
		require 	=> Setup::Deploy[$deployment_code],
	}

	start { $deployment_code:
		owner		=> $owner,
                target          => $carbon_home,
		require		=> [ Setup::Initialize[$deployment_code],
				     Setup::Deploy[$deployment_code],
				     Push_templates[$service_templates],
				     Push_templates[$common_templates], 
				   ],
	}
}

