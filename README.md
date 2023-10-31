This is Mike's audio recording database application.

*Database*
Implemented in Postgres

*Web Server*
Runs in Tomcat version 7 or 9

*JSP Application*
Source code: \[Your local directory\]/audiorec<br/>
Deploy home: /var/lib/tomcat9/webapps/audiorec<br/>

Any files you change in the source dir must be copied to the deploy dir.
They take effect immediately; no need to restart Tomcat.

*Getting Started*

This app uses PostgreSQL. If you don't already have it installed, you need to do that first. Then create a new database called 'audiorec'. Then run the SQL File 'schemaCreate.sql' to create the schema for this project: tables, triggers, etc.

Next, edit the file 'dbStuff.jsp' and set the server, port, and account to use to connect to your database.

This app also uses Tomcat. If you don't already have it installed, you need to do that first. Then create a new directory under Tomcat webapps - see "Deploy home" above. Copy all the JSP files for this project to that directory.

You must add the PostgreSQL JDBC JAR file to the Tomcat classpath. This JAR is not included in the PostgreSQL server or client installations. You must find and download it separately. For PostgreSQL version 14:

JAR file: postgresql-42.6.0.jar<br/>
Tomcat dir: /usr/share/tomcat9/lib<br/>

You're done - the app is ready to use.

*Running the App*

Ensure Tomcat is running and point your browser to "http://SERVERNAME:8080/audiorec/AppMain.jsp"

*PostgreSQL Bug*

Here's a PostgreSQL bug that I found:

Consider an erroneous SQL statement like this, because the column "release_id" doesn't exist.

select release_id from releases where audiorec_id=1

Now wrap it in a delete, like this:

select * from reviews where release_id in (select release_id from releases where audiorec_id=1);

This deletes ALL rows in reviews!
However, if you replace the erroneous statement with another like this:

select * from reviews where release_id in (select foobar from releases where audiorec_id=1);

Postgres will return a SQL error, like it should.
The problem seems to be that column release_id does not exist, but it resembles column releaseid, which does exist.
This shouldn't matter, but apparently it does!
