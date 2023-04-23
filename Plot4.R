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

if (!"Coal_NEI" %in% ls()){
    coal <- SCC[grep("Comb.*Coal", SCC$Short.Name),"SCC"]
    Coal_NEI <- NEI[NEI$SCC %in% coal,]
}
if (!"Combustion_data" %in% ls()){
    Combustion_data <- ddply(Coal_NEI, .(year), summarise, Total_emission = sum(Emissions))
}

png(filename = "Plot4.png", width = 720, height=720, units = "px" )
ggplot(Combustion_data,aes(year, Total_emission))+
    geom_line(color = "red") +geom_point()+
    labs(title = "Total Emissions from Coal Combustion-Related Sources", x = "Year", y = "Total Emissions")
dev.off()