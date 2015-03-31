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
SELECT DISTINCT(town) AS town FROM crime ORDER BY town ASC;
</sql:query>
<sql:query var="rs2" dataSource="jdbc/TestDB">
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'test' AND TABLE_NAME = 'crime'
AND COLUMN_NAME != 'id' AND COLUMN_NAME != 'year1' AND COLUMN_NAME != 'town'  AND COLUMN_NAME != 'population';
</sql:query>

<form name="townselectionform" action="page2.jsp" method="post" >

<table>
  <tr>
    <td colspan="2">
      <select name="compareby" style="width:300px">
        <option value="crime">crime</option>
		<option value="education">education</option>
		<option value="income">income</option>
		<option value="race">race</option>
      </select> 
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <select name="comparebytypes" multiple="multiple" size="11" style="width:300px">
        <option value="">Show type...</option>
		<c:forEach var="row" items="${rs2.rows}">
		    <option value="<c:out value="${row.COLUMN_NAME}"/>"><c:out value="${row.COLUMN_NAME}"/></option>
        </c:forEach>
      </select> 
    </td>
  </tr>
   <tr>
    <td colspan="2">
      <select name="towns" multiple="multiple" size="20" style="width:300px">
        <option value="">Select towns...</option>
		<c:forEach var="row" items="${rs.rows}">
		    <option value="<c:out value="${row.town}"/>"><c:out value="${row.town}"/></option>
        </c:forEach>
      </select> 
    </td>
  </tr>   

  <tr>
	<td colspan="2">
	  <input type="submit" value="compare" />
	</td>
  </tr>

</table>
</form>

<script type="text/javascript">
$(window).load(function() {
	d3.select("body").style("background-color", "yellow");
	d3.selectAll("p")
    .data([23, 42])
    .style("font-size", function(d) { return d + "px"; });
});
</script>
</body>
</html>
