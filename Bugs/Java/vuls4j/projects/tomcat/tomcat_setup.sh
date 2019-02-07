#script for downloading TOMCAT_8_0_1 
#use java 1.7
#use ant 1.9.9

git clone https://github.com/apache/tomcat80.git
cd tomcat80
#copy build.properties.default file of TOMCAT_8_0_4 for use in TOMCAT_8_0_1
git checkout TOMCAT_8_0_4
cp build.properties.default ..
git checkout TOMCAT_8_0_1
rm build.properties.default
cd ..
cp build.properties.default tomcat80/
cd tomcat80
echo base.path=../lib > build.properties
#delete the default tomcat-users.xml file and make one with username:admin and password:admin
cd conf
rm tomcat-users.xml
echo "<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
	<role rolename=\"manager-gui\"/>
	<user username=\"admin\" password=\"admin\" roles=\"manager-gui\"/>
</tomcat-users>" > tomcat-users.xml
cd ..
mkdir logs
ant
cd output/build
#to start the server: ./bin/catalina.sh start
