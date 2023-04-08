<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Audio Review</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String	id, initials, lastname, firstname, misc, equip, prefs;
			initials = request.getParameter("initials");
			lastname = request.getParameter("lastname");
			firstname  = request.getParameter("firstname");
			misc = request.getParameter("misc");
			equip = request.getParameter("equip");
			prefs = request.getParameter("prefs");
			try {
				String sqlUpdate = "insert into reviewers"
					+ " (initials, lastname, firstname, misc, equipment, preferences)"
					+ " values ("
					+ strToDb(initials)
					+ ", " + strToDb(lastname)
					+ ", " + strToDb(firstname)
					+ ", " + strToDb(misc)
					+ ", " + strToDb(equip)
					+ ", " + strToDb(prefs)
					+ ")";
				PreparedStatement st = dbConnGet().prepareStatement(sqlUpdate, Statement.RETURN_GENERATED_KEYS);
				int rc = st.executeUpdate();
				if(rc > 0) {
					// success! get the generated primary key (ID)
					id = "";
					ResultSet rs = st.getGeneratedKeys();
					if(rs.next()) {
						id = rs.getString(1);
						if(id.length() > 0) {
							// success! redirect to the App Main page
							response.sendRedirect("appMain.jsp");
						}
						else {
							// Insert succeeded new ID had no value
							throw new Exception("Insert succeeded, but new ID had no value");
						}
					}
					else {
						// Insert succeeded but could not get generated ID
						throw new Exception("Insert succeeded but could not get new ID");
					}
				}
				else {
					// Update failed - this should never happen
					throw new Exception("Insert recording failed");
				}
			}
			catch(Exception ex) {
				%>
				<%@ include file="error.jsp" %>
				<%
				// reset the DB connection to force a reconnect next time
				dbConnReset();
			}
			%>
	</body>
</html>
