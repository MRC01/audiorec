<!DOCTYPE HTML>
<%
// The ID of the audiorec we are reviewing was passed to us
String	audiorec_id, audiorecRef;
audiorec_id = request.getParameter("id");
audiorecRef = "<a href=\"audiorecMain.jsp?id=" + audiorec_id + "\">Audio Recording</a>";
%>
<html>
	<head>
		<title>New Audio Review</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
		<font size="+2"><b><%= audiorecRef %></b></font>
		<!-- Show info about the recording being reviewed -->
		<%
		// We're given the audiorec ID
		try {
			Statement st = dbConnGet().createStatement();
			ResultSet rs = st.executeQuery(
					"select a.title, a.composer, a.performer, a.recdate, a.label"
					+ " from audiorecs a"
					+ " where a.id=" + audiorec_id
				);
			// There can be at most one record for this audiorec ID
			if(rs.next()) {
				%>
				<br>Title:<font size="-1"><%= strFromDb(rs.getString("title")) %></font>
				<br>Composer:<font size="-1"><%= strFromDb(rs.getString("composer")) %></font>
				<br>Performer:<font size="-1"><%= strFromDb(rs.getString("performer")) %></font>
				<br>Rec Date:<font size="-1"><%= strFromDb(rs.getString("recdate")) %></font>
				<br>Label:<font size="-1"><%= strFromDb(rs.getString("label")) %></font>
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
		<!-- List all the reviewers -->
		<%@ include file="reviewerList.jsp" %>
		<br>
		<b><font size="+2">New Review</font></b>
		<br>
		<form method=post action="reviewFormInsert.jsp">
			Audiorec ID <font size="-1"><%= audiorec_id %></font>
			<input type=hidden name=audiorec_id value="<%= audiorec_id %>">
			<br>Reviewer ID
			<input type=text name=reviewer_id size=20>
			<br>Sound (1-10)
			<input type=text name=ratesound size=20>
			<br>Performance (1-10)
			<input type=text name=rateperf size=20>
			<br>Notes
			<textarea name="notes" rows="4" cols="60"></textarea>
			<p>
			<input type=submit value="Submit">
		</form>
	</body>
</html>
