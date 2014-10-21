stage { 'configure': require => Stage['main'] }
stage { 'deploy': require => Stage['configure'] }

node basenode {
        $package_repo           		= "https://svn.wso2.org/repos/wso2/people/gokul/bam/19-09/"
        $hadoop_package_repo    		= "http://mirror.reverse.net/pub/apache/hadoop/common/stable1/"
        $cassandra_package_repo                 = "http://apache.mesi.com.ar/cassandra/1.2.18/"
        $depsync_repo_url       		= "https://svn.domain.com/repo/"
        $local_package_dir      		= "/mnt/packs"
        $deploy_new_packs       		= "true"
        $java_name              		= "jdk1.6.0_32"
        $java_distribution      		= "jdk-6u32-linux-x64.bin"
        $java_home              		= "/opt/jdk1.6.0_32"
}

node confignode inherits basenode  {
     ## Service subdomains
        $domain_name               		= "wso2.dev.com"
      
     ## Puppet master
        $puppet_master_ip          		= "10.0.0.30"
        $puppet_master_host        		= "puppet.$domain_name"

     ## BAM node witout cassandra
        $bam_receiver_analyzer1_ip 		= "10.0.0.76"
        $bam_receiver_analyzer2_ip 		= "10.0.0.77"

        $bam_receiver_analyzer1_host 		= "bam1.$domain_name"
        $bam_receiver_analyzer2_host 		= "bam2.$domain_name"

     ## BAM Receiver node
        $bam_receiver1_ip            		= "10.0.0.76"
        $bam_receiver2_ip 	     		= "10.0.0.77"

        $bam_receiver1_host           		= "receiver1.$domain_name"
        $bam_receiver2_host           		= "receiver2.$domain_name"
        
        # Receiver will listen on all network interfaces
        $receiver_listen_ip                     = "0.0.0.0"     
 
    ## BAM Analyzer  
        $bam_analyzer1_ip 			= "10.0.0.76"
        $bam_analyzer2_ip 			= "10.0.0.77"

        $bam_analyzer1_host           		= "analyzer1.$domain_name"
        $bam_analyzer2_host           		= "analyzer2.$domain_name"
      
     ## Hadoop node 
        $hadoop1_ip      			= "10.0.0.78"
        $hadoop2_ip      			= "10.0.0.79"
        $hadoop3_ip      			= "10.0.0.80"        

        $hadoop1_hostname      			= "hadoop1.$domain_name"
        $hadoop2_hostname      			= "hadoop2.$domain_name"
        $hadoop3_hostname      			= "hadoop3.$domain_name"

     ## Apache Cassandra node 
        $css1_ip            			= "10.0.0.78"
        $css2_ip            			= "10.0.0.79"
        $css3_ip            			= "10.0.0.80"
        $css4_ip            			= "10.0.0.81"

        $css1_domain        			= "cassandra1.$domain_name"
        $css2_domain        			= "cassandra2.$domain_name"
        $css3_domain       		 	= "cassandra3.$domain_name"
        $css4_domain        			= "cassandra4.$domain_name"

        $bam_analyzer_subdomain          	= "wso2.bam.domain"
        $governance_registry_domain      	= "$bam_analyzer_subdomain"

     ## MySQL server 
        $mysql_server_ip        		= "10.0.0.31"
        $mysql_server_hostname  		= "mysqlserver.$domain_name"
        $mysql_server_port      		= "3306"

        $mysql_username         		= "root"
        $mysql_password 			= "rootpw"
        $mysql_root_password    		= "rootpw"
 
        $mysql_driver_jar_name                  = "mysql-connector-java-5.0.8-bin.jar"

     ## Datasource  configuration details
        $max_connections        		= "100000"
        $max_active             		= "150"
        $max_wait               		= "360000"

     ## Deployment Synchronizer
        $manager_node                           = "analyzer1.$domain_name"
        $dep_sync_enable                        = "true"
        $repository_type        		= "svn"
        $svn_user               		= "wso2"
        $svn_password           		= "XXXXXXXXXXXX"

     ## Database details

        $gov_registry_db            		= "gov_registry"
        $gov_registry_database_url  		= "jdbc:mysql://$mysql_server_hostname:$mysql_server_port/$gov_registry_db"
        $gov_registry_user          		= $mysql_username
        $gov_registry_password      		= $mysql_password
        $gov_registry_database_driver 		= "com.mysql.jdbc.Driver"
   
        $conf_registry_db            		= "bam_conf_registry"
        $conf_registry_database_url  		= "jdbc:mysql://$mysql_server_hostname:$mysql_server_port/$conf_registry_db"
        $conf_registry_user          		= $mysql_username
        $conf_registry_password      		= $mysql_password
        $conf_registry_database_driver 		= "com.mysql.jdbc.Driver"

        $userstore_db            		= "userstore"
        $userstore_database_url  		= "jdbc:mysql://$mysql_server_hostname:$mysql_server_port/$userstore_db"
        $userstore_user          		= $mysql_username
        $userstore_password      		= $mysql_password
        $userstore_database_driver 		= "com.mysql.jdbc.Driver"
     
        $metastore_db                		= "metastore_db"
        $hive_metastore_database_url      	= "jdbc:mysql://$mysql_server_hostname:$mysql_server_port/$metastore_db"
        $hive_metastore_user          		= $mysql_username
        $hive_metastore_password      		= $mysql_password
        $hive_metastore_driver 			= "com.mysql.jdbc.Driver"

  ## Userstore details
        $admin_user             		= "admin123"
        $admin_password         		= "admin" 

  ## BAM summary database
        $summary_db            			= "summary"
        $summary_database_url  			= "jdbc:mysql://$mysql_server_hostname:$mysql_server_port/$summary_db"
        $summary_user          			= $mysql_username
        $summary_password      			= $mysql_password
        $summary_database_driver 		= "com.mysql.jdbc.Driver"

  ## Cassandra details
        $css_token_1        			= "-9223372036854775808"
        $css_token_2        			= "-4611686018427387904"
        $css_token_3        			= "0"
        $css_token_4        			= "4611686018427387904"
       
        $css_cluster_name       		= "BAM Test Setup"
        $css_port               		= "9160"
        $cassandra_username     		= "cassandrauser"
        $cassandra_password     		= "cassandrapw"
        $css_replication_factor 		= "3"
        $strategy_class         		= "org.apache.cassandra.locator.SimpleStrategy"
        $read_consistency_level 		= "QUORUM"
        $write_consistency_level		= "QUORUM"
        $gc_grace_interval      		= "864000"
        $seeds_provider_host    		= $css1_domain

## Hadoop details
        $hadoop_master         			= $hadoop1_hostname
        $hdfs_domain           			= $hadoop1_hostname
        $hdfs_url              			= "$hdfs_domain:9000"
        $hdfs_job_tracker_url  			= "$hdfs_domain:9001"

        $master_nodes          			= $hadoop_master
        $slave_nodes           			= [$hadoop1_hostname, $hadoop2_hostname, $hadoop3_hostname]
       
        $hadoop_user 	       			= "hadoop"
        $hadoop_user_group     			= "hadoop"
        $hadoop_pw             			= "hadooppw"
      
        $dfs_replication        		= "1"
        $hadoop_heapsize        		= "1024"

  ## BAM Clustering details
        $membership_scheme                      = "wka"
        $wk_member_ips                          = [$bam_receiver1_ip, $bam_receiver2_ip,$bam_analyzer1_ip]

  ## NTask details
        $task_mode             			= "CLUSTERED"
        $task_server_count     			= "2"

  ## BAM Analyzer details
        $analyzer_subdomain     		= "analyzer"

  ## Server details for billing
        $time_zone              		= "GMT-8:00"
}

