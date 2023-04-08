<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<!-- list all the audio reviewers -->
<b><font size="+2">Reviewers</font></b>
<br>
<%
try {
	Statement st = dbConnGet().createStatement();
	ResultSet rs = st.executeQuery(
			"select id, initials, lastname, misc, equipment, preferences"
			+ " from reviewers"
			+ " order by initials"
		);
	%>
	<font size="+0">
	<table>
		<tr>
			<td>Reviewer ID</td>
			<td>Initials</td>
			<td>Last Name</td>
			<td>Misc</td>
			<td>Equipment</td>
			<td>Preferences</td>
		</tr>
	<%
	while(rs.next()) {
		// The ID is a link that user can optionally click to edit the reviewer
		String pRef = "<a href=\"reviewerMain.jsp?id="
		+ strFromDb(rs.getString("id"))
		+ "\">"
		+ strFromDb(rs.getString("id"))
		+ "</a>";
		%>
			<tr>
				<td><%= pRef %></td>
				<td><%= strFromDb(rs.getString("initials")) %></td>
				<td><%= strFromDb(rs.getString("lastname")) %></td>
				<td><%= strFromDb(rs.getString("misc")) %></td>
				<td><%= strFromDb(rs.getString("equipment")) %></td>
				<td><%= strFromDb(rs.getString("preferences")) %></td>
			</tr>
		<%
	}
	rs.close();
	%>
	</table>
	</font>
	<%
}
catch(Exception ex) {
	%>
	<%@ include file="error.jsp" %>
	<%
	// reset the DB connection to force a reconnect next time
	dbConnReset();
}
%>
