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