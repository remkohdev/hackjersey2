<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
<title>HackJersey2 - Town vs Town Insights</title>

<script src="js/d3/d3.min.js"></script>
<script src="js/jquery/jquery-1.11.2.min.js"></script>

</head>
<body>
<h1>HackJersey 2.0</1>
<h2>Town vs Town Insights</h2>

<%
String town1=request.getParameter("town1");
%>
Selected town: <%= town1 %>


<script type="text/javascript">
$(window).load(function() {
	d3.select("body").style("background-color", "yellow");
});
</script>
</body>
</html>
