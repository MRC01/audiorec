<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
<head>
	<title>Audio Reviewer</title>
</head>
<body>
<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
<b><font size="+2"><a href="reviewerNew.jsp">Back to Audio Reviewers</a></font></b>
<p>
<%
String id = request.getParameter("id");
try {
	Statement st = dbConnGet().createStatement();
	ResultSet rs = st.executeQuery(
			"select p.id, p.date_created, p.date_updated"
			+ ", p.initials, p.lastname, p.firstname, p.equipment, p.misc, p.preferences"
			+ ", count(distinct r.id) as review_count"
			+ " from reviewers p"
			+ " left outer join reviews r on (r.reviewer_id = p.id)"
			+ " where p.id=" + id
			+ " group by p.id"

		);
	// There can be at most one record for this ID
	if(rs.next()) {
		%>
		<form method=post action="reviewerFormUpdate.jsp">
			ID <font size="-1"><%= strFromDb(rs.getString("id")) %></font>
			<br>Date Created: <font size="-1"><%= strFromDb(rs.getString("date_created")) %></font>
			<br>Date Updated: <font size="-1"><%= strFromDb(rs.getString("date_updated")) %></font>
			<input type=hidden name=id value="<%= strFromDb(rs.getString("id")) %>">
			<br>
			Initials
			<input type=text name=initials size=40 value="<%= strFromDb(rs.getString("initials")) %>">
			<br>
			Misc
			<input type=text name=misc size=40 value="<%= strFromDb(rs.getString("misc")) %>">
			<br>
			Last Name
			<input type=text name=lastname size=40 value="<%= strFromDb(rs.getString("lastname")) %>">
			<br>
			First Name
			<input type=text name=firstname size=40 value="<%= strFromDb(rs.getString("firstname")) %>">
			<br>
			Equipment
			<textarea name=equip rows=4 cols=60><%= strFromDb(rs.getString("equipment")) %></textarea>
			<br>
			Preferences
			<textarea name=prefs rows=4 cols=60><%= strFromDb(rs.getString("preferences")) %></textarea>
			<p>
			<input type=submit value="Submit">
		</form>
		<%
	}
	else {
		// No record for this ID (this should never happen)
		throw new Exception("No recording having ID " + id);
	}
	// Show all reviews for this reviewer
	%>
	<jsp:include page="reviewerReviews.jsp">
		<jsp:param name="id" value="<%= strFromDb(rs.getString(\"id\")) %>"/>
		<jsp:param name="count" value="<%= strFromDb(rs.getString(\"review_count\")) %>"/>
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
