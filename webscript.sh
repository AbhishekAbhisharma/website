echo "checking diff"
for i in `host`; do 
    setupcompleted=`grep ^$i completed-setup.db` 
    echo "---test $setupcompleted test---"
    if [ -z "$setupcompleted" ]; then
		#print msg
		echo creating new hvost for $i
	
		## Create apache vhost conf file for each customer
        	cp template-vhost.conf_tmp $i.conf

		# Update conf file and define servername
		echo "create conf file"
		sed -i "s/SERVERNAME/$i/" $i.conf
        	#create html
		echo "create html file"
        	echo "<h1>Hello $i  "  > $i.html	

       		#deploy setup
		echo "deployment started..."
       		## copy conf files
		echo "copy files to server"
       		scp -o StrictHostKeyChecking=no $i.* ubuntu@54.89.156.244:/tmp/
       		## create document root directory
		echo "create doc root dir to server"
       		ssh -t -o StrictHostKeyChecking=no ubuntu@54.89.156.244 sudo mkdir /var/www/html/$i
       		## move conf and web file to their localtion

		echo "move conf and html file"
       		ssh -t -o StrictHostKeyChecking=no ubuntu@54.89.156.244 sudo mv /tmp/$i.conf /etc/apache2/sites-enabled/$i.conf
       		ssh -t -o StrictHostKeyChecking=no ubuntu@54.89.156.244 sudo mv /tmp/$i.html /var/www/html/$i/index.html
       		##restart apache 
       		echo "reload apache"
       		ssh -t -o StrictHostKeyChecking=no ubuntu@54.89.156.244 sudo systemctl reload apache2
       		echo "$i"  >> completed-setup.db
    fi
echo -e "\n deployment complted"    
done
