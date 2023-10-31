<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Audio Recording Release</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String	id, label, release, releaseid, reldate, format, channels, dynrange, notes;
			id = request.getParameter("id");
			label = request.getParameter("label");
			release = request.getParameter("release");
			releaseid = request.getParameter("releaseid");
			reldate = request.getParameter("reldate");
			format  = request.getParameter("format");
			channels = request.getParameter("channels");
			dynrange = request.getParameter("dynrange");
			notes = request.getParameter("notes");
			try {
				Statement st = dbConnGet().createStatement();
				String sqlUpdate = "update releases set"
					+ " label = " + strToDb(label)
					+ ", release = " + strToDb(release)
					+ ", releaseid = " + strToDb(releaseid)
					+ ", reldate = " + strToDb(reldate)
					+ ", format = " + strToDb(format)
					+ ", channels = " + strToDb(channels)
					+ ", dynrange = " + strToDb(dynrange)
					+ ", notes = " + strToDb(notes)
					+ " where id=" + id;
				int rc = st.executeUpdate(sqlUpdate);
				if(rc == 1) {
					// success! return to the main release screen
					response.sendRedirect("releaseMain.jsp?id=" + id);
				}
				else {
					// Update failed - this should never happen
					throw new Exception("Update release " + id + " failed");
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
