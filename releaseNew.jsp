<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<%
// The ID of the audiorec for this release was passed to us
String	audiorec_id, audiorecRef;
audiorec_id = request.getParameter("id");
audiorecRef = "<a href=\"audiorecMain.jsp?id=" + audiorec_id + "\">Audio Recording</a>";
%>
<html>
	<head>
		<title>New Audio Recording Release</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
		<font size="+1"><b><%= audiorecRef %></b></font>
		<!-- Show info about the recording being reviewed -->
		<%
		// We're given the audiorec ID
		try {
			Statement st = dbConnGet().createStatement();
			ResultSet rs = st.executeQuery(
					"select a.title, a.composer, a.performer, a.soloist, a.director, a.recdate"
					+ " from audiorecs a"
					+ " where a.id=" + audiorec_id
				);
			// There can be at most one record for this audiorec ID
			if(rs.next()) {
				%>
				<br>Title:<font size="-1"><%= strFromDb(rs.getString("title")) %></font>
				<br>Composer:<font size="-1"><%= strFromDb(rs.getString("composer")) %></font>
				<br>Performer:<font size="-1"><%= strFromDb(rs.getString("performer")) %></font>
				<br>Soloist:<font size="-1"><%= strFromDb(rs.getString("soloist")) %></font>
				<br>Director:<font size="-1"><%= strFromDb(rs.getString("director")) %></font>
				<br>Rec Date:<font size="-1"><%= strFromDb(rs.getString("recdate")) %></font>
				<%
			}
			else {
				// No record for this ID (this should never happen)
				throw new Exception("No audiorec having ID " + audiorec_id);
			}
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
		<p>
		<!-- List all the releases -->
		<jsp:include page="audiorecReleases.jsp">
			<jsp:param name="id" value="<%= audiorec_id %>"/>
		</jsp:include>
		<br>
		<b><font size="+2">New Release</font></b>
		<br>
		<form method=post action="releaseFormInsert.jsp">
			Audiorec ID <font size="-1"><%= audiorec_id %></font>
			<input type=hidden name=audiorec_id value="<%= audiorec_id %>">
			<br>Label
			<input type=text name=label size=40>
			<br>Release
			<input type=text name=release size=40>
			<br>Release ID
			<input type=text name=releaseid size=40>
			<br>Rel Date
			<input type=text name=reldate size=40>
			<br>Format
			<input type=text name=format size=40>
			<br>Channels
			<input type=text name=channels size=40>
			<br>Dynamic Range
			<input text=text name=dynrange size=40>
			<br>Rel Notes
			<input text=text name=notes size=40>
			<p>
			<input type=submit value="Submit">
		</form>
	</body>
</html>
