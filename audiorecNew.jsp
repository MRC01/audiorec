<!DOCTYPE HTML>
<html>
	<head>
		<title>New Audio Recording</title>
	</head>
	<body>
		<h1><a href="appMain.jsp">Back to Audio Recordings</a></h1>
		<form method=post action="audiorecFormInsert.jsp">
			<br>Title
			<input type=text name=title size=40>
			<br>Composer
			<input type=text name=composer size=40>
			<br>Performer
			<input type=text name=performer size=40>
			<br>Soloist
			<input type=text name=soloist size=40>
			<br>Director
			<input type=text name=director size=40>
			<br>Genre
			<input type=text name=genre size=40>
			<br>Label
			<input type=text name=label size=40>
			<br>Release
			<input type=text name=release size=40>
			<br>Release ID
			<input type=text name=releaseid size=40>
			<br>Date
			<input type=text name=recdate size=40>
			<br>Location
			<input type=text name=location size=40>
			<br>Format
			<input type=text name=format size=40>
			<br>Channels
			<input type=text name=channels size=40>
			<br>Dynamic Range
			<input text=text name=dynrange size=40>
			<br>Notes
			<input text=text name=notes size=40>
			<p>
			<input type=submit value="Submit">
		</form>
	</body>
</html>
