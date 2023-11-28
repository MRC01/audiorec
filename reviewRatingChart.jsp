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
		<p>The following charts show the frequency and counts of each rating.
			This makes ratings more meaningful by showing the weights and averages.
			High averages are expected due to intentional sample bias -
			I only listen to and review performances and recordings that I expect to be great.
		<p>
		<h1>Sound Quality</h1>
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
		<h1>Performance Quality</h1>
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
	</body>
</html>
