drop database gov_registry;
create database gov_registry;
use gov_registry;
source /etc/puppet/scripts/mysql.sql;

drop database bam_conf_registry;
create database bam_conf_registry;
use bam_conf_registry;
source /etc/puppet/scripts/mysql.sql;

drop database userstore;
create database userstore;
use userstore;
source /etc/puppet/scripts/mysql.sql;

drop database metastore;
create database metastore;

drop database summary;
create database summary;




