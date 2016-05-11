function lsdb
	if [ (count $argv) -gt 0 ]
		echo "show databases"|mysql -A |tail -n+2 | grep --color=never "^$argv"
	else
		echo "show databases"|mysql -A |tail -n+2
	end
end
