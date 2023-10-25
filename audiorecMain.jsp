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
			// The given ID is for the audiorec
			String id = request.getParameter("id");
			try {
				Statement st = dbConnGet().createStatement();
				ResultSet rs = st.executeQuery(
						"select id, title, composer, performer, soloist, director, genre"
						+ ", recdate, location, notes, date_created, date_updated"
						+ " from audiorecs"
						+ " where id=" + id
					);
				// There can be at most one record for this ID
				if(rs.next()) {
					%>
					<form method=post action="audiorecFormUpdate.jsp">
						<font size="+1">Audiorec ID </font><%= strFromDb(rs.getString("id")) %></font>
						<br>Date Created: <font size="-1"><%= strFromDb(rs.getString("date_created")) %></font>
						<br>Date Updated: <font size="-1"><%= strFromDb(rs.getString("date_updated")) %></font>
						<input type=hidden name=id value="<%= strFromDb(rs.getString("id")) %>">
						<br>Title
						<input type=text name=title size=40 value="<%= strFromDb(rs.getString("title")) %>">
						<br>Composer
						<input type=text name=composer size=40 value="<%= strFromDb(rs.getString("composer")) %>">
						<br>Performer
						<input type=text name=performer size=40 value="<%= strFromDb(rs.getString("performer")) %>">
						<br>Soloist
						<input type=text name=soloist size=40 value="<%= strFromDb(rs.getString("soloist")) %>">
						<br>Director
						<input type=text name=director size=40 value="<%= strFromDb(rs.getString("director")) %>">
						<br>Genre
						<input type=text name=genre size=40 value="<%= strFromDb(rs.getString("genre")) %>">
						<br>Date
						<input type=text name=recdate size=40 value="<%= strFromDb(rs.getString("recdate")) %>">
						<br>Location
						<input type=text name=location size=40 value="<%= strFromDb(rs.getString("location")) %>">
						<br>Notes
						<input type=text name=notes size=40 value="<%= strFromDb(rs.getString("notes")) %>">
						<p>
						<input type=submit value="Submit">
					</form>
					<!--
						NOTE: MRC: 211229
						All Java code executes on the server before the page loads.
						Thus, the page cannot conditionally execute Java code.
						To make the delete conditional upon a warning, this page MUST redirect to another page for delete.
					-->
					<button name="delete" type="button" onclick="del()">Delete Audiorec</button>
					<script>
						function del() {
							qp = new URLSearchParams(location.search)
							id = qp.get("id")
							var response = confirm("Delete recording " + id + " (and all its releases & reviews)?")
							if(response) {
								window.location.href = "audiorecDelete.jsp?id=" + id
							}
					    }
					</script>
					<p>
					<%
				}
				else {
					// No record for this ID (this should never happen)
					throw new Exception("No recording having ID " + id);
				}
				// Show all releases for this recording
				%>
				<jsp:include page="audiorecReleases.jsp">
					<jsp:param name="id" value="<%= strFromDb(rs.getString(\"id\")) %>"/>
				</jsp:include>
				<%
				rs.close();
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
