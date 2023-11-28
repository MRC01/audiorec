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
			High averages are expected due to sample bias -
			I only listen to and review good performances and recordings.
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
		final double bar_scale = 3.0;
		try {
			Statement st = dbConnGet().createStatement();
			String sql = getReviewHistogramQuery("tot_reviews", "ratesound");
			ResultSet rs = st.executeQuery(sql);
			// Each returned row is a rating and its frequency as a percentage
			while(rs.next()) {
				String			r, c, f;
				Double			pct;
				StringBuffer	bar_str;
				int				bar_len;
				r = String.format("%d", rs.getInt("rating"));
				c = String.format("%,4d", rs.getInt("cnt"));
				pct = rs.getDouble("pct") * 100.0;
				f = String.format("%3.1f", pct);
				bar_str = new StringBuffer();
				bar_len = (int)(pct / bar_scale + 0.5);
				for(int i = 0; i < bar_len; i++)
					bar_str.append("=");
				%>
				<tr>
					<td><font size="-1"><%= r %></font></td>
					<td align="right"><font size="-1"><%= c %></font></td>
					<td align="right"><font size="-1"><%= f %></font></td>
					<td align="left"><%= bar_str %></td>
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
				String			r, c, f;
				Double			pct;
				StringBuffer	bar_str;
				int				bar_len;
				r = String.format("%d", rs.getInt("rating"));
				c = String.format("%,4d", rs.getInt("cnt"));
				pct = rs.getDouble("pct") * 100.0;
				f = String.format("%3.1f", pct);
				bar_str = new StringBuffer();
				bar_len = (int)(pct / bar_scale + 0.5);
				for(int i = 0; i < bar_len; i++)
					bar_str.append("=");
				%>
				<tr>
					<td><font size="-1"><%= r %></font></td>
					<td align="right"><font size="-1"><%= c %></font></td>
					<td align="right"><font size="-1"><%= f %></font></td>
					<td align="left"><%= bar_str %></td>
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
