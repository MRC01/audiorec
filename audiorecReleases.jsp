<!-- Show a list of all releases for the given audio recording -->
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<%
// The given ID is for the audiorec
String	id = request.getParameter("id"),
	releaseNewRef = "<a href=\"releaseNew.jsp?id=" + id + "\">Add New Release</a>";
%>
<font size="+2">
Releases
</font>
<br>
<%= releaseNewRef %>
<br>
<%
try {
	Statement st = dbConnGet().createStatement();
	ResultSet rs = st.executeQuery(
			"select l.id as lid, l.label, l.release, l.reldate, l.format"
			+ ", count(r.ratesound) as ratecount, avg(r.rateperf) as rateperf, avg(r.ratesound) as ratesound"
			+ " from releases l"
			+ " left outer join reviews r on (r.release_id = l.id)"
			+ " left outer join reviewers p on (p.id = r.reviewer_id)"
			+ " where l.audiorec_id = " + id
			+ " group by 1, 2, 3, 4, 5"
			+ " order by l.id"
		);
	%>
	<font size="+0">
	<table>
		<tr>
			<td>ID</td>
			<td>Label</td>
			<td>Release</td>
			<td>Release Date</td>
			<td>Format</td>
			<td>Reviews</td>
			<td>Performance</td>
			<td>Sound</td>
		</tr>
	<%
	// Display all the records
	while(rs.next()) {
		String lRef;
		lRef = "<a href=\"releaseMain.jsp?id="
			+ strFromDb(rs.getString("lid"))
			+ "\">"
			+ strFromDb(rs.getString("lid"))
			+ "</a>";
		String	rCount = String.format("%d", rs.getInt("ratecount")),
				rPerf = String.format("%.1f", rs.getFloat("rateperf")),
				rSound = String.format("%.1f", rs.getFloat("ratesound"));
		%>
			<tr>
				<td><%= lRef %></td>
				<td><%= strFromDb(rs.getString("label")) %></td>
				<td><%= strFromDb(rs.getString("release")) %></td>
				<td><%= rs.getDate("reldate") %></td>
				<td><%= strFromDb(rs.getString("format")) %></td>
				<td><%= rCount %></td>
				<td><%= rPerf %></td>
				<td><%= rSound %></td>
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
