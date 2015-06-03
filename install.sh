#!/bin/sh

read -r -p "Release: Stable/Maintenance? [S/m]: " response
if [[ $response =~ ^([mM])$ ]]
then
    release="maintain"
else
    release="stable"
fi

echo "Getting link to $release.war..."
html=$(curl -s "http://geoserver.org/release/${release}/")
until [ -n "$html" ]
do
	sleep 10
	html=$(curl -s "http://geoserver.org/release/${release}/")
done

base=$(echo "$html" | grep -o -E 'url = "([^"#]+)"' | cut -d'"' -f2)
file=$(echo "$html" | grep -o -E 'artifact = "([^"]+)"' | cut -d'"' -f2)
url="${base}${file}-war.zip"
extensions_url="${base}extensions/"

mkdir -p tmp
echo "Downloading $url"
curl -L "$url" > ./tmp/geoserver.zip
unzip -q ./tmp/geoserver.zip -d ./tmp
unzip -q ./tmp/geoserver.war -d ./webapps/geoserver

read -r -p "Extensions? [y/N]: " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	plugin_urls=$(curl -s "$extensions_url" | grep -o -E '<a href="([^"#]+)download"' | cut -d'"' -f2)
	for url in $plugin_urls; do
		plugin_name=${url/${extensions_url}${file}-/}
		plugin_name=${plugin_name/\/download/}
	
		read -r -p " - ${plugin_name/\.zip/} [y/N]: " response
		if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
		then
			echo "Downloading ${plugin_name}"
			curl -L "${url}" > tmp/$plugin_name
			unzip -q tmp/$plugin_name -d ./webapps/geoserver/WEB-INF/lib/
		fi
	done
fi

read -p "Enable JSONP? [Y/n]: " response
if ! [[ $response =~ ^([nN][oO]|[nN])$ ]]
then
	# sed is insane
	sed -e ':a' -e 'N' -e '$!ba' -e 's/<!--\n*[ ]*\(<[^>]*>\n*[ ]*<[^>]*>ENABLE_JSONP<\/[^>]*>[ ]*\n*[ ]*<[^>]*>[^<]*<\/[^>]*>\n*[ ]*<[^>]*>[ ]*\n*[ ]*\)-->/\1/g' ./webapps/geoserver/WEB-INF/web.xml > ./webapps/geoserver/WEB-INF/w.xml
	cat ./webapps/geoserver/WEB-INF/w.xml > ./webapps/geoserver/WEB-INF/web.xml
	rm ./webapps/geoserver/WEB-INF/w.xml
	echo "  * JSONP output enabled"
fi

read -p "Remove pom.xml to avoid Maven builds? [Y/n]: " response
if ! [[ $response =~ ^([nN][oO]|[nN])$ ]]
then
	rm ./pom.xml
	echo "  * pom.xml deleted"
fi

rm -rf ./tmp
echo "Done, geoserver is in the webapps folder, you can commit & deploy"
