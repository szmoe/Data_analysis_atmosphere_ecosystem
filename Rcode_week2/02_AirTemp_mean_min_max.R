## ===================================================================
##  DWD Air Temperature (Hourly -> Daily Mean/Min/Max)  [UTC]
##  Simple teaching script
## ===================================================================

## --- 1) Setup ---------------------------------------------------------------

## Use forward slashes (or double backslashes) on Windows
#file_path <- "D:/Environment Modelling group/Teaching/DEAI/DEAI_Class/DEAI_Week2/Air_Temperature/stundenwerte_TU_02667_19600101_20241231_hist/produkt_tu_stunde_19600101_20241231_02667.txt"
file_path <- "Data_DWD/Air_Temperature/stundenwerte_TU_02667_19600101_20241231_hist/produkt_tu_stunde_19600101_20241231_02667.txt"

## Quick peek at the file header & metadata (no table parsing yet, it reads all as character just to present the file)
cat(readLines(file_path, n = 20), sep = "\n")

## --- 2) Read the semicolon-delimited file -----------------------------------

d <- read.csv(file_path,
              sep = ";",
              comment.char = "#",             # ignore DWD comment lines
              stringsAsFactors = FALSE,
              na.strings = character(0))      # we’ll replace numeric -999 manually

## Confirm structure
head(d)
names(d)  # STATIONS_ID; MESS_DATUM; QN_9; TT_TU; RF_TU; eor




## --- 3) Parse datetime (UTC) -------------------------------------------------

## Ensure MESS_DATUM is character before parsing (format: YYYYMMDDHH)
d$MESS_DATUM <- as.character(d$MESS_DATUM)
d$datetime   <- as.POSIXct(strptime(d$MESS_DATUM, "%Y%m%d%H", tz = "UTC"))


## --- 4) Clean missing values (-999 numeric -> NA) ---------------------------

## Replace any numeric -999 (and -999.0) in temperature with NA
d$TT_TU[d$TT_TU == -999 | d$TT_TU == -999.0] <- NA


## Count missing values and check range AFTER cleaning
sum_na  <- sum(is.na(d$TT_TU))
range_tt <- range(d$TT_TU, na.rm = TRUE)

cat("\nMissing values (NA):", sum_na, "\n")
cat("Temperature range [°C]:", paste(range_tt, collapse = " to "), "\n")
## use summary function
summary(d)
## do it again after deleting NA in the RF_TU column to see mean values change 
#d$RF_TU[d$RF_TU == -999 | d$RF_TU == -999.0] <- NA
#summary(d)

## --- 5) Subset to 1995-01-01 .. 2024-12-31 (UTC) ----------------------------

t_start <- as.POSIXct("1995-01-01 00:00", tz = "UTC")
t_end   <- as.POSIXct("2024-12-31 23:00", tz = "UTC")

d_sub <- d[d$datetime >= t_start & d$datetime <= t_end, ]
cat("Rows full data:", nrow(d), "\n")
cat("Rows in subset (1995–2024):", nrow(d_sub), "\n")

## --- 6) Daily aggregation: mean, min, max -----------------------------------

## Create a date column (drops the hour)
d_sub$date <- as.Date(d_sub$datetime, tz = "UTC")

## Compute daily mean/min/max of air temperature
daily_mean <- aggregate(TT_TU ~ date, data = d_sub, FUN = mean, na.rm = TRUE)
daily_min  <- aggregate(TT_TU ~ date, data = d_sub, FUN = min,  na.rm = TRUE)
daily_max  <- aggregate(TT_TU ~ date, data = d_sub, FUN = max,  na.rm = TRUE)

## Merge into a single table (optional but handy)
daily_all <- merge(daily_mean, daily_min, by = "date", suffixes = c("_mean", "_min"))
daily_all <- merge(daily_all, daily_max, by = "date")
names(daily_all)[4] <- "TT_TU_max"   #Alternatively we could use  suffixes = c("", "_max")

head(daily_all)

## --- 7) Save CSV output -----------------------------------------------------

