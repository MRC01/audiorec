<!-- Show a list of all reviews for the given reviewer -->
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<%
// The given ID is for a reviewer
String	id = request.getParameter("id");
%>
<font size="+2">
Reviews
</font>
<%
try {
	Statement st = dbConnGet().createStatement();
	ResultSet rs = st.executeQuery(
			"select r.id as rid, r.date_created, r.date_updated, r.ratesound, r.rateperf, r.notes"
			+ " from reviews r"
			+ " join reviewers p on (r.reviewer_id = p.id)"
			+ " where p.id = " + id
			+ " order by r.date_updated desc"
		);
	%>
	<font size="+0">
	<table>
		<tr>
			<td>ID</td>
			<td>Date Created</td>
			<td>Date Updated</td>
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
		%>
		<tr>
			<td><%= rRef %></td>
			<td><%= strFromDb(rs.getString("date_created")) %></td>
			<td><%= strFromDb(rs.getString("date_updated")) %></td>
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