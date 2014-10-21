class hadoop_setup::hadoop ( $version,
                      $slave = "true",
                      $master = "false",
                      $owner  = "hadoop",
                      $group  =  "hadoopgroup",
                      $target = "/home/hadoop/hadoopnode/") {
	
	$deployment_code	= "hadoop"

	$setup_version 	= $version
        $maintenance_mode   = "true"

	$service_code 		= "hadoop"
        $hadoop_home		= "${target}/${deployment_code}-${setup_version}"

#	$service_templates 	=  ["conf/advanced/streamdefn.xml"]
        $service_templates      =  ["conf/hadoop-env.sh", "conf/core-site.xml", "conf/hdfs-site.xml", "conf/mapred-site.xml", 
                                     "conf/masters", "conf/slaves", "conf/hadoop-policy.xml"]

#        $common_templates      = ["conf/registry.xml", "conf/datasources/master-datasources.xml", "conf/datasources/bam-datasources.xml",
#                                  "conf/user-mgt.xml", "conf/carbon.xml"]

        $common_templates      = []


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
                target          => $hadoop_home,
	}

	initialize { $deployment_code:
		repo		=> $hadoop_package_repo,
		version         => $setup_version,
		mode		=> $maintenance_mode,
		service		=> $service_code,
		local_dir       => $local_package_dir,
		owner		=> $owner,
		target   	=> $target,
		require		=> Hadoop_Setup::Clean[$deployment_code],
	}

	deploy { $deployment_code:
		service		=> $service_code,
		security	=> "true",
		owner		=> $owner,
		group		=> $group,
		target		=> $hadoop_home,
		require		=> Hadoop_Setup::Initialize[$deployment_code],
	}
	
	push_templates { 
		$service_templates: 
		target		=> $hadoop_home,
		directory 	=> $service_code,
		require 	=> Hadoop_Setup::Deploy[$deployment_code];

		$common_templates:
		target          => $hadoop_home,
                directory       => "common",
		require 	=> Hadoop_Setup::Deploy[$deployment_code],
	}

       if($isManager == "true"){
	start { $deployment_code:
		owner		=> $owner,
                target          => $hadoop_home,
		require		=> [ Hadoop_Setup::Initialize[$deployment_code],
				     Hadoop_Setup::Deploy[$deployment_code],
				     Push_templates[$service_templates],
				     Push_templates[$common_templates], 
				   ],
	}
      }
}