write.csv(daily_all,  "output_csv/daily_all_TT_TU_02667_1995_2024.csv",  row.names = FALSE)

cat("Saved CSV in:", normalizePath("."), "\n")

## --- 8) Save plots separately ------------------------------------------------
## One PNG per plot: mean, min, max, and a combined min–max.

## 8a) Daily mean
png("pic/plot_daily_mean_TT_TU_02667_1995_2024.png", width = 1600, height = 800, res = 120)
plot(daily_mean$date, daily_mean$TT_TU,
     type = "l",col = "orange", lwd = 0.8,
     xlab = "Date", ylab = "Daily Mean Air Temperature (°C)",
     main = "Daily Mean Air Temperature (DWD Station 02667, 1995–2024)",
     xaxt = "n")  # suppress automatic x-axis

## Define tick positions every 5 years from 1995 to 2025
tick_years <- seq(from = as.Date("1995-01-01"), 
                  to   = as.Date("2025-01-01"), 
                  by   = "5 years")

## Add custom x-axis with year labels
axis(side = 1, at = tick_years, labels = format(tick_years, "%Y"))

## Add y-axis manually for clarity
#axis(side = 2)
## Add grid lines that align with tick marks
#abline(v = tick_years, col = "lightgray", lty = "dotted")  # vertical grid lines at 5-year marks
#abline(h = pretty(daily_max$TT_TU), col = "lightgray", lty = "dotted")  # horizontal grid lines at nice temperature values
## Add a box around the plot
#box()

dev.off()

## Alternatively you can copy what plot on the graphic panel show
#plot(daily_mean$date, daily_mean$TT_TU,
#     type = "l",col = "orange", lwd = 0.8,
#     xlab = "Date", ylab = "Daily Mean Air Temperature (°C)",
#     main = "Daily Mean Air Temperature (DWD Station 02667, 1995–2024)")
#grid()
#dev.copy(png, "plot_daily_mean_TT_TU_02667_1995_2024.png",
#        width = 1600, height = 800, res = 120)
#dev.off()


## 8b) Daily minimum
png("pic/plot_daily_min_TT_TU_02667_1995_2024.png", width = 1600, height = 800, res = 120)
plot(daily_min$date, daily_min$TT_TU,
     type = "l",col = "steelblue", lwd = 0.8,
     xlab = "Date", ylab = "Daily Minimum Air Temperature (°C)",
     main = "Daily Minimum Air Temperature (DWD Station 02667, 1995–2024)")

tick_years <- seq(from = as.Date("1995-01-01"), 
                  to   = as.Date("2025-01-01"), 
                  by   = "5 years")
axis(side = 1, at = tick_years, labels = format(tick_years, "%Y"))

#grid()
dev.off()


## 8c) Daily maximum
png("pic/plot_daily_max_TT_TU_02667_1995_2024.png", width = 1600, height = 800, res = 120)
plot(daily_max$date, daily_max$TT_TU,
     type = "l",col = "red", lwd = 0.8,
     xlab = "Date", ylab = "Daily Maximum Air Temperature (°C)",
     main = "Daily Maximum Air Temperature (DWD Station 02667, 1995–2024)")

tick_years <- seq(from = as.Date("1995-01-01"), 
                  to   = as.Date("2025-01-01"), 
                  by   = "5 years")
axis(side = 1, at = tick_years, labels = format(tick_years, "%Y"))

#grid()
dev.off()

cat("Saved PNG plots in:", normalizePath("."), "\n")



# library(ggplot2)
# 
# p <- ggplot(daily_max, aes(x = date, y = TT_TU)) +
#   geom_line(color = "blue", linewidth = 0.6) +
#   scale_x_date(date_breaks = "5 years", date_labels = "%Y") +
#   labs(x = "Date", y = "Daily Maximum Air Temperature (°C)",
#        title = "Daily Maximum Air Temperature (DWD Station 02667, 1995–2024)") +
#   theme_minimal()

##Save directly as PNG
#ggsave("plot_daily_minmax_TT_TU_02667_1995_2024.png",
#       plot = p, width = 12, height = 6, dpi = 120)