node /^receiver.analyzer\d+$/ inherits confignode{
   include system_config
   include setup

   $server_ip  = $ipaddress
   notice ("Host name ${fqdn}")

  if $fqdn =~ /^receiver.analyzer(\d+)/ {
       $host_unique_id = $1
  }else{
       $host_unique_id = "1"
  }
      
  $node_offset = 0 * $host_unique_id
  $mgt_host_name = $fqdn
  $multicast_port = 4000 +  $node_offset
  notice("Unique id \$host_unique_id ${host_unique_id} ")

   class {"setup::bam_receiver_analyzer":
                version            => "2.5.0",
                offset             => $node_offset,
                cluster_port       => $multicast_port,
                config_db          => "bam_config",
                maintenance_mode   => "true",
                depsync            => "true",
                owner              => "kurumba",
                group              => "kurumba",
                target             => "/mnt/${server_ip}/${mgt_host_name}",
                stage              => "deploy",
        }
}

node /^analyzer\d+$/ inherits confignode{
   include system_config
   include setup

   $server_ip  = $ipaddress
   notice ("Host name ${fqdn}")

  if $fqdn =~ /^analyzer(\d+)/ {
       $host_unique_id = $1
  }else{
       $host_unique_id = "1"
  }

  $node_offset = 0 * $host_unique_id
  $mgt_host_name = $fqdn
  $multicast_port = 4000 +  $node_offset
  notice("Unique id \$host_unique_id ${host_unique_id} ")

   class {"setup::bam_analyzer":
                version            => "2.5.0",
                offset             => $node_offset,
                cluster_port       => $multicast_port,
                config_db          => "bam_config",
                maintenance_mode   => "true",
                depsync            => "true",
                owner              => "kurumba",
                group              => "kurumba",
                target             => "/mnt/${server_ip}/${mgt_host_name}",
                stage              => "deploy",
        }
}


