This is Mike's audio recording database application.

*Database*
Implemented in Postgres

*Web Server*
Runs in Tomcat version 7 or 9

*JSP Application*
Source code: \[Your local directory\]/audiorec
Deploy home: /var/lib/tomcat9/webapps/audiorec

Any files you change in the source dir must be copied to the deploy dir.
They take effect immediately; no need to restart Tomcat.

*Getting Started*

This app uses PostgreSQL. If you don't already have it installed, you need to do that first. Then create a new database called 'audiorec'. Then run the SQL File 'schemaCreate.sql' to create the schema for this project: tables, triggers, etc.

Next, edit the file 'dbStuff.jsp' and set the server, port, and account to use to connect to your database.

This app also uses Tomcat. If you don't already have it installed, you need to do that first. Then create a new directory under Tomcat webapps - see "Deploy home" above. Copy all the JSP files for this project to that directory.

You're done - the app is ready to use.

*Running the App*

Ensure Tomcat is running and point your browser to "http://SERVERNAME:8080/audiorec/AppMain.jsp"
