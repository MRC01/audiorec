<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Audio Recording</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String	id, title, composer, performer, soloist, director, genre, recdate, location, notes;
			id = request.getParameter("id");
			title = request.getParameter("title");
			composer = request.getParameter("composer");
			performer = request.getParameter("performer");
			soloist = request.getParameter("soloist");
			director = request.getParameter("director");
			genre = request.getParameter("genre");
			recdate = request.getParameter("recdate");
			location = request.getParameter("location");
			notes = request.getParameter("notes");
			try {
				Statement st = dbConnGet().createStatement();
				String sqlUpdate = "update audiorecs set"
					+ " title = " + strToDb(title)
					+ ", composer = " + strToDb(composer)
					+ ", performer = " + strToDb(performer)
					+ ", soloist = " + strToDb(soloist)
					+ ", director = " + strToDb(director)
					+ ", genre = " + strToDb(genre)
					+ ", recdate = " + strToDb(recdate)
					+ ", location = " + strToDb(location)
					+ ", notes = " + strToDb(notes)
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
