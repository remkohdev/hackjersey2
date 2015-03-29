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
<sql:query var="rs" dataSource="jdbc/TestDB">
select id, town, year from crime
</sql:query>
<c:forEach var="row" items="${rs.rows}">
    Town: ${row.town}, Year: ${row.year}<br/>
</c:forEach>

<form name="townselectionform" action="page2.jsp" method="post" >
<input name="town1" type="hidden" value="Trenton, New Jersey"/>
<input type="submit" value="compare" />
</form>



<script type="text/javascript">
$(window).load(function() {
	d3.select("body").style("background-color", "green");
	d3.selectAll("p")
    .data([23, 42])
    .style("font-size", function(d) { return d + "px"; });
});
</script>
</body>
</html>
