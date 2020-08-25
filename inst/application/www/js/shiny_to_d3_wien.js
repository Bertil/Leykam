
Shiny.addCustomMessageHandler(
  "wien-jsondata",
  function(message){

var dataset = JSON.parse(message);
//d3.select("#wien-starChart").selectAll("*").remove();

  var xScale = d3.scale.ordinal()
  				.domain(d3.range(dataset.length))
  				.rangeRoundBands([0, w], 0.125);

  var yScale = d3.scale.linear()
  				.domain([0, d3.max(dataset, function(d) {return d.value;})])
  				.range([0, Math.min(h,w)*0.45]);

  var key = function(d) {
  	return d.key;
  };
if(d3.select('#wien-starChart').select('svg')[0][0] === null){

  var svg = d3.select("#wien-starChart")
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
  		d3.select("#wien-tooltip")
  			.style("left", xPosition + "px")
  			.style("top", yPosition + "px")
  			.select("#wien-indicator_value")
  			.text('Index: ' + d.value);
  		d3.select("#wien-tooltip")
  			.select("#wien-indicator_name")
  			.text(d.label)
  			.style('color', d.color);
  		d3.select("#wien-tooltip").classed("hidden", false);
  	})
  	.on("mouseout", function() {
  		d3.select("#wien-tooltip").classed("hidden", true);
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
  		d3.select("#wien-tooltip")
  			.style("left", xPosition + "px")
  			.style("top", yPosition + "px")
  			.select("#wien-indicator_value")
  			.text('Index: ' + d.value);
  		d3.select("#wien-tooltip")
  			.select("#wien-indicator_name")
  			.text(d.label)
  			.style('color', d.color);
  		d3.select("#wien-tooltip").classed("hidden", false);
  	})
  	.on("mouseout", function() {
  		d3.select("#wien-tooltip").classed("hidden", true);
  	})	;
} else {
  var svg = d3.select('#wien-starChart')
    .select('svg');

  svg.selectAll('rect')
    .data(dataset, key)
    //Tooltip
  	.on("mouseover", function(d,i) {
  		var xPosition = w / 2 - Math.sin((6+i)*2*Math.PI/12) * yScale(5)-100 ;
  		var yPosition = chartCenter + xScale.rangeBand()/4 + Math.cos((6+i)*2*Math.PI/12) * yScale(5)-60;

  		//Update Tooltip Position & value
  		d3.select("#wien-tooltip")
  			.style("left", xPosition + "px")
  			.style("top", yPosition + "px")
  			.select("#wien-indicator_value")
  			.text('Index: ' + d.value);
  		d3.select("#wien-tooltip")
  			.select("#wien-indicator_name")
  			.text(d.label)
  			.style('color', d.color);
  		d3.select("#wien-tooltip").classed("hidden", false);
  	})
  	.on("mouseout", function() {
  		d3.select("#wien-tooltip").classed("hidden", true);
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
  		d3.select("#wien-tooltip")
  			.style("left", xPosition + "px")
  			.style("top", yPosition + "px")
  			.select("#wien-indicator_value")
  			.text('Index: ' + d.value);
  		d3.select("#wien-tooltip")
  			.select("#wien-indicator_name")
  			.text(d.label)
  			.style('color', d.color);
  		d3.select("#wien-tooltip").classed("hidden", false);
  	})
  	.on("mouseout", function() {
  		d3.select("#wien-tooltip").classed("hidden", true);
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
