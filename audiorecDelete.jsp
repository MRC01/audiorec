<!DOCTYPE HTML>
<%@ include file="dbStuff.jsp" %>
<%@ include file="extraKrud.jsp" %>
<!--
	NOTE: MRC: 211229
	This page is called from other pages that want to delete an Audiorec.
	For example, audiorecMain.jsp
	Delete functionality is in a separate page, so that other pages can do it conditionally.
-->
<html>
	<head>
		<title>Delete Audio Recording</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
			<%
			String id = request.getParameter("id");
			if(audiorecDelete(id)) {
				%>
				<p>
					Deleted!
					<br>
					If this was a mistake, go back and re-submit it.
				</p>
				<%
			}
			else {
				%>
				<p>
					Deleted Failed - nothing deleted.
				</p>
				<%
			}
			%>
	</body>
</html>
