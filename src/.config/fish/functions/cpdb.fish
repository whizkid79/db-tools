# todo: support ssh requests for source and target
# todo: create posibility to supply credentials to mysqldump or mysql

function cpdb --argument-names fromdb todb
	if [ (count $argv) -lt 2 ]
		echo "need to specify at least two parameters from and to"
		return 1
	end

	echo "$fromdb" | grep "^http" >/dev/null ; and begin
		# http mode
		set url $fromdb
		set fromdb (echo "$fromdb" | sed 's|.*://[^/]*/\([^?]*\)?.*|/\1|g')
		
   		set readcommand "wget -O- \"$url\" " 	
		set filemode "true"

	end; or begin

		echo "$fromdb" | grep ":" >/dev/null ; and begin
			# ssh mode from
			set sshmodefrom "true"
			set fromhost (echo "$fromdb" | sed -r 's|([^\:]+)\:(.*)|\1|g')
			set fromdb (echo "$fromdb" | sed -r 's|([^\:]+)\:(.*)|\2|g')
			return 2
		end;

		if [ -r "$fromdb" ]
   			set readcommand "cat \"$fromdb\" " 	
   			which pv>/dev/null; and set readcommand "pv \"$fromdb\" "
			set filemode "true"
	   	end
   	end
   		
	if [ "$filemode" = "true" ]
	    switch (echo "$fromdb" | tr '[:upper:]' '[:lower:]')
	 	    case '*.tar.bz2'
	    		which bunzip2>/dev/null; and begin 
	                set readcommand "$readcommand | bunzip2 -dc - | tar xO "
	    		end; or begin 
	            	echo "No bunzip2 available"; 
					return 2
	            end 
	
	    	case '*.bz'
	    		which bunzip>/dev/null; and begin 
	            	set readcommand "$readcommand | bunzip -c -"
	    		end; or begin 
	            	echo "No bunzip available"; 
					return 2
	            end 
	
	    	case '*.bz2'
	    		which bunzip2>/dev/null; and begin 
	            	set readcommand "$readcommand | bunzip2 -dc -"
	    		end; or begin 
	            	echo "No bunzip2 available"; 
					return 2
	            end 
	   		case '*.tar.lz' '*.tlz'
	    		which lzip>/dev/null; and begin 
	                set readcommand "$readcommand | lzip -dc - | tar xO "
	    		end; or which lunzip>/dev/null; and begin 
	                set readcommand "$readcommand | lunzip -dc - | tar xO "
	    		end; or begin 
	            	echo "No lzip or lunzip available"; 
					return 2
	            end 
	
	    	case '*.lz'
	    		which lzip>/dev/null; and begin 
	           		set readcommand "$readcommand | lzip -dc -"
	    		end; or which lunzip>/dev/null; and begin 
	            	set readcommand "$readcommand | lunzip -dc -"
	    		end; or begin 
	            	echo "No lzip or lunzip available"; 
					return 2
	            end 
	
	    	case '*.tar.lzma'
	    		which lzma>/dev/null; and begin 
	                set readcommand "$readcommand | lzma -dc - | tar xO "
	    		end; or begin 
	                echo "No lzma available"
					return 2
	            end
	            
	
	    	case '*.lzma'
	    		which lzma>/dev/null; and begin 
	                set readcommand "$readcommand | lzma -dc -"
	    		end; or begin 
	                echo "No lzma available"
					return 2
	            end
	            
	   		case '*.rar' '*.r[0-9][0-9]'
	            if [ -x "(which rar)" ];  
	            	set readcommand "$readcommand | rar v -"
	    		end; or which unrar>/dev/null; and begin 
	            	set readcommand "$readcommand | unrar v -"
	    		end; or begin 
	            	echo "No rar or unrar available"; 
					return 2
	            end 
	
	    	case '*.tar.gz' '*.tgz' '*.tar.z' '*.tar.dz'
	            set readcommand "$readcommand | tar xzO --force-local"
	            
	
	    	case '*.tar.xz' '*.txz'
	    		which xz>/dev/null; and begin 
	                set readcommand "$readcommand | xz -dc - | tar xO "
	    		end; or begin 
	                echo "No xz available"
					return 2
	            end
	            
	
	    	case '*.xz'
	    		which xz>/dev/null; and begin 
	                set readcommand "$readcommand | xz -dc -"
	    		end; or begin 
	                echo "No xz available"
					return 2
	            end
	            
	    	# Note that this is out of alpha order so that we don't catch
	    	# the gzipped tar endles.
	    	case '*.gz' '*.z' '*.dz'
	            set readcommand "$readcommand | gzip -dc - "
	
	    	case '*.tar'
	            set readcommand "$readcommand | tar xO --force-local"
	            
	
	   		case '*.jar' '*.war' '*.ear' '*.xpi' '*.zip'
	    		which unzip>/dev/null; and begin 
	            	set readcommand "$readcommand | unzip -v -";
	    		end; or which miniunzip>/dev/null; and begin 
	            	set readcommand "$readcommand | miniunzip -l -";
	    		end; or which miniunz>/dev/null; and begin 
	            	set readcommand "$readcommand | miniunz -l -";
	    		end; or begin 
	            	echo "No unzip, miniunzip or miniunz available"; 
					return 2
	            end 
	
	    	case '*.7z'
	    		which 7za>/dev/null; and begin 
	            	set readcommand "$readcommand | 7za l -";
	    		end; or which 7zr>/dev/null; and begin 
	            	set readcommand "$readcommand | 7zr l -";
	    		end; or begin 
	            	echo "No 7za or 7zr available"; 
					return 2
	            end 
	
	    	case '*.zoo'
	    		which zoo>/dev/null; and begin 
	            	set readcommand "$readcommand | zoo v -";
	    		end; or which unzoo>/dev/null; and begin 
	            	set readcommand "$readcommand | unzoo -l -";
	    		end; or begin 
	            	echo "No unzoo or zoo available"; 
					return 2
	            end 
		end
	else
		set readcommand "mysqldump --single-transaction -q -R $fromdb" 
	end
	
    switch (echo "$todb" | tr '[:upper:]' '[:lower:]')
    	case '*.bz'
    		which bzip>/dev/null; and begin 
            	set writecommand " | bzip > \"$todb\""
    		end; or begin 
            	echo "No bzip available"; 
				return 2
            end 

    	case '*.bz2'
    		which bzip2>/dev/null; and begin 
            	set writecommand " | bzip2 > \"$todb\""
    		end; or begin 
            	echo "No bzip2 available"; 
				return 2
            end 

    	case '*.gz'
            set writecommand " | gzip > \"$todb\" "	
    	case '*.sql'
			set writecommand " > \"$todb\"" 	

    	case '*'
    		newdb "$todb"
			set writecommand " |mysql \"$todb\"" 	
	end
	
	set cmd "$readcommand $writecommand"
	eval $cmd
end


