<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Audio Review</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String	id, audiorec_id, reviewer_id, ratesound, rateperf, notes;
			audiorec_id = request.getParameter("audiorec_id");
			reviewer_id = request.getParameter("reviewer_id");
			ratesound  = request.getParameter("ratesound");
			rateperf = request.getParameter("rateperf");
			notes = request.getParameter("notes");
			try {
				String sqlUpdate = "insert into reviews"
					+ " (audiorec_id, reviewer_id, ratesound, rateperf, notes)"
					+ " values ("
					+ longToDb(audiorec_id)
					+ ", " + longToDb(reviewer_id)
					+ ", " + strToDb(ratesound)
					+ ", " + strToDb(rateperf)
					+ ", " + strToDb(notes)
					+ ")";
				PreparedStatement st = dbConnGet().prepareStatement(sqlUpdate, Statement.RETURN_GENERATED_KEYS);
				int rc = st.executeUpdate();
				if(rc > 0) {
					// success! get the generated primary key (ID)
					id = "";
					ResultSet rs = st.getGeneratedKeys();
					if(rs.next()) {
						id = rs.getString(1);
						if(id.length() > 0) {
							// success! redirect to the Audiorec Main page
							response.sendRedirect("audiorecMain.jsp?id=" + audiorec_id);
						}
						else {
							// Insert succeeded new ID had no value
							throw new Exception("Insert succeeded, but new ID had no value");
						}
					}
					else {
						// Insert succeeded but could not get generated ID
						throw new Exception("Insert succeeded but could not get new ID");
					}
				}
				else {
					// Update failed - this should never happen
					throw new Exception("Insert recording failed");
				}
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
