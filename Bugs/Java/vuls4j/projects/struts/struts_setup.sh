git clone https://github.com/apache/struts
cd struts/
git checkout STRUTS_2_3_30
mvn package -DskipTests
cd apps/showcase
mvn jetty:run

