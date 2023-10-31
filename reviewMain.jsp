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
		// We're given the review ID
		String id = request.getParameter("id");
		try {
			Statement st = dbConnGet().createStatement();
			ResultSet rs = st.executeQuery(
					"select r.id, r.release_id, a.id as audiorec_id, r.reviewer_id"
					+ ", r.date_created, r.date_updated"
					+ ", r.ratesound, r.rateperf, r.notes, r.date_created, r.date_updated"
					+ ", a.title, a.composer, a.performer, a.recdate"
					+ ", l.label, l.release, l.reldate, l.format"
					+ ", v.initials, v.misc"
					+ " from reviews r"
					+ " join releases l on l.id = r.release_id"
					+ " join audiorecs a on a.id = l.audiorec_id"
 					+ " join reviewers v on v.id = r.reviewer_id"
					+ " where r.id=" + id
				);
			// There can be at most one record for this review ID
			if(rs.next()) {
				String aRef, vRef, lRef;
				aRef = "<a href=\"audiorecMain.jsp?id="
					+ strFromDb(rs.getString("audiorec_id"))
					+ "\">"
					+ strFromDb(rs.getString("audiorec_id"))
					+ "</a>";
				lRef = "<a href=\"releaseMain.jsp?id="
					+ strFromDb(rs.getString("release_id"))
					+ "\">"
					+ strFromDb(rs.getString("release_id"))
					+ "</a>";
				vRef = "<a href=\"reviewerMain.jsp?id="
					+ strFromDb(rs.getString("reviewer_id"))
					+ "\">"
					+ strFromDb(rs.getString("reviewer_id"))
					+ "</a>";
				%>
				<form method=post action="reviewFormUpdate.jsp">
					Audiorec ID <%= aRef %>
					<input type=hidden name=audiorec_id value="<%= strFromDb(rs.getString("audiorec_id")) %>">
					<br>Title:<font size="-1"><%= strFromDb(rs.getString("title")) %></font>
					<br>Composer:<font size="-1"><%= strFromDb(rs.getString("composer")) %></font>
					<br>Performer:<font size="-1"><%= strFromDb(rs.getString("performer")) %></font>
					<br>Rec Date:<font size="-1"><%= strFromDb(rs.getString("recdate")) %></font>
					<p>
					Release ID <%= lRef %>
					<input type=hidden name=release_id value="<%= strFromDb(rs.getString("release_id")) %>">
					<br>Label:<font size="-1"><%= strFromDb(rs.getString("label")) %></font>
					<br>Release:<font size="-1"><%= strFromDb(rs.getString("release")) %></font>
					<br>Rel Date:<font size="-1"><%= strFromDb(rs.getString("reldate")) %></font>
					<br>Format:<font size="-1"><%= strFromDb(rs.getString("format")) %></font>
					<p>
					Reviewer ID <%= vRef %>
					<input type=hidden name=reviewer_id value="<%= strFromDb(rs.getString("reviewer_id")) %>">
					<br>Reviewer Initials <font size="-1"><%= strFromDb(rs.getString("initials")) %></font>
					<br>Misc <font size="-1"><%= strFromDb(rs.getString("misc")) %></font>
					<input type=hidden name=reviewer_id value="<%= strFromDb(rs.getString("initials")) %>">
					<p>
					Review ID <font size="-1"><%= strFromDb(rs.getString("id")) %></font>
					<br>Review Created: <font size="-1"><%= strFromDb(rs.getString("date_created")) %></font>
					<br>Review Updated: <font size="-1"><%= strFromDb(rs.getString("date_updated")) %></font>
					<input type=hidden name=id value="<%= strFromDb(rs.getString("id")) %>">
					<br>
					Sound
					<input type=text name=ratesound size=40 value="<%= strFromDb(rs.getString("ratesound")) %>">
					<br>
					Performance
					<input type=text name=rateperf size=40 value="<%= strFromDb(rs.getString("rateperf")) %>">
					<br>
					Notes
					<textarea name=notes rows=4 cols=60><%= strFromDb(rs.getString("notes")) %></textarea>
					<p>
					<input type=submit value="Submit">
				</form>
				<%
			}
			else {
				// No record for this ID (this should never happen)
				throw new Exception("No review having ID " + id);
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
	</body>
</html>
