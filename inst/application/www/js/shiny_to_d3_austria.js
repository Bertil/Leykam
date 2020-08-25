var w = 520;
var h = 520;

var starChartColors = [
  "rgba(85, 152, 195,0.87524)",
  "rgba(40, 150, 131,0.38889)",
  "rgba(98, 183, 225,0.55981)",
  "rgba(48, 164, 86, 0.72562)",
  "rgba(219, 76, 96, 0.79116)",
  "rgba(229, 99, 47, 0.85185)",
  "rgba(130, 172, 70, 0.86281)",
  "rgba(124, 59, 115, 0.87771)",
  "rgba(96, 96, 96, 0.87931)",
  "rgba(153, 143, 228, 0.91304)",
  "rgba(213, 155, 46, 0.92253)",
  "rgba(155, 213, 46, 0.92253)"
]

starColor = function(d){
  return starChartColors[d.key];
}
var chartCenter = h/2;


Shiny.addCustomMessageHandler(
  "austria-jsondata",
  function(message){

var dataset = JSON.parse(message);
//d3.select("#austria-starChart").selectAll("*").remove();

  var xScale = d3.scale.ordinal()
  				.domain(d3.range(dataset.length))
  				.rangeRoundBands([0, w], 0.125);

  var yScale = d3.scale.linear()
  				.domain([0, d3.max(dataset, function(d) {return d.value;})])
  				.range([0, Math.min(h,w)*0.45]);

  var key = function(d) {
  	return d.key;
  };
if(d3.select('#austria-starChart').select('svg')[0][0] === null){

  var svg = d3.select("#austria-starChart")
  			.append("svg")
  			.attr("width", w)
  			.attr("height", h);
  //Create SVG element



  //Create bars
  svg.selectAll("rect")
     .data(dataset, key)
     .enter()
     .append("rect")
     .attr("x", function(d, i) {
  		return(w/2 - xScale.rangeBand()/2);
     })
     .attr("y", function(d) {
  		return chartCenter - xScale.rangeBand()/2;
     })
     .attr("width", xScale.rangeBand())
     .attr("height", function(d) {
  		return yScale(d.value);
     })
     .attr("fill", function(d){
       return d.color;
     } )
     .attr("rx",xScale.rangeBand())
     .attr("ry",xScale.rangeBand()/2)
     .attr("transform",function(d,i){
     	return("rotate("+(i*30 +180)+"," + (w/2) + "," + chartCenter +")");
     })

  	//Tooltip
  	.on("mouseover", function(d,i) {
  		var xPosition = w / 2 - Math.sin(i*2*Math.PI/12) * yScale(5)-100 ;
  		var yPosition = chartCenter + xScale.rangeBand()/4 + Math.cos(i*2*Math.PI/12) * yScale(5)-60;

  		//Update Tooltip Position & value
  		d3.select("#austria-tooltip")
  			.style("left", xPosition + "px")
  			.style("top", yPosition + "px")
  			.select("#austria-indicator_value")
  			.text('Index: ' + d.value);
  		d3.select("#austria-tooltip")
  			.select("#austria-indicator_name")
  			.text(d.label)
  			.style('color', d.color);
  		d3.select("#austria-tooltip").classed("hidden", false);
  	})
  	.on("mouseout", function() {
  		d3.select("#austria-tooltip").classed("hidden", true);
  	})	;

  svg.selectAll("text")
     .data(dataset, key)
     .enter()
     .append("text")
     .text(function(d) {
  		return d.value;
     })
     .attr("text-anchor", "middle")
     .attr("x", function(d, i) {
  		return (w / 2 - Math.sin((6+i)*2*Math.PI/12) * yScale(d.value))
     })
     .attr("y", function(d,i) {
  		return (chartCenter + xScale.rangeBand()/4 + Math.cos((6+i)*2*Math.PI/12) * yScale(d.value));
     })
     .attr("font-family", "sans-serif")
     .attr("font-size", "14px")
     .attr("font-weight", "bold")
     .attr("fill", function(d){
       return d.color;
     } )

  	//Tooltip on the text aswell
  	.on("mouseover", function(d,i) {
  		var xPosition = w / 2 - Math.sin((6+i)*2*Math.PI/12) * yScale(7)-60 ;
  		var yPosition = chartCenter + xScale.rangeBand()/4 + Math.cos((6+i)*2*Math.PI/12) * yScale(7)-40;

  		//Update Tooltip Position & value
  		d3.select("#austria-tooltip")
  			.style("left", xPosition + "px")
  			.style("top", yPosition + "px")
  			.select("#austria-indicator_value")
  			.text('Index: ' + d.value);
  		d3.select("#austria-tooltip")
  			.select("#austria-indicator_name")
  			.text(d.label)
  			.style('color', d.color);
  		d3.select("#austria-tooltip").classed("hidden", false);
  	})
  	.on("mouseout", function() {
  		d3.select("#austria-tooltip").classed("hidden", true);
  	})	;
} else {
  var svg = d3.select('#austria-starChart')
    .select('svg');

  svg.selectAll('rect')
    .data(dataset, key)
    //Tooltip
  	.on("mouseover", function(d,i) {
  		var xPosition = w / 2 - Math.sin((6+i)*2*Math.PI/12) * yScale(5)-100 ;
  		var yPosition = chartCenter + xScale.rangeBand()/4 + Math.cos((6+i)*2*Math.PI/12) * yScale(5)-60;

  		//Update Tooltip Position & value
  		d3.select("#austria-tooltip")
  			.style("left", xPosition + "px")
  			.style("top", yPosition + "px")
  			.select("#austria-indicator_value")
  			.text('Index: ' + d.value);
  		d3.select("#austria-tooltip")
  			.select("#austria-indicator_name")
  			.text(d.label)
  			.style('color', d.color);
  		d3.select("#austria-tooltip").classed("hidden", false);
  	})
  	.on("mouseout", function() {
  		d3.select("#austria-tooltip").classed("hidden", true);
  	})
  	.transition()
    .delay(function (d, i) { return i*200; })
    .attr("height", function(d) {
      return yScale(d.value);
    });

  svg.selectAll('rect')
    //Tooltip
  	.on("mouseover", function(d,i) {
  		var xPosition = w / 2 - Math.sin((6+i)*2*Math.PI/12) * yScale(5)-100 ;
  		var yPosition = chartCenter + xScale.rangeBand()/4 + Math.cos((6+i)*2*Math.PI/12) * yScale(5)-60;

  		//Update Tooltip Position & value
  		d3.select("#austria-tooltip")
  			.style("left", xPosition + "px")
  			.style("top", yPosition + "px")
  			.select("#austria-indicator_value")
  			.text('Index: ' + d.value);
  		d3.select("#austria-tooltip")
  			.select("#austria-indicator_name")
  			.text(d.label)
  			.style('color', d.color);
  		d3.select("#austria-tooltip").classed("hidden", false);
  	})
  	.on("mouseout", function() {
  		d3.select("#austria-tooltip").classed("hidden", true);
  	});

  svg.selectAll('text')
    .data(dataset, key)
    .transition()
    .delay(function (d, i) { return i*200; })
    .text(function(d) {
      return d.value;
    })
    .attr("text-anchor", "middle")
    .attr("x", function(d, i) {
      return (w / 2 - Math.sin((6+i)*2*Math.PI/12) * yScale(d.value));
    })
    .attr("y", function(d,i) {
      return (chartCenter + xScale.rangeBand()/4 + Math.cos((6+i)*2*Math.PI/12) * yScale(d.value));
    });


}
  });
