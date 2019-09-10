install.packages('dplyr')
install.packages('data.table')
install.packages("highcharter")
install.packages('h2o')
install.packages('tidyquant')
library(dplyr)
library(data.table)
library(highcharter)
library(h2o)
library(tidyquant)
setwd('/home/nihad/Desktop/Kaggle/R')


train_df = fread('train.csv')  %>% mutate_if(is.character, as.factor) %>% mutate_if(is.integer,as.factor) %>% mutate_if(is.numeric,as.factor)
test_df = fread('test.csv')
str(train_df)
test_df[,'Survived'] = NA
test_df = test_df %>% mutate_if(is.character, as.factor) %>% mutate_if(is.integer,as.factor) %>% mutate_if(is.numeric,as.factor)
train_df[is.na(train_df)] = " "
test_df[is.na(test_df)] = " "
train_df = subset(train_df, select = -c(Name))
test_df = subset(test_df,select = -c(Name))

h2o.init()


h2o_train_data = as.h2o(train_df)
h2o_test_data = as.h2o(test_df)

train_df$Sex %>% unique()
train = h2o_train_data
test =h2o_test_data


 
 Survived = 'Survived'

aml<-h2o.automl(y=Survived,
                training_frame = train,
                leaderboard_frame = test,seed=3,
                max_runtime_secs = 120)
 

aml@leader
aml@leaderboard %>% as_tibble() %>% head(.,20)
 cor(train_df$Survived,use=train_df$Sex, method="kendall")
