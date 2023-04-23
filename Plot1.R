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
