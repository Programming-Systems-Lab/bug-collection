#script for downloading and running apache sling
#use java 1.8 or higher
#use maven 3.3.9 or later

#obtain previous version of servlets post bundle
git clone https://github.com/apache/sling-org-apache-sling-servlets-post
cd sling-org-apache-sling-servlets-post
git checkout org.apache.sling.servlets.post-2.1.0
mvn clean install
cp target/org.apache.sling.servlets.post-2.1.0.jar ..
cd ..
#obtain a necessary additional bundlefile
curl http://central.maven.org/maven2/org/apache/sling/org.apache.sling.commons.json/2.0.6/org.apache.sling.commons.json-2.0.6.jar --output org.apache.sling.commons.json-2.0.6.jar
git clone https://github.com/apache/sling-org-apache-sling-starter.git
cd sling-org-apache-sling-starter
mvn clean install 
#start the server and upload bundlefiles
java -jar target/org.apache.sling.starter-11-SNAPSHOT.jar & 
while [ true ]; do
	sleep 15
	curl "http://localhost:8080/starter/index.html" | grep "Sling applications use either scripts or Java servlets, selected" &> /dev/null
	if [ $? == 0 ]; then
		break
	fi
done
sh /Users/Winston/Desktop/Sling\ Exploit/fileupload.sh
