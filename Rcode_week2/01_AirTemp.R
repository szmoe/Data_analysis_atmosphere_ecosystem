## ---
##   DWD Air Temperature Data (Hourly → Daily Mean)
##   Example for Data Analysis of Ecosystem-atmosphere interactions
## ---

## --- 1. Setup ----------------------------------------------------------------

## Define file path (use forward slashes in Windows)
#file_path <- "D:/Environment Modelling group/Teaching/DEAI/DEAI_Class/DEAI_Week2/Air_Temperature/stundenwerte_TU_02667_19600101_20241231_hist/produkt_tu_stunde_19600101_20241231_02667.txt"
file_path <- "Data_DWD/Air_Temperature/stundenwerte_TU_02667_19600101_20241231_hist/produkt_tu_stunde_19600101_20241231_02667.txt"

## Look at the first lines (header and metadata). Just characters.
cat(readLines(file_path, n = 20), sep = "\n")   # cat >>> concatenate and print , \n >>> add new line

## --- 2. Read the data --------------------------------------------------------

d <- read.csv(file_path,
              sep = ";",                    # semicolon delimiter
              comment.char = "#",           # ignore comment lines
              na.strings = c("-999", "-999.0"),  # mark -999 as NA
              stringsAsFactors = FALSE)     # no factors in our data

## Ensure missing codes (-999) are NA 
d$TT_TU[d$TT_TU == -999 | d$TT_TU == -999.0] <- NA

## Check structure
head(d)
names(d)
## Expected: STATIONS_ID, MESS_DATUM, QN_9, TT_TU, RF_TU, eor    #eor: end of record

## --- 3. Parse datetime (UTC) -------------------------------------------------

## Convert YYYYMMDDHH → POSIXct (UTC)
## Ensure MESS_DATUM is character before parsing (format: YYYYMMDDHH)
d$MESS_DATUM <- as.character(d$MESS_DATUM)
d$datetime <- as.POSIXct(strptime(d$MESS_DATUM, "%Y%m%d%H", tz = "UTC"))


## --- 4. Basic data checks ----------------------------------------------------

sum_na <- sum(is.na(d$TT_TU))
range_tt <- range(d$TT_TU, na.rm = TRUE) # remove the NA values

cat("\nMissing (NA) values:", sum_na, "\n")
cat("Temperature range [°C]:", paste(range_tt, collapse = " to "), "\n")


## --- 5. Subset data (1995–2024) ---------------------------------------------

t_start <- as.POSIXct("1995-01-01 00:00", tz = "UTC")
t_end   <- as.POSIXct("2024-12-31 23:00", tz = "UTC")

d_sub <- d[d$datetime >= t_start & d$datetime <= t_end, ]

cat("Rows full data:", nrow(d), "\n")
cat("Rows in subset (1995–2024):", nrow(d_sub), "\n")

## --- 6. Compute daily mean temperature ---------------------------------------

d_sub$date <- as.Date(d_sub$datetime, tz = "UTC") # coz we want daily mean; not hourly mean

# Aggregate TT_TU column based on the date and calculate daily mean
daily_mean <- aggregate(TT_TU ~ date, data = d_sub, FUN = mean, na.rm = TRUE) 

head(daily_mean)

## --- 7. Plot and save as PNG -------------------------------------------------

## Define output file name
png_filename <- "pic/daily_mean_TT_TU_02667_1995_2024.png"

## Open a PNG graphics device (width/height in pixels)
png(filename = png_filename, width = 1600, height = 800, res = 120)

## Create the plot
plot(daily_mean$date, daily_mean$TT_TU,
     type = "l", col = "steelblue", lwd = 0.8,
     xlab = "Date",
     ylab = "Daily Mean Air Temperature (°C)",
     main = "Daily Mean Air Temperature (DWD Station 02667, 1995–2024)")
grid()  # add background grid

## Close the PNG device (saves the file)
dev.off()

cat("Plot saved as:", normalizePath(png_filename), "\n")

## --- 8. Save daily data table ------------------------------------------------

out_csv <- "output_csv/daily_mean_TT_TU_02667_1995_2024.csv"
write.csv(daily_mean, out_csv, row.names = FALSE)
cat("Daily mean data saved to:", normalizePath(out_csv), "\n")
