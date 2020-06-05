## 1. Download zipped data on household power consumption - downloading only the rows that will be used for the
## analysis

        temp <- tempfile()
        
        fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        
        download.file(fileurl, temp, mode = "wb")
        
        con <- unzip(temp, "household_power_consumption.txt")
        
        a <- length(grep("*/12/2006|*/1/2007", readLines(con))) + 1
        
        b <- length(grep("^1/2/2007|^2/2/2007", readLines(con)))
        
        h_power_consn_header <- read.table(con, sep = ";", nrows = 1, header = TRUE)
        
        h_power_consn <- read.table(con, sep = ";", header = FALSE, skip = a, nrows = b)
        
        unlink(temp)

## Formatting the file to be used - formatting the first two column as date and time and providing the appropriate
## columns names
        colnames(h_power_consn) <- names(h_power_consn_header)
        
        h_power_consn <- mutate(h_power_consn, Time2 = paste(h_power_consn$Date, h_power_consn$Time))
        
        h_power_consn <- h_power_consn[, c(1, 10, 3, 4, 5, 6, 7, 8, 9)]
        
        h_power_consn$Date <- as.Date(h_power_consn$Date, format = "%d/%m/%Y")
        
        h_power_consn$Time2 <- strptime(h_power_consn$Time2, format = "%d/%m/%Y %H:%M:%S")

## create the line graph

        png(file = "plot4.png")

        par(mfcol = c(2,2), mar = c(4, 4, 3, 2))

        with(h_power_consn, {
          
          plot(Time2, Global_active_power, type = "l", col = "grey30", xlab = "", ylab = "Global Active Power")
          
          plot(Time2, Sub_metering_1, type = "l", col = "grey40", xlab = "", ylab = "Energy sub metering")
          
          lines(Time2, Sub_metering_2, type = "l", col = "red", xlab = "", ylab = "")
          
          lines(Time2, Sub_metering_3, type = "l", col = "blue", xlab = "", ylab = "")
          
          legend("topright", lty = c(1, 1, 1), col = c("grey40", "red", "blue"), legend = names(h_power_consn[7:9]))
          
          plot(Time2, Voltage, type = "l", col = "grey20", xlab = "datetime", ylab = "Voltage")
          
          plot(Time2, Global_reactive_power, type = "l", col = "grey30", xlab = "datetime")
  
})

        dev.off()
        
        