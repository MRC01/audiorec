<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
<%
	// Get the average and median ratings
	String	s_avg, s_med, p_avg, p_med;
	s_avg = s_med = p_avg = p_med = null;
	try {
		Statement	st;
		ResultSet	rs;
		st = dbConnGet().createStatement();
		rs = st.executeQuery("select avg(ratesound) as s_avg"
			+ ", percentile_cont(0.5) within group(order by ratesound) as s_med"
			+ ", avg(rateperf) as p_avg"
			+ ", percentile_cont(0.5) within group(order by rateperf) as p_med"
			+ " from reviews");
		if(rs.next()) {
			s_avg = String.format("%3.2f", rs.getDouble("s_avg"));
			s_med = String.format("%1d", rs.getInt("s_med"));
			p_avg = String.format("%3.2f", rs.getDouble("p_avg"));
			p_med = String.format("%1d", rs.getInt("p_med"));
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
	<head>
		<title>Review Rating Analysis</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
		<p>
			The following charts show the frequency and counts of each rating.
			This makes ratings more meaningful by showing the weights and averages.
			High averages are expected due to intentional sample bias:
			I only listen to and review performances and recordings that I expect to be great.
		<p>
		<h1>Sound Quality <font size="+0">Average <%= s_avg %>, Median <%= s_med%></font></h1>
		<table>
		<tr>
		<td>Rating</td>
		<td>Count</td>
		<td>Percent</td>
		<td>Graph</td>
		</tr>
		<%
		try {
			Statement st = dbConnGet().createStatement();
			String sql = getReviewHistogramQuery("tot_reviews", "ratesound");
			ResultSet rs = st.executeQuery(sql);
			// Each returned row is a rating and its frequency as a percentage
			while(rs.next()) {
				RowData rd = processHistogramRow(rs);
				%>
				<tr>
					<td><font size="-1"><%= rd.rat %></font></td>
					<td align="right"><font size="-1"><%= rd.cnt %></font></td>
					<td align="right"><font size="-1"><%= rd.pct %></font></td>
					<td align="left"><%= rd.bar %></td>
				</tr>
				<%
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
		</table>
		<h1>Performance Quality <font size="+0">Average <%= p_avg %>, Median <%= p_med%></font></h1>
		<table>
		<tr>
		<td>Rating</td>
		<td>Count</td>
		<td>Percent</td>
		</tr>
		<%
		try {
			Statement st = dbConnGet().createStatement();
			String sql = getReviewHistogramQuery("tot_reviews", "rateperf");
			ResultSet rs = st.executeQuery(sql);
			// Each returned row is a rating and its frequency as a percentage
			while(rs.next()) {
				RowData rd = processHistogramRow(rs);
				%>
				<tr>
					<td><font size="-1"><%= rd.rat %></font></td>
					<td align="right"><font size="-1"><%= rd.cnt %></font></td>
					<td align="right"><font size="-1"><%= rd.pct %></font></td>
					<td align="left"><%= rd.bar %></td>
				</tr>
				<%
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
		</table>
		<h1>Performance (Y) vs. Sound (X) Correlation</h1>
		<style>
		table.t1 th, table.t1 td {
			border-collapse: collapse;
			border: 1px solid black;
			border-style: dotted;
			table-layout: fixed;
			width: 30px;
		}
		</style>
		<table class="t1">
		<%
		try {
			Statement st = dbConnGet().createStatement();
			// The order of the SQL must match the for-loops used to process the data.
			String sql = "select s, p, count(*) as cnt "
				+ "from (select ratesound as s, rateperf as p from reviews ) "
				+ "group by p, s order by p desc, s";
			ResultSet rs = st.executeQuery(sql);
			/* Each returned row is a sound & performance rating given to a recording
				p (performance) is the Y axis
				s (sound) is the X axis
			*/
			int	s, p, c;
			if(rs.next()) {
				s = rs.getInt("s");
				p = rs.getInt("p");
				c = rs.getInt("cnt");
			}
			else {
				s = -1;
				p = -1;
				c = -1;
			}
			for(int y = 10; y >= 0; y--) {
				%> <tr> <%
				if(y == 0) {
					// Print the X axis values (bottom row of table)
					%><td></td><%
					for(int z = 1; z <= 10; z++) {
						%><td class="t1"><font size="-1"><%= z %></font><%
					}
				}
				else {
					for(int x=0; x <= 10; x++) {
						%> <td> <%
						if(x == 0) {
							// Print the Y axis values (left column of table)
							%><font size="-1"><%= y %></font><%
						}
						else if(s == x && p == y) {
							// This rating matches the position; show the count
							%> <%= c %> <%
							// Fetch the next row
							if(rs.next()) {
								s = rs.getInt("s");
								p = rs.getInt("p");
								c = rs.getInt("cnt");
							}
							else {
								s = -1;
								p = -1;
								c = -1;
							}
						}
						else {
							// No ratings for this position / cell; it's zero
						}
						%> </td> <%
					}
				}
				%> </tr> <%
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
		</table>
	</body>
</html>
