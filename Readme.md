# Run [Geoserver](http://geoserver.org) on [Openshift](https://www.openshift.com/) free cloud hosting

For everyone who was desperate to run a Geoserver instance on a free hosting to try it out or for some other purpose.
Openshift is your choice, it offers a free java application hosting with a decent selection of environments and presets. And the most amazing thing is that if get even one `High-CPU gear`, the performance is __really__ good.

## What it does

* Grabs a link to sourcefourge distro from geoserver website (you can choose stable[default] or maintainance release)
* Downloads `.war` file and unzips it into the `webapps/geoserver` folder, that's where your geoserver will run
* Grabs the list of available plugins and allows you to select which of them you want to downlad and install
* Optionally turns on the much needed `JSONP` support [default]
* Optionally removes `pom.xml` file to disable maven builds on deploy [default]

## In short

```shell
$ rhc app create myapp jbossews-1.0
$ git clone ssh://<Your Openshift key>@myapp-organisation.rhcloud.com/~/git/myapp.git/ myapp
$ cd myapp
$ bash <(curl -s https://raw.githubusercontent.com/w8r/openshift-geoserver/master/install.sh) 2>&1
$ git add --all
$ git commit -m "geoserver"
$ git push origin master
$ open http://myapp-organisation.rhcloud.com/geoserver/
```

That's it. Deploying will take some time, so I suggest you putting your `.shp`s, `.sld`s or whatever into the `webapps/geoserver/data/data` folder before the first push.

## Step by step

1. Get a free trial account, install their toolkit, everything quite simple, just like heroku
2. I strongly suggest to upgrade to Bronze plan, the use of high-cpu gears really makes difference, but you can omit this step
3. Create a new application, I suggest Tomcat 6(JBoss EWS 1.0), but it works with version 7 as well
4. Follow the instructions, clone out the application repo
5. `cd` into the repo dir
6. run following command

```shell
$ bash <(curl -s https://raw.githubusercontent.com/w8r/openshift-geoserver/master/install.sh) 2>&1
```

