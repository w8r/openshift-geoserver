#!/bin/sh

# download the file from distro
echo "Downloading Geoserver 2.5.2 from sourceforge.net..."
curl -L http://sourceforge.net/projects/geoserver/files/GeoServer/2.5.2/geoserver-2.5.2-war.zip > geoserver.zip

echo "Extracting the .war ...";
mkdir -p geoserver-tmp
unzip -q geoserver.zip -d geoserver-tmp
mv ./geoserver-tmp/geoserver.war ./geoserver-tmp/geoserver.zip
unzip -q ./geoserver-tmp/geoserver.zip -d ./webapps/geoserver
rm -rf geoserver-tmp
rm geoserver.zip

echo "Enable JSONP? [y/n] (n): ";
read answer

# enbale JSONP
if [ "$answer" == "y" ]
then
    echo "Enabling JSONP output...";
    # sed is insane
    sed -e ':a' -e 'N' -e '$!ba' -e 's/<!--\n*[ ]*\(<[^>]*>\n*[ ]*<[^>]*>ENABLE_JSONP<\/[^>]*>[ ]*\n*[ ]*<[^>]*>[^<]*<\/[^>]*>\n*[ ]*<[^>]*>[ ]*\n*[ ]*\)-->/\1/g' ./webapps/geoserver/WEB-INF/web.xml > ./webapps/geoserver/WEB-INF/w.xml
    cat ./webapps/geoserver/WEB-INF/w.xml > ./webapps/geoserver/WEB-INF/web.xml
    rm ./webapps/geoserver/WEB-INF/w.xml
fi

echo "Remove pom.xml to avoid Maven builds? [y/n] (n): ";
read answer

if [ "$answer" == "y" ]
then
rm ./pom.xml
fi

echo "Done, geoserver is in the webapps folder, you can commit & deploy"
