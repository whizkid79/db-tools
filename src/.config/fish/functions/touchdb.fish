function touchdb --argument-names databasename mysqlparams
	echo "create database `$databasename` COLLATE utf8_general_ci;"|mysql -A $mysqlparams
end
