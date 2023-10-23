<!-- Show a list of all reviews for the given audio recording release -->
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<%
// The given ID is for an audiorec release
String	id = request.getParameter("id"),
		reviewNewRef = "<a href=\"reviewNew.jsp?id=" + id + "\">Add New Review</a>";
%>
<font size="+2">
Reviews
</font>
<br>
<%= reviewNewRef %>
<br>
<%
try {
	Statement st = dbConnGet().createStatement();
	ResultSet rs = st.executeQuery(
			"select r.id as rid, p.misc as misc, p.id as pid, p.initials, r.ratesound, r.rateperf, r.notes"
			+ " from reviews r"
			+ " join reviewers p on (r.reviewer_id = p.id)"
			+ " where r.release_id = " + id
			+ " order by r.id"
		);
	%>
	<font size="+0">
	<table>
		<tr>
			<td>ID</td>
			<td>Who</td>
			<td>Who Misc</td>
			<td>Performance</td>
			<td>Sound</td>
			<td>Notes</td>
		</tr>
	<%
	// Display all the records
	while(rs.next()) {
		String pRef, rRef;
		rRef = "<a href=\"reviewMain.jsp?id="
			+ strFromDb(rs.getString("rid"))
			+ "\">"
			+ strFromDb(rs.getString("rid"))
			+ "</a>";
		pRef = "<a href=\"reviewerMain.jsp?id="
			+ strFromDb(rs.getString("pid"))
			+ "\">"
			+ strFromDb(rs.getString("initials"))
			+ "</a>";
		%>
			<tr>
				<td><%= rRef %></td>
				<td><%= pRef %></td>
				<td><%= strFromDb(rs.getString("misc")) %></td>
				<td><%= strFromDb(rs.getString("rateperf")) %></td>
				<td><%= strFromDb(rs.getString("ratesound")) %></td>
				<td><%= strFromDb(rs.getString("notes")) %></td>
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