% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Goodrich2016.R
\name{goodrich}
\alias{goodrich}
\title{Goodrich et al. 2016 Measurment Cleaning Algorithm}
\usage{
goodrich(
  df,
  id,
  measures,
  tmeasures,
  startPoint,
  t = c(0, 182, 365),
  windows = c(30, 60, 60),
  outliers = list(LB = c(80, 80, 80), UB = c(500, 500, 500)),
  wtchng_thresh = 100,
  excludeSubject = FALSE
)
}
\arguments{
\item{df}{object of class \code{data.frame}, containing \code{id} and
\code{weights}.}

\item{id}{string corresponding to the name of the column of group identifiers
in \code{df}.}

\item{measures}{string corresponding to the name of the column of measures in
\code{df}, e.g., numeric weight data if using to clean weight data.}

\item{tmeasures}{string corresponding to the name of the column of measure
dates and/or times in \code{df}.}

\item{startPoint}{string corresponding to the name of the column in \code{df}
holding the time at which subsequent measurement dates will be assessed,
should be the same for each person. Eg., if t = 0 (\code{t[1]}) corresponds
to an index visit held by the variable \code{VisitDate}, then
\code{startPoint} should be set to \code{VisitDate}.}

\item{t}{numeric vector of time points to collect measurements, eg.
\code{c(0, 182.5, 365)} for measure collection at t = 0, t = 180 (6 months
from t = 0), and t = 365 (1 year from t = 0). Default is
\code{c(0, 182.5, 365)} according to Janney et al. 2016.}

\item{windows}{numeric vector of measurement collection windows to use around
each time point in \code{t}. Eg. Janney et al. 2016 use
\code{c(30, 60, 60)} for \code{t} of \code{c(0, 182.5, 365)}, implying that
the closest measurement t = 0 will be collected 30 days prior to and 30
days post \code{startPoint}. Subsequent measurements will be collected 60
days prior to and 60 days post t0+182.5 days, and t0+365 days.}

\item{outliers}{optional. object of type \code{list} with numeric inputs
corresponding to the upper and lower bound for each time entry in parameter
\code{t}. Default is \code{list(LB = c(80, 80, 80), UB = c(500, 500, 500))}
for \code{t = c(0, 182.56, 365)}, differing between baseline and subsequent
measurment collection dates. If not specified then only the subsetting and
window functions will be applied.}

\item{wtchng_thresh}{numeric scalar used as a cutoff for higher than (or
lower than) expected weight changes from one time point j to time point
j + 1, by person or group. Default is 100.}

\item{excludeSubject}{logical. If TRUE remove groups meeting the exclusion
criteria.}
}
\value{
returns a data frame with 3 new columns, \code{time} (the actual time
  of captured measurement data as dictated by \code{t} +/- \code{windows}),
  \code{measureTime} (which time-point the data in \code{measout} refers to
  as dictated by \code{t}), and \code{measout} (the "cleaned" measure). The
  result will contain up to \code{length(t)} rows per group \code{id}. If
  \code{excludeSubject} is set to TRUE, those meeting the exclusion criteria
  are removed from the resultant data frame.
}
\description{
For grouped time series, (e.g., per person) \code{goodrich} defines time
points and collects measurements, optionally applying windows for possible
data points for each time point, then proceeds to flag and/or remove within
group outliers. Based on work by Goodrich et al. 2016.
}
\examples{
library(dplyr)
data(cdw1000)

goodrich_df <- goodrich(
   df = cdw1000,
   id = "id",
   measures = "Weight",
   tmeasures = "WeightDate",
   startPoint = "VisitDate"
  )

# dplyr::glimpse(goodrich_df)

compare_df <- bind_rows(
  "Input"  = cdw1000 \%>\% select(Weight),
  "Output" = goodrich_df \%>\%
     select(measout) \%>\%
     na.omit() \%>\%
     rename(Weight = measout),
  .id = "IO"
)

compare_df \%>\%
  group_by(IO) \%>\%
  summarize(
    n      = n(),
    mean   = mean(Weight),
    sd     = sd(Weight),
    min    = min(Weight),
    median = median(Weight),
    max    = max(Weight)
  )
}