node /^receiver\d+$/ inherits confignode{
   include system_config
   include setup

   $server_ip  = $ipaddress
   notice ("Host name ${fqdn}")

  if $fqdn =~ /^receiver(\d+)/ {
       $host_unique_id = $1
  }else{
       $host_unique_id = "1"
  }

  $node_offset = 0 * $host_unique_id
  $mgt_host_name = $fqdn
  $multicast_port = 4000 +  $node_offset
  notice("Unique id \$host_unique_id ${host_unique_id} ")

   class {"setup::bam_receiver":
                version            => "2.5.0",
                offset             => $node_offset,
                maintenance_mode   => "true",
                depsync            => "true",
                owner              => "kurumba",
                group              => "kurumba",
                target             => "/mnt/${server_ip}/${mgt_host_name}",
                stage              => "deploy",
        }
}



node /^cassandra\d+$/ inherits confignode{
   include system_config
   include setup

   $server_ip  = $ipaddress
   notice ("Host name ${fqdn}")

  if $fqdn =~ /^cassandra(\d+)/ {
       $host_unique_id = $1
  }else{
       $host_unique_id = "1"
  }

  # If you need to apply offset uncomment the below line
  # $node_offset = 10 * $host_unique_id
 
  $node_offset = 0  

  $mgt_host_name = $fqdn
  notice("Unique id \$host_unique_id ${host_unique_id} ")

  $variable_name =  "css_token_${host_unique_id}"

  $initial_cassandra_token= inline_template("<%= scope.lookupvar(variable_name) %>")
  notice ("initial token = ${initial_cassandra_token}")

   class {"cassandra_setup::cassandra":
                version            => "1.2.18",
                owner              => "kurumba",
                group              => "kurumba",
                target             => "/mnt/${server_ip}/${mgt_host_name}",
        }
}


node hadoopbase inherits confignode{
   include hadoop_ssh
   include setup
   include java
}


node /^hadoop\d+$/ inherits hadoopbase{
   include hadoop_ssh
   include setup
  
   if $fqdn =~  /^hadoop1/ {
     notice ("master true")
     $isMaster = "true"
   }else{
     notice ("master false")
     $isMaster = "false"
   }

   class{"hadoop_setup::hadoop":
              version            => "1.2.1",
              slave              => "true",
              master             => "false",
              owner              => $hadoop_user,
              group              => $hadoop_user_group,
              target             => "/home/${hadoop_user}/hadoopNode",
              stage              => "deploy",
    }
}

node mysqlserver inherits confignode{
   include system_config
   include setup
   include mysql_server
 }

