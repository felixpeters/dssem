# Path to repository - CHANGE THIS ACCORDING TO YOUR NEEDS
repo.path <- "~/projects/r/tud/dssem"

# Set working directory
setwd(repo.path)

# Load airline data for 2015
require(readr)
data.path <- paste(repo.path, "/data/2015_us_flights.csv", sep="")
X2015_us_flights <-
  read_csv(data.path)

# Drop X17 column
require(dplyr)
X2015_us_flights <- select(X2015_us_flights,-X17)

# Remove flights with zero seats
X2015_us_flights <- dplyr::filter(X2015_us_flights, SEATS > 0)
# Remove flights with more passengers than seats
X2015_us_flights <-
  dplyr::filter(X2015_us_flights, SEATS >= PASSENGERS)

# Calculate utilization ratio
X2015_us_flights <-
  mutate(X2015_us_flights, UTILIZATION = PASSENGERS / SEATS)
# Plot utilization density
require(ggplot2)
ggplot(data=X2015_us_flights, aes(x=UTILIZATION)) + geom_density() + labs(title="Utilization density for US flights in 2015")

# San Diego Comic con 2015 (9/7/15 - 12/7/15)
san_flights <-
  dplyr::filter(X2015_us_flights, DEST == "SAN" | ORIGIN == "SAN")
san_flights_july <- dplyr::filter(san_flights, MONTH == 7)
san_flights_june <- dplyr::filter(san_flights, MONTH == 6)
san_flights_aug <- dplyr::filter(san_flights, MONTH == 8)
# Plot utilization density for whole year and July specifically
ggplot() + geom_density(data = san_flights,
                        aes(x = UTILIZATION),
                        color = "darkblue") + geom_density(data = san_flights_july,
                                                   aes(x = UTILIZATION),
                                                   color = "red") + labs(title = "San Diego utilization for July (red) and whole year (blue)")
ggplot() + geom_density(data = san_flights_june,
                        aes(x = UTILIZATION),
                        color = "darkblue",
                        size = 0.5) + geom_density(data = san_flights_july,
                                                   aes(x = UTILIZATION),
                                                   color = "red",
                                                   size = 1) + geom_density(data = san_flights_aug,
                                                                            aes(x = UTILIZATION),
                                                                            color = "orange",
                                                                            size = 0.5) + labs(title = "San Diego Utilization for June (blue), July (red) & August (orange) 2015")
months <- c("June", "July", "August")
total_passengers <-
  c(
    sum(san_flights_june$PASSENGERS),
    sum(san_flights_july$PASSENGERS),
    sum(san_flights_aug$PASSENGERS)
  )
total_passengers_per_month <- data.frame(months, total_passengers)
ggplot(data = total_passengers_per_month) + geom_col(
  mapping = aes(x = months, y = total_passengers),
  fill = c("orange", "red", "darkblue")
) + labs(title = "San Diego total passengers for June (blue), July (red) & August (orange", x = "Months", y =
           "Total passengers")