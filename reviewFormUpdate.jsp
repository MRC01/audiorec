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
			String	id, audiorec_id, release_id, reviewer_id, ratesound, rateperf, notes;
			id = request.getParameter("id");
			audiorec_id = request.getParameter("audiorec_id");
			release_id = request.getParameter("release_id");
			reviewer_id = request.getParameter("reviewer_id");
			ratesound = request.getParameter("ratesound");
			rateperf = request.getParameter("rateperf");
			notes = request.getParameter("notes");
			try {
				// NOTE: user can't change the foreign keys: release_id, reviewer_id
				Statement st = dbConnGet().createStatement();
				String sqlUpdate = "update reviews set"
					+ " ratesound = " + strToDb(ratesound)
					+ ", rateperf = " + strToDb(rateperf)
					+ ", notes = " + strToDb(notes)
					+ " where id=" + id;
				int rc = st.executeUpdate(sqlUpdate);
				if(rc == 1) {
					// success! return to the release screen
					response.sendRedirect("releaseMain.jsp?id=" + release_id);
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
