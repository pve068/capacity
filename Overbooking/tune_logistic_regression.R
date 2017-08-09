# tune the parameters of the logistic regression model used for overbooking
library(RODBC)

# read in appropriate data
con <- odbcDriverConnect(connection="driver={SQL Server};server=scrbsqlaze041;
                         database=analyticsdatamart;uid=raappuser;
                         pwd=C0ntainers1@;")

res <- sqlQuery(con, "select top 1000 * from dbo.booking_snapshot")
odbcClose(con)

# format data as required for logistic regression

# run logistic regression

# parse results as desired

# output results