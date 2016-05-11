function newdb --argument-names databasename mysqlparams
	echo "drop database if exists `$databasename`;create database `$databasename` COLLATE utf8_general_ci;"|mysql -A $mysqlparams
end
