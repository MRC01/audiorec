<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Review Rating Analysis</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
		<p>
		<p>The following tables show the frequency and counts of each rating.
			This makes ratings more meaningful by showing the bias, weights, and averages.
		<p>
		<h1>Sound Quality</h1>
		<table>
		<tr>
		<td>Rating</td>
		<td>Freq-Pct</td>
		<td>Count</td>
		</tr>
		<%
		try {
			Statement st = dbConnGet().createStatement();
			String sql = getReviewHistogramQuery("tot_reviews", "ratesound");
			ResultSet rs = st.executeQuery(sql);
			// Each returned row is a rating and its frequency as a percentage
			while(rs.next()) {
				String	r, c, f;
				r = String.format("%d", rs.getInt("rating"));
				c = String.format("%,4d", rs.getInt("cnt"));
				f = String.format("%3.1f", rs.getDouble("pct") * 100.0);
				%>
				<tr>
					<td><font size="-1"><%= r %></font></td>
					<td align="right"><font size="-1"><%= f %></font></td>
					<td align="right"><font size="-1"><%= c %></font></td>
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
		<h1>Performance Quality</h1>
		<table>
		<tr>
		<td>Rating</td>
		<td>Freq-Pct</td>
		<td>Count</td>
		</tr>
		<%
		try {
			Statement st = dbConnGet().createStatement();
			String sql = getReviewHistogramQuery("tot_reviews", "rateperf");
			ResultSet rs = st.executeQuery(sql);
			// Each returned row is a rating and its frequency as a percentage
			while(rs.next()) {
				String	r, c, f;
				r = String.format("%d", rs.getInt("rating"));
				c = String.format("%,4d", rs.getInt("cnt"));
				f = String.format("%3.1f", rs.getDouble("pct") * 100.0);
				%>
				<tr>
					<td><font size="-1"><%= r %></font></td>
					<td align="right"><font size="-1"><%= f %></font></td>
					<td align="right"><font size="-1"><%= c %></font></td>
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
	</body>
</html>
