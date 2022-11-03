1. Loading and preprocessing the data

Activity <- read.csv("C:/Users/diken/Έγγραφα/R/repdata_data_activity/activity.csv")

2. What is mean total number of steps taken per day?
        
        i. Calculate the total number of steps taken per day
        nona <- na.omit(Activity)
        SMean <- aggregate(steps~date, nona, sum)

        ii. Make a histogram of the total number of steps taken each day
        library(ggplot2)
        ggplot(data=SMean, aes(steps)) + geom_histogram(binwidth=400, fill="blue", col="black") + labs(main="Histogram: Total number of steps per day", x="Total number of steps per day")
        dev.off()

        iii. Calculate and report the mean and median of the total number of steps taken per day
        summary(SMean$steps)

3. What is the average daily activity pattern?
        i. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
        SIMean <- aggregate(steps~interval, nona, mean)
        ggplot(data=SIMean, aes(x=interval,y=steps)) + geom_line() + labs(title="Average number of steps taken", x="interval (1 interval = 5 minutes)")
        dev.off()
        
        ii. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
                SIMean[which.max(SIMean$steps),]

4. Imputing missing values

        i. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
        colSums(is.na(Activity))
        
        ii. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
        
        
        iii. Create a new dataset that is equal to the original dataset but with the missing data filled in.
        ActivityFull <- Activity
        ActivityFull$steps <- ifelse(is.na(ActivityFull$steps) == TRUE, SIMean$steps[SIMean$interval %in% ActivityFull$interval], ActivityFull$steps)
        head(ActivityFull)
        
        
        
        iv. Make a histogram of the total number of steps taken each day and calculate and report the mean and median total number of steps taken per day. 
        
        ActivityFullDate <- aggregate(steps~date, ActivityFull, sum)
        
        p1 <- ggplot(data=SMean, aes(steps)) + geom_histogram(binwidth=400, fill="blue", col="black") + labs(x=NULL,y=NULL) + ylim(c(0,12.5))
        p2 <- ggplot(data=ActivityFullDate, aes(steps)) + geom_histogram(binwidth=400, fill="yellow", col="black") + labs(x=NULL,y=NULL) + ylim(c(0,12.5))
        
        library(ggpubr)
        p1_p2 <- ggarrange(p1, p2, labels = c("Removed NA data", "Filled NA data"), ncol = 2, nrow = 1, font.label=list(size=12, face="plain"))
        annotate_figure(p1_p2, top = text_grob("Histograms of total number of steps taken each day", face="bold", size=15), bottom = text_grob("total number of steps taken each day"), left = text_grob("count", rot=90))
        
        rm(p1,p2,p1_p2)
        t1 <- summary(SMean)
        t2 <- summary(ActivityFullDate)
        cbind(t1,t2)
        rm(t1,t2)
        
        Do these values differ from the estimates from the first part of the assignment? 
                YES
        
        What is the impact of imputing missing data on the estimates of the total daily number of steps?
                It changes the range of the data, hence the median, mean etc.
        
5. Are there differences in activity patterns between weekdays and weekends?
        
        i. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.
        AWeek <- ActivityFull
        AWeek$day <- as.factor(weekdays(as.Date(AWeek$date)))
        AWeek$WD_WE <- as.factor(ifelse(AWeek$day == "Saturday" | AWeek$day == "Sunday", "weekend", "weekday"))
        head(AWeek)

        ii. Make a panel plot containing a time series plot (i.e.type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, 
        averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should 
        look like using simulated data.
        
        awd <- aggregate(steps ~ interval + WD_WE, AWeek, mean)
        head(awd)
        ggplot(data=awd, aes(colour=WD_WE, x=interval, y=steps)) + geom_line()+labs(x="interval (1 interval = 5 minutes)", y="steps", title="Average number of steps taken on weekdays/weekend") + facet_grid(WD_WE ~ .)