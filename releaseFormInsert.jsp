<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Audio Recording Release</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String	id, audiorec_id, label, release, releaseid, reldate, format, channels, dynrange, notes;
			audiorec_id = request.getParameter("audiorec_id");
			label = request.getParameter("label");
			release = request.getParameter("release");
			releaseid = request.getParameter("releaseid");
			reldate = request.getParameter("reldate");
			format  = request.getParameter("format");
			channels = request.getParameter("channels");
			dynrange = request.getParameter("dynrange");
			notes = request.getParameter("notes");
			try {
				String sqlInsert = "insert into releases"
					+ " (audiorec_id, label, release, releaseid, reldate, format, channels, dynrange, notes)"
					+ " values ("
					+ strToDb(audiorec_id)
					+ ", " + strToDb(label)
					+ ", " + strToDb(release)
					+ ", " + strToDb(releaseid)
					+ ", " + strToDb(reldate)
					+ ", " + strToDb(format)
					+ ", " + strToDb(channels)
					+ ", " + strToDb(dynrange)
					+ ", " + strToDb(notes)
					+ ")";
				PreparedStatement st = dbConnGet().prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
				int rc = st.executeUpdate();
				if(rc > 0) {
					// success! get the generated primary key (ID)
					id = "";
					ResultSet rs = st.getGeneratedKeys();
					if(rs.next()) {
						id = rs.getString(1);
						if(id.length() > 0) {
							// success! commit the transaction
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
					throw new Exception("Insert release failed");
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
