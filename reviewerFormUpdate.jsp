<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Audio Reviewer</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String	id, initials, lastname, firstname, misc, equip, prefs;
			id = request.getParameter("id");
			initials = request.getParameter("initials");
			lastname = request.getParameter("lastname");
			firstname = request.getParameter("firstname");
			misc = request.getParameter("misc");
			equip = request.getParameter("equip");
			prefs = request.getParameter("prefs");
			try {
				Statement st = dbConnGet().createStatement();
				String sqlUpdate = "update reviewers set"
					+ " initials = " + strToDb(initials)
					+ ", lastname = " + strToDb(lastname)
					+ ", firstname = " + strToDb(firstname)
					+ ", misc = " + strToDb(misc)
					+ ", equipment = " + strToDb(equip)
					+ ", preferences = " + strToDb(prefs)
					+ " where id=" + id;
				int rc = st.executeUpdate(sqlUpdate);
				if(rc == 1) {
					// success! return to the main reviewer screen
					response.sendRedirect("reviewerNew.jsp");
				}
				else {
					// Update failed - this should never happen
					throw new Exception("Update audio review " + id + " failed");
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
