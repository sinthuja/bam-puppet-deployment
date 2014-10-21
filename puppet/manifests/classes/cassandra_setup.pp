class cassandra_setup {


## Cleans the previous deployment. If the maintenance mode is set to true, this will only kill the running service.

#	define clean ( $mode, $target, $local_dir, $version, $service ) {	
	define clean ( $mode, $target ) {	

		exec { "remove_${name}_poop":
                	path            => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
	                onlyif          => "test -d ${target}/logs/",
        	        command         => $mode ? {
                	                        "true"  => "kill -9 `cat ${target}/wso2carbon.pid` ; /bin/echo Killed",
                        	                "false" => "kill -9 `cat ${target}/wso2carbon.pid` ; rm -rf ${target}",
                        	                "fresh" => "kill -9 `cat ${target}/wso2carbon.pid` ; rm -rf ${target} ; rm -f ${local_dir}/apache-cassandra-${version}-bin.tar.gz",
                                	   },
		}
	}

## Initializing the deployment by placing a customized script in /opt/bin which will download and extract the pack.

	define initialize ( $repo, $version, $service, $local_dir, $target, $mode, $owner ) {

		exec {  "creating_target_for_${name}":
			path    	=> ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
			command		=> "mkdir -p ${target}";

			"creating_local_package_repo_for_${name}":
			path		=> "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
			unless		=> "test -d ${local_dir}",
			command		=> "mkdir -p ${local_dir}";
		
	   		"downloading_apache-cassandra-${version}-bin.tar.gz_for_${name}":
			path    	=> ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
			cwd		=> $local_dir,
			unless		=> "test -f ${local_dir}/apache-cassandra-${version}-bin.tar.gz",
			command		=> "wget -q ${repo}/apache-cassandra-${version}-bin.tar.gz",
			logoutput 	=> "on_failure",
			creates		=> "${local_dir}/apache-cassandra-${version}-bin.tar.gz",
			timeout 	=> 0,
			require		=> Exec["creating_local_package_repo_for_${name}",
						"creating_target_for_${name}"];
		
			"extracting_apache-cassandra-${version}-bin.tar.gz_for_${name}":
			path    	=> ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
			cwd		=> $target,
			unless		=> "test -d ${target}/apache-cassandra-${version}/conf",
			command 	=> "tar -zxvf ${local_dir}/apache-cassandra-${version}-bin.tar.gz",
			logoutput       => "on_failure",
			creates		=> "${target}/apache-cassandra-${version}/conf",
                        timeout 	=> 0,        
                        require 	=> Exec["downloading_apache-cassandra-${version}-bin.tar.gz_for_${name}"];

			"setting_permission_for_${name}":
			path            => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
                        cwd             => $target,
			command         => "chown -R ${owner}:${owner} ${target}/apache-cassandra-${version}",
			logoutput       => "on_failure",
			timeout         => 0,
                        require 	=> Exec["extracting_apache-cassandra-${version}-bin.tar.gz_for_${name}"];
		}
	}

## Executes the deployment by pushing all necessary configurations and patches

	define deploy ( $service, $target, $owner, $group ) {
		
		file {  $target:
	                owner           => $owner,
	                group           => $group,
	                source          => ["puppet:///modules/common/configs",
	                                    "puppet:///modules/${service}/configs/"],
        	        sourceselect    => all,
			ignore		=> ".svn",
                	ensure          => present,
	                recurse         => true;
  
        	}
	}

## Starts the service once the deployment is successful.

	define start ( $target, $owner ) {
		exec { "strating_${name}":
			user		=> $owner,
			path            => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
	                command         => "sh ${target}/apache-cassandra-${version}/bin/cassandra -f > /dev/null 2>&1 &",
        	        creates         => "${target}/apache-cassandra-${version}/logs/apache-cassandra.log",
		}
	}
}
