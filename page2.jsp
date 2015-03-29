<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
<title>HackJersey2 - Town vs Town Insights</title>
</head>

<script src="js/d3/d3.min.js"></script>
<script src="js/jquery/jquery-1.11.2.min.js"></script>
<style>
body {
  font: 10px sans-serif;
}
.axis path,
.axis line {
  fill: none;
  stroke: #000;
  shape-rendering: crispEdges;
}
.x.axis path {
  display: none;
}
.line {
  fill: none;
  stroke: steelblue;
  stroke-width: 1.5px;
}
</style>

<body>
<h1>HackJersey 2.0</1>
<h2>Town by Town Insights</h2>
<%
String compareby=request.getParameter("compareby");
%>
<c:set var="towns" value="${paramValues['towns']}" />
<c:set var="comparebytypes" value="${paramValues['comparebytypes']}" />
<c:set var="columnsLength" value="${fn:length(comparebytypes)}"/>
<c:forEach var="comparebytype" items="${comparebytypes}" varStatus="loop">
	<c:choose>
		<c:when test="${loop.index == 0}">
			<c:set var="columns" value="${comparebytype}"/>
		</c:when>
		<c:otherwise>
			<c:set var="columns" value="${columns}, ${comparebytype}"/>
		</c:otherwise>
	</c:choose>
</c:forEach>
types: <c:out value="${columns}"/></br>
<div id="viz"></div>

<script type="text/javascript">
$(window).load(function() {
	
	d3.select("body").style("background-color", "yellow");
	var viz = d3.select("div#viz");
	
	<c:forEach var="town" items="${towns}">
	    <c:set var="population" value=""/>
		<sql:query var="rstown" dataSource="jdbc/TestDB">
			select id, population, town, year1, violentcrime, murder, rape, robbery, assault,
			propertycrime, burglary, larcenytheft, motorvehicletheft, arson from crime
			where town = "<c:out value="${town}"/> "  
		</sql:query>
		var div1 = viz.append("div");
		var data1 = [
		    <c:forEach var="row1" items="${rstown.rows}">
		    	<c:set var="population" value="${row1.population}"/>
		        {date:${row1.year1}, violentcrime:${row1.violentcrime}, murder:${row1.murder}, rape:${row1.rape}, 
					robbery:${row1.robbery}, assault:${row1.assault}, propertycrime:${row1.propertycrime},
					burglary:${row1.burglary}, larcenytheft:${row1.larcenytheft}, motorvehicletheft:${row1.motorvehicletheft},
					arson:${row1.arson} },
			</c:forEach>        			
		];
		addCrimeGraph(data1, div1, "<c:out value="${town}" /> (pop.<c:out value="${population}" />)");
		
	</c:forEach>
	
});

function addCrimeGraph(data1, div1, title){
	
	var margin = {top: 50, right: 80, bottom: 30, left: 50},
    width = 660 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;
	
	var parseDate = d3.time.format("%Y").parse;
	
	var x = d3.time.scale()
	    .range([0, width]);

	var y = d3.scale.linear()
	    .range([height, 0]);
	
	var color = d3.scale.category10();
	
	var xAxis = d3.svg.axis()
	    .scale(x)
	    .orient("bottom");
	
	var yAxis = d3.svg.axis()
	    .scale(y)
	    .orient("left");
	
	var line = d3.svg.line()
	    .interpolate("basis")
	    .x(function(d) { return x(d.date); })
	    .y(function(d) { return y(d.temperature); });

	var svg = div1.append("svg")
	    .attr("width", width + margin.left + margin.right)
	    .attr("height", height + margin.top + margin.bottom)
	  .append("g")
	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	svg.append("text")
    .attr("x", (width / 2))             
    .attr("y", 0 - (margin.top / 2))
    .attr("text-anchor", "middle")  
    .style("font-size", "16px") 
    .style("text-decoration", "underline")  
    .text(title);
	
    color.domain(d3.keys(data1[0]).filter(function(key) { return key !== "date"; }));
	data1.forEach(function(d) {
	  //d.date = parseDate(d.date);
	});
	var crimes = color.domain().map(function(name) {
	  return {
	    name: name,
	    values: data1.map(function(d) {
	      return {date: d.date, temperature: +d[name]};
	    })
	  };
	});
	x.domain(d3.extent(data1, function(d) { return d.date; }));
	y.domain([
	  d3.min(crimes, function(c) { return d3.min(c.values, function(v) { return v.temperature; }); }),
	  d3.max(crimes, function(c) { return d3.max(c.values, function(v) { return v.temperature; }); })
	]);
	svg.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")")
	    .call(xAxis);
	svg.append("g")
	    .attr("class", "y axis")
	    .call(yAxis)
	  .append("text")
	    .attr("transform", "rotate(-90)")
	    .attr("y", 6)
	    .attr("dy", ".71em")
	    .style("text-anchor", "end")
	    .text("Crimes");
	
	var crime = svg.selectAll(".crime")
	    .data(crimes)
	  .enter().append("g")
	    .attr("class", "crime");
	
	crime.append("path")
	    .attr("class", "line")
	    .attr("d", function(d) { 
	    	return line(d.values); 
	    })
	    .style("stroke", function(d) { return color(d.name); });
	
	crime.append("text")
	    .datum(function(d) { return {name: d.name, value: d.values[d.values.length - 1]}; })
	    .attr("transform", function(d) { return "translate(" + x(d.value.date) + "," + y(d.value.temperature) + ")"; })
	    .attr("x", 3)
	    .attr("dy", ".35em")
	    .text(function(d) { return d.name; });

	
}
</script>
</body>
</html>
