<%@ page import="java.sql.*" %>
<%!
	static final String driverClassName = "org.postgresql.Driver"
			, connectionURL = "jdbc:postgresql://mclements3:5432/audiorec_rec_release"
			, dbUser = "sa"
			, dbPwd = "sa123"
			;

	// lazy instantiated shared DB connection (singleton)
	static Connection dbConn = null;
	// can't synchronize on dbConn since it's sometimes null
	static Object lock = new Object();

	// Get the DB connection, create if necessary
	static Connection dbConnGet() throws Exception {
		if(dbConn == null) {
			synchronized(lock) {
				if(dbConn == null) {
					Class.forName(driverClassName).newInstance();
					dbConn = DriverManager.getConnection(connectionURL, dbUser, dbPwd);
				}
			}
		}
		return dbConn;
	}

	// Close & discard the DB connection, nullify it so the next Get will recreate it
	static void dbConnReset() throws Exception {
		if(dbConn != null) {
			try {
				dbConn.close();
			}
			catch(Exception e) {
				// squash any exceptions
			}
		}
		dbConn = null;
	}
%>
