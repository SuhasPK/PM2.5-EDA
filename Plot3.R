# downloading the data-set
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destfile <- "data.zip"
download.file(url = url,destfile = destfile)

# unzipping the data.zip file
path <- getwd()
if (!file.exists("PM2.5-EDA")){
    unzip("data.zip",exdir = path)
}

ls()

# reading the data sets
if (!"NEI" %in% ls()){
    NEI <- readRDS(paste(path,sep = "/","summarySCC_PM25.rds"))
}
summary(NEI)

if (!"SCC" %in% ls()){
    SCC <- readRDS(paste(path,sep = "/","Source_Classification_Code.rds"))
}
summary(SCC)

library(ggplot2)
library(plyr)

if (!"Bltmr_data" %in% ls()){
    Bltmr_data <- ddply(Baltimore_data, .(type, year),
                        summarise, 
                        TotalEmission = sum(Emissions))
}

png(filename = 'Plot3.png', width =720, height =720, units = 'px')
ggplot(Bltmr_data, aes(year,TotalEmission, color = type)) + geom_line() + geom_point() + labs(title = expression('Total PM'[2.5]*" Emissions in Baltimore City, Maryland from 1999 to 2008"),x = "Year",y = expression('Total PM'[2.5]*"Emission (in tons)"))
dev.off()