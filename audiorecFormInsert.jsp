<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<!-- TODO MRC: the following method should not be needed
	because it's defined in dbStuff.jsp.
	I have not figured out why it must be redundantly defined here,
	even though the other methods in dbStuff.jsp work fine.
-->
<%!
	// prepare strings to be embedded into SQL commands
	static String strToDb(String s) {
		if((s != null) && (s.length() > 0))
			return "'" + s.replace("'", "''") + "'";
		return "NULL";
	}
	// prepare strings to be embedded into SQL commands
	static String strFromDb(String s) {
		if(s == null)
			return "";
		return s;
	}
%>
<html>
	<head>
		<title>Audio Recording</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String	id, title, composer, performer, soloist, director, genre, location, recdate, rec_notes
					,label, release, releaseid, format, channels, dynrange, rel_notes;
			title = request.getParameter("title");
			composer = request.getParameter("composer");
			performer = request.getParameter("performer");
			soloist = request.getParameter("soloist");
			director = request.getParameter("director");
			genre = request.getParameter("genre");
			location = request.getParameter("location");
			recdate = request.getParameter("recdate");
			rec_notes = request.getParameter("rec_notes");
			label = request.getParameter("label");
			release = request.getParameter("release");
			releaseid = request.getParameter("releaseid");
			format = request.getParameter("format");
			channels = request.getParameter("channels");
			dynrange = request.getParameter("dynrange");
			rel_notes = request.getParameter("rel_notes");
			try {
				String sqlUpdate = "insert into audiorecs"
					+ " (title, composer, performer, soloist, director, genre, location, recdate, notes)"
					+ " values ("
					+ strToDb(title)
					+ ", " + strToDb(composer)
					+ ", " + strToDb(performer)
					+ ", " + strToDb(soloist)
					+ ", " + strToDb(director)
					+ ", " + strToDb(genre)
					+ ", " + strToDb(location)
					+ ", " + strToDb(recdate)
					+ ", " + strToDb(rec_notes)
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
							// success! now insert the release info
							String sqlUpdate = "insert into releases"
								+ " (audiorec_id, label, release, releaseid, format, channels, dynrange, notes)"
								+ " values ("
								+ strToDb(id)
								+ ", " + strToDb(label)
								+ ", " + strToDb(release)
								+ ", " + strToDb(releaseid)
								+ ", " + strToDb(reldate)
								+ ", " + strToDb(format)
								+ ", " + strToDb(channels)
								+ ", " + strToDb(dynrange)
								+ ", " + strToDb(rel_notes)
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
										// success! commit the transaction
										response.sendRedirect("audiorecMain.jsp?id=" + id);
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
