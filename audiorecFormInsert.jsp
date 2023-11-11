<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<html>
	<head>
		<title>Audio Recording</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String	id_a, id_r
					, title, composer, performer, soloist, director, genre, location, recdate, rec_notes
					, label, release, releaseid, format, channels, dynrange, reldate, rel_notes;
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
			reldate = request.getParameter("reldate");
			format = request.getParameter("format");
			channels = request.getParameter("channels");
			dynrange = request.getParameter("dynrange");
			rel_notes = request.getParameter("rel_notes");
			try {
				String aSqlUpdate = "insert into audiorecs"
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
				PreparedStatement aSt = dbConnGet().prepareStatement(aSqlUpdate, Statement.RETURN_GENERATED_KEYS);
				int rc_a = aSt.executeUpdate();
				if(rc_a > 0) {
					// success! get the generated primary key (ID)
					id_a = "";
					ResultSet aRs = aSt.getGeneratedKeys();
					if(aRs.next()) {
						id_a = aRs.getString(1);
						if(id_a.length() > 0) {
							// success! now insert the release info
							String rSqlUpdate = "insert into releases"
								+ " (audiorec_id, label, release, releaseid, reldate, format, channels, dynrange, notes)"
								+ " values ("
								+ strToDb(id_a)
								+ ", " + strToDb(label)
								+ ", " + strToDb(release)
								+ ", " + strToDb(releaseid)
								+ ", " + strToDb(reldate)
								+ ", " + strToDb(format)
								+ ", " + strToDb(channels)
								+ ", " + strToDb(dynrange)
								+ ", " + strToDb(rel_notes)
								+ ")";
							PreparedStatement rSt = dbConnGet().prepareStatement(rSqlUpdate, Statement.RETURN_GENERATED_KEYS);
							int rc_r = rSt.executeUpdate();
							if(rc_r > 0) {
								// success! get the generated primary key (ID)
								id_r = "";
								ResultSet rRs = rSt.getGeneratedKeys();
								if(rRs.next()) {
									id_r = rRs.getString(1);
									if(id_r.length() > 0) {
										// success! commit the transaction
										response.sendRedirect("releaseMain.jsp?id=" + id_r);
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
