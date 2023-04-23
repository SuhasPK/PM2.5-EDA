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


# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?
# Plot6.
library(scales)
library(ggplot2)
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