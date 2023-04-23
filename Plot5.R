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

# Motor Vehicle. PLOT5
if (!"motor" %in% ls()){
    motor <- ddply(
        NEI[NEI$fips == "24510" & NEI$type == "ON-ROAD",], .(type,year),summarise, total_emission = sum(Emissions)
    )
}
png(filename = "Plot5.png", width = 720, height = 720, units = "px")
ggplot(motor, aes(year, total_emission))+ 
    geom_line(color="green")+
    geom_point()+
    labs(title = "Total Emissions from Motor Vehicles in Baltimore City", x = "Year", y = "Total Emissions") + theme(text = element_text(size = 14))
dev.off()