<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Audio Recording</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Audio Recording</a></h1>
			<%
			String	id, title, composer, performer, soloist, director, genre, label, release, releaseid, recdate, location, format, channels, dynrange, notes;
			id = request.getParameter("id");
			title = request.getParameter("title");
			composer = request.getParameter("composer");
			performer = request.getParameter("performer");
			soloist = request.getParameter("soloist");
			director = request.getParameter("director");
			genre = request.getParameter("genre");
			label = request.getParameter("label");
			release = request.getParameter("release");
			releaseid = request.getParameter("releaseid");
			recdate = request.getParameter("recdate");
			location = request.getParameter("location");
			format = request.getParameter("format");
			channels = request.getParameter("channels");
			dynrange = request.getParameter("dynrange");
			notes = request.getParameter("notes");
			try {
				Statement st = dbConnGet().createStatement();
				String sqlUpdate = "update audiorecs set"
					+ " title = '" + strToDb(title) + "'"
					+ ", composer = '" + strToDb(composer) + "'"
					+ ", performer = '" + strToDb(performer) + "'"
					+ ", soloist = '" + strToDb(soloist) + "'"
					+ ", director = '" + strToDb(director) + "'"
					+ ", genre = '" + strToDb(genre) + "'"
					+ ", label = '" + strToDb(label) + "'"
					+ ", release = '" + strToDb(release) + "'"
					+ ", releaseid = '" + strToDb(releaseid) + "'"
					+ ", recdate = '" + strToDb(recdate) + "'"
					+ ", location = '" + strToDb(location) + "'"
					+ ", format = '" + strToDb(format) + "'"
					+ ", channels = '" + strToDb(channels) + "'"
					+ ", dynrange = '" + strToDb(dynrange) + "'"
					+ ", notes = '" + strToDb(notes) + "'"
					+ " where id=" + id;
				int rc = st.executeUpdate(sqlUpdate);
				if(rc == 1) {
					// success! return to the main audiorec screen
					response.sendRedirect("audiorecMain.jsp?id=" + id);
				}
				else {
					// Update failed - this should never happen
					throw new Exception("Update recording " + id + " failed");
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
