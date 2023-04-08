<!-- include this file inside exceptions handlers -->
<!-- NOTE: variable 'ex' must be the exception! -->
<font size="+3" color="red">Error</font>
<br><font size="+2" color="red">Exception message:</font>
		<font size="+1" color="black"><%= ex.getMessage() %></font>
<br><font size="+2" color="red">Exception cause:</font>
		<font size="+1" color="black"><%= ex.getCause() %></font>
<br><font size="+2" color="red">Exception string:</font>
		<font size="+1" color="black"><%= ex.toString() %></font>
