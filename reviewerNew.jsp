<!DOCTYPE HTML>
<html>
	<head>
		<title>New Reviewer</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
		<!-- show all the reviewers -->
		<br>
		<%@ include file="reviewerList.jsp" %>
		<br>
		<b><font size="+2">Add Reviewer:</font></b>
		<br>
		<form method=post action="reviewerFormInsert.jsp">
			<br>Initials
			<input type=text name=initials size=40>
			<br>Last Name
			<input type=text name=lastname size=40>
			<br>First Name
			<input type=text name=firstname size=40>
			<br>Misc
			<input type=text name=misc size=40>
			<br>Equipment
			<textarea name=equip rows="4" cols="60"></textarea>
			<br>Preferences
			<textarea name=prefs rows="4" cols="60"></textarea>
			<p>
			<input type=submit value="Submit">
		</form>
	</body>
</html>
