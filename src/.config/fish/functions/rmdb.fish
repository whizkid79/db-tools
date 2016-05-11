function rmdb --argument-names databasename mysqlparams
	echo "drop database `$databasename`;"|mysql -A $mysqlparams]
end
