<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
<h2>Town vs Town Insights</h2>

<%
String compareby=request.getParameter("compareby");
String comparebytypes=request.getParameter("comparebytype");
String town1=request.getParameter("town1");
String town2=request.getParameter("town2");
%>
comparebytypes=<%= comparebytypes %><br>
<br>
Compare <i><%= town1 %></i> to <i><%= town2 %></i> by <b><%= compareby %></b><br>

<sql:query var="rstown1" dataSource="jdbc/TestDB">
select id, town, year1, violentcrime, murder, rape, robbery, assault,
propertycrime, burglary, larcenytheft, motorvehicletheft, arson from crime
where town = "<%= town1 %>" 
</sql:query>
<sql:query var="rstown2" dataSource="jdbc/TestDB">
select id, town, year1, violentcrime, murder, rape, robbery, assault,
propertycrime, burglary, larcenytheft, motorvehicletheft, arson from crime
where town = "<%= town2 %>" 
</sql:query>

<div id="viz1"></div>
<div id="viz2"></div>

<script type="text/javascript">
$(window).load(function() {
	
	d3.select("body").style("background-color", "yellow");
	
	var div1 = d3.select("div#viz1");
	var data1 = [
	    <c:forEach var="row1" items="${rstown1.rows}">
			{date:${row1.year1}, violentcrime:${row1.violentcrime}, murder:${row1.murder}, rape:${row1.rape}, 
				robbery:${row1.robbery}, assault:${row1.assault}, propertycrime:${row1.propertycrime},
				burglary:${row1.burglary}, larcenytheft:${row1.larcenytheft}, motorvehicletheft:${row1.motorvehicletheft},
				arson:${row1.arson} },
		</c:forEach>        			
	];
	addCrimeGraph(data1, div1);
	
	var div2 = d3.select("div#viz2");
	var data2 = [
   	    <c:forEach var="row2" items="${rstown2.rows}">
   			{date:${row2.year1}, violentcrime:${row2.violentcrime}, murder:${row2.murder}, rape:${row2.rape}, 
   				robbery:${row2.robbery}, assault:${row2.assault}, propertycrime:${row2.propertycrime},
   				burglary:${row2.burglary}, larcenytheft:${row2.larcenytheft}, motorvehicletheft:${row2.motorvehicletheft},
   				arson:${row2.arson} },
   		</c:forEach>        			
   	];
	addCrimeGraph(data2, div2);
	
});

function addCrimeGraph(data1, div1){
	
	var margin = {top: 20, right: 80, bottom: 30, left: 50},
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
	    .attr("d", function(d) { return line(d.values); })
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
