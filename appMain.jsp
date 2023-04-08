<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<html>
	<%
	String	rec_cnt = ""
			, rev_cnt = "";
	try {
		Statement	st;
		ResultSet	rs;
		// Get the count of recordings
		st = dbConnGet().createStatement();
		rs = st.executeQuery("select count(*) as cnt from audiorecs");
		if(rs.next())
			rec_cnt = String.format("%d", rs.getInt("cnt"));
		rs.close();
		// Get the count of reviews
		st = dbConnGet().createStatement();
		rs = st.executeQuery("select count(*) as cnt from reviews");
		if(rs.next())
			rev_cnt = String.format("%d", rs.getInt("cnt"));
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
	<head>
		<title>Audio Recordings and Reviews</title>
	</head>
	<body>
		<%
		// look for where clause param; if not there, set to empty string
		String whereStr = "1=1";
		String whereField = request.getParameter("where");
		if(whereField == null) whereField = "";
		%>
		<h1>Audio Recordings (<%= rec_cnt %>) and <a href="reviewRatingChart.jsp">Reviews</a> (<%= rev_cnt %>)</h1>
		<div style="display:flex;">
			<!-- Search button sets where param and re-displays this page -->
			<form method="get" action="appMain.jsp">
				Search:
				<input type=text name=where value="<%= whereField %>" size=20>
				<input type=submit value="Search">
			</form>
			<!-- All button resets search and shows all recordings -->
			<form method="get" action="appMain.jsp">
				<input type=hidden name=where value="">
				<input type=submit value="All">
			</form>
		</div>
		<p>
		<font size="+1">Add New:</font>
		<a href="audiorecNew.jsp">Recording</a>
		<a href="reviewerNew.jsp">Reviewer</a>
		<p>
		<font size="+1">Browse/Edit Below</font>
		<br>
		<%
		// Determine the sort order from query param "sort"
		String sortStr = "composer, title, performer, recdate, label";
		String sortField = request.getParameter("sort");
		if("title".equals(sortField))
			sortStr = "title, composer, performer, recdate, label";
		if("performer".equals(sortField))
			sortStr = "performer, composer, title, recdate, label";
		if("rateperf".equals(sortField))
			sortStr = "rateperf, " + sortStr;
		if("ratesound".equals(sortField))
			sortStr = "ratesound, " + sortStr;
		if("recdate".equals(sortField))
			sortStr = "recdate, " + sortStr;
		// Determine records to include from query param "where"
		if(whereField.length() > 0) {
			StringBuilder ws = new StringBuilder();
			String whereFieldUC = whereField.toUpperCase();
			ws.append("upper(title) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(composer) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(performer) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(director) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(soloist) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(label) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(release) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(releaseid) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(location) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(format) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(dynrange) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(ar.notes) like '%" + whereFieldUC + "%'");
			ws.append(" or upper(rv.notes) like '%" + whereFieldUC + "%'");
			whereStr = ws.toString();
		}
		// Fetch and display the data
		try {
			Statement st = dbConnGet().createStatement();
			ResultSet rs = st.executeQuery(
					"select ar.id as audiorec_id "
					+ ", title, composer, performer, recdate"
					+ ", avg(rateperf) as rateperf, avg(ratesound) as ratesound"
					+ " from audiorecs ar"
					+ " left outer join reviews rv on (ar.id = rv.audiorec_id)"
					+ " where " + whereStr
					+ " group by ar.id"
					+ " order by " + sortStr
				);
			%>
			<font size="+0">
			<table>
				<tr>
					<%
						// If a search string is set, keep using it when sorting
						String baseUrl = "appMain.jsp?where=" + whereField + "&sort=";
					%>
					<td>Rec ID</td>
					<td><a href="<%= baseUrl + "composer" %>">Composer</a></td>
					<td><a href="<%= baseUrl + "title" %>">Title</a></td>
					<td><a href="<%= baseUrl + "performer" %>">Performer</a></td>
					<td><a href="<%= baseUrl + "recdate" %>">Rec Date</a></td>
					<td><a href="<%= baseUrl + "rateperf" %>">Performance</a></td>
					<td><a href="<%= baseUrl + "ratesound" %>">Sound</a></td>
				</tr>
			<%
			// Display all the records
			while(rs.next()) {
				String recRef, revRef;
				recRef = "<a href=\"audiorecMain.jsp?id="
					+ rs.getString("audiorec_id")
					+ "\">"
					+ rs.getString("audiorec_id")
					+ "</a>";
				String	rPerf = String.format("%.1f", rs.getFloat("rateperf")),
						rSound = String.format("%.1f", rs.getFloat("ratesound"));
				%>
					<tr>
						<td><%= recRef %></td>
						<td><%= rs.getString("composer") %></td>
						<td><%= rs.getString("title") %></td>
						<td><%= rs.getString("performer") %></td>
						<td><%= rs.getDate("recdate") %></td>
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
	</body>
</html>
