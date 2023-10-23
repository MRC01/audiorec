<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<font size="+2">
Audiorec Release
</font>
<%
// The given ID is for an audiorec release
String id = request.getParameter("id");
try {
	Statement st = dbConnGet().createStatement();
	ResultSet rs = st.executeQuery(
			"select id, audiorec_id"
			+ ", label, release, releaseid, reldate, format"
			+ ", channels, dynrange, notes, date_created, date_updated"
			+ " from releases"
			+ " where id=" + id
		);
	// There can be at most one record for this ID
	if(rs.next()) {
		%>
		<form method=post action="releaseFormUpdate.jsp">
			ID <font size="-1"><%= strFromDb(rs.getString("id")) %></font>
			<br>Date Created: <font size="-1"><%= strFromDb(rs.getString("date_created")) %></font>
			<br>Date Updated: <font size="-1"><%= strFromDb(rs.getString("date_updated")) %></font>
			<input type=hidden name=id value="<%= strFromDb(rs.getString("id")) %>">
			<br>Label
			<input type=text name=label size=40 value="<%= strFromDb(rs.getString("label")) %>">
			<br>Release
			<input type=text name=release size=40 value="<%= strFromDb(rs.getString("release")) %>">
			<br>Release ID
			<input type=text name=releaseid size=40 value="<%= strFromDb(rs.getString("releaseid")) %>">
			<br>Date
			<input type=text name=reldate size=40 value="<%= strFromDb(rs.getString("reldate")) %>">
			<br>Format
			<input type=text name=format size=40 value="<%= strFromDb(rs.getString("format")) %>">
			<br>Channels
			<input type=text name=channels size=40 value="<%= strFromDb(rs.getString("channels")) %>">
			<br>Dynamic Range
			<input type=text name=dynrange size=40 value="<%= strFromDb(rs.getString("dynrange")) %>">
			<br>Notes
			<input type=text name=notes size=40 value="<%= strFromDb(rs.getString("notes")) %>">
			<p>
			<input type=submit value="Submit">
		</form>
	<%
	}
	else {
		// No record for this ID (this should never happen)
		throw new Exception("No release having ID " + id);
	}
	// Show all reviews for this release
	%>
	<jsp:include page="releaseReviews.jsp">
		<jsp:param name="id" value="<%= strFromDb(rs.getString(\"id\")) %>"/>
	</jsp:include>
	<%
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
