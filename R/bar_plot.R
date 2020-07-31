# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#' Plot a barplot of the given values and highlight one value
#'
#' @param values numeric vector to plot
#' @param to_highlight position to highlight
#' @return ggplot2 plot object
#'
#' @export
bar_plot <- function(values, to_highlight, colors = customColors1, plotTheme = theme_classic()) {

  which_to_highlight <- rep(to_highlight, length(values))
  data <- data_frame(values = values, to_highlight= which_to_highlight)
  data$districts <- rep(1:length(values))

  data <- data[order(data$values),]
  data$districts <- factor(data$districts, unique(data$districts))

  # Designing the plot
  plot <- ggplot(data, aes(x= districts,y = values)) + # define data
    geom_bar(stat="identity", aes(fill= districts==to_highlight)) + # barplot with proportions
    scale_fill_manual(values = c('grey', 'firebrick')) + #set colors of fill
    guides(fill=FALSE) + #turn of legend of fill var
    scale_y_continuous(breaks=scales::pretty_breaks()) + # define y axis
    xlab("") + ylab("") + # no axis titles
    plotTheme +
    theme(axis.title.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.x =element_blank(),
          axis.text.y =element_text(margin=margin(l=-18)))
  plot
}
