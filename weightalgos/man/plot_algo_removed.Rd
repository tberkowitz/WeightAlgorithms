% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_algo_removed.R
\name{plot_algo_removed}
\alias{plot_algo_removed}
\title{visualize algorithm output}
\usage{
plot_algo_removed(df, input, output, title)
}
\arguments{
\item{df}{\code{data.frame} holding raw (input) measurements and algorithm-
processed (output) measurements.}

\item{input}{string corresponding to the name of the original weight data in
\code{df}.}

\item{output}{string corresponding to the name of the algorithm processed
weight data in \code{df}.}

\item{title}{character string, desired plot title}
}
\value{
ggplot object
}
\description{
function to plot a 2D jittered plot juxtaposing algorithm-removed data on
"top" or in "front" of input data.
}
