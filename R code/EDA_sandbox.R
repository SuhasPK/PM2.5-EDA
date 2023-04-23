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

# Plotting the data.

# Total Emissions plot. PLOT1
png(filename = "Plot1.png",width= 720, height=720)
if (!"Total_Emission" %in% ls()){
    Total_Emission <- aggregate(NEI$Emissions, list(NEI$year), FUN = "sum")
}
plot(
    Total_Emission, type = "b",
    pch = 13, col = "red",
    xlab = "Year",
    main = expression('Total PM'[2.5]*" Emission in the United States from 1999 to 2008"),
    ylab = expression('Total PM'[2.5]*" Emission (in tons)" ) 
)
dev.off()

# Baltimore data plot. PLOT2
if (!"Baltimore_data" %in% ls()){
    Baltimore_data <- NEI[NEI$fips == "24510", ]
}

png(filename = "Plot2.png", width = 720, height = 720)

if (!"Baltimore_total_emission" %in% ls()){
    Baltimore_total_emission <- aggregate(Baltimore_data$Emissions, list(Baltimore_data$year), FUN = "sum")
}
plot(Baltimore_total_emission, type = "b",
     pch = 20, col = "blue",
     xlab = "Year",
     main = expression('Total PM'[2.5]*" Emissions in Baltimore City, Maryland from 1999 to 2008"),
     ylab = expression('Total PM'[2.5]*" Emission (in tons)")
)
dev.off()

# Plot using ggplot2. PLOT3
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

# Coal combustion changed from 1999-2008. PLOT4
View(SCC)
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

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?
# Plot6.
library(scales)
bltmr <- NEI[(NEI$fips=="24510"), ]
bltmr <- aggregate(Emissions~year, data = bltmr, FUN = sum)
la <- NEI[(NEI$fips=="06037"),]
la <- aggregate(Emissions~year, data = la, FUN = sum)
bltmr$county <- "Baltimore"
la$county <- "Los Angeles"
data <- rbind(bltmr,la)
func <- function(){
    f <- function(x) as.character(round(x,2))
    f
}
png(filename = "Plot6.png",width=720,height=720,units="px")
ggplot(data, aes(x=factor(year),y=Emissions,fill=county))+
    geom_bar(aes(fill=county),position = "dodge", stat = "identity")+
    labs(y = expression("Total Emissions (in log scale) of PM"[2.5])) + xlab("year") + ggtitle(expression("Motor vehicle emission in Baltimore and Los Angeles")) + scale_y_continuous(trans = log_trans(), labels = func())
dev.off()


 
