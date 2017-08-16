# batch tune the parameters of the materialization models for on-the-books
# INPUT:
# 1) segmentation
# 2) dependent and independent variables
# 3) materialization model type
# OUTPUT:
# 1) list of fit objects

library(dplyr)

BatchTuneOTBMaterialization <- function(cols.segment = c("wp"),
                                        dep.var = "final_status_code",
                                        indep.vars = c("cargotype"),
                                        model.type = "logistic"){
  
  segs <- GetSegments(cols.segment = cols.segment)
  ret <- c()
  
  for (seg in segs){
    booking.data <- GetBookingDataForSegment(seg)
    seg.fit <- TuneModel(booking.data, dep.var, indep.vars, model.type)
    # each fit object is a list of length 30
    # so length of ret will be 30 * number of segments
    ret <- c(ret, seg.fit)
  }
  
  return(ret)
}

GetSegments <- function(cols.segment){
  # Gets all possible segments.
  #
  # Args:
  #   cols.segment: The columns in the data along which to segment.
  #
  # Returns:
  #   All values of the segmentation variables.
  
  # TODO: fill in, e.g., select distinct wp from table;
  # return list of all values, e.g., (13, 12, 11, ..., 0)
  
  # for now, return just one segment
  ret <- c(1)
  return(ret)
}

GetBookingDataForSegment <- function(seg){
  # Gets booking data for a given segment.
  #
  # Args:
  #   seg: Segment for which to get booking data.
  #
  # Returns:
  #   Data frame with booking data for the given segment.
  
  # TODO: fill in, e.g., select * from table where segment = seg;
  # return data frame with appropriate columns and rows
  
  # for now, just read from a static csv sample file
  ret <- read.csv(
    "C:/Users/BKues/OneDrive - Revenue Analytics/Maersk/booking_sample.csv",
    sep = ";")
  ret$final_status_code <- ret$final_status == "Cancelled by Customer"
  return(ret)
}

TuneModel <- function(data, dep.var, indep.vars, model.type){
  # Tune the model for the given data, variables, and model type.
  #
  # Args:
  #   data: Data frame which contains all data for the model.
  #   dep.var: chr column name of dependent variable
  #   indep.vars: List of chr column names of independent variables
  #   model.type: chr name of model type (e.g., "logistic")
  #
  # Returns:
  #   Fit object for given arguments.
  
  fmla <- as.formula(paste(dep.var, "~", paste(indep.vars, collapse = "+")))
  
  # TODO: filter based on model type, for now just logistic regression
  if (model.type == "logistic"){
    ret <- glm(fmla, data = data)
  }
  
  return(ret)
}