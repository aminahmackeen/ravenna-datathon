library(dplyr)
library(stringr)
library(readr)

#load raw data
df <- read_csv("Downloads/Customer_Service_Requests_20250426.csv")

#remove x,y values, longtitude, latitude
filter_df <- select(df, c("Service Request Number", "Service Request Type", "City Department",
                           "Created Date", "Method Received", "Status", "ZIP Code", "Council District",
                           "Police Precinct", "Neighborhood"))

#remove NAs
cleaned_df <- na.omit(filter_df)

# Convert to datetime
timestamp_dt <- as.POSIXct(cleaned_df$`Created Date`, format = "%m/%d/%Y %I:%M:%S %p")

# Extract year to create new columns 
cleaned_df$Year <-format(timestamp_dt, "%Y")

# Extract month to create new columns 
cleaned_df$Month <-format(timestamp_dt, "%m")

# Extract quarter to create new columns 
cleaned_df$Quarter <- mapvalues(
  cleaned_df$Month, 
  from = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"),
  to   = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4)
)

# Extract Day of Week to create new columns
cleaned_df$DayOfWeek <- weekdays(timestamp_dt)

# Extract AM/PM to create new columns 
cleaned_df$Time <-format(timestamp_dt, "%p")

# Export to CSV
write.csv(merged_df, "Cleaned_Customer_Service.csv")
