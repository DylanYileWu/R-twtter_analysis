# Author: Yile Wu
# Date: Aug 10 2016
# descript:This scrpt will read tweets (in csv format) of a twitter user, and computes the retweet and reponse of this user
# here is the python script to download tweet as csv file : https://gist.github.com/yanofsky/5436496

library(stringr)
library(dplyr)
library(lubridate)

# the function 
# this function reads the file name and path
# and it will return original content tweet by this user

counttweet <- function(filename,path){
# read file
filepath=paste(path,file,sep ="")
data=read.csv(filepath)

# filter to March 2016
data$created_at=mdy_hms(data$created_at)
data %>% filter(month(data$created_at)>=3 & year(data$created_at)==2016)

#make new column
data$status=NA
# assign all the tweets
data$status[is.na(data$reply)]="tweet"
data$status[data$status=="tweet"&str_detect(data$text,"RT @")]="retweet"
data$status[!is.na(data$reply)]="response"
data$status[!is.na(data$reply)&str_detect(data$text,"https://")]="adresponse"

# stats
# tweet vs retweet
tweetnum=sum(data$status=="tweet")
retweetnum=sum(data$status=="retweet")
origcontent=tweetnum/(retweetnum+tweetnum)

# response vs total tweets
adrespose=sum(data$status=="adresponse")
adrate=adrespose/nrow(data)

print(paste("Result for",filename,"; Original Content:",origcontent, "Ad rate:",adrate))
}



# loop through all files
path <- "enter file path"
files <- list.files(path=path, pattern="*.csv")
for(file in files)
{
  counttweet(file,path)
}

