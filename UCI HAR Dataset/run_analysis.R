#read test data into table
x_test<-read.table('test/X_test.txt')
y_test<-read.table('test/y_test.txt')
subject_test<-read.table('test/subject_test.txt')

#read train data into table
x_train<-read.table('train/X_train.txt')
y_train<-read.table('train/y_train.txt')
subject_train<-read.table('train/subject_train.txt')

#vector for holding the id values
train_id<-c()
test_id<-c()
features<-c()

#get number of rows in x_train data
num_rows<-nrow(x_train)

#renaming the column names for x_train and x_test data
features<-read.table("features.txt")
n_features<-nrow(features)
for (i in 1:n_features){
	names(x_train)[i] = as.character(features[[2]][i])
	names(x_test)[i] = as.character(features[[2]][i])
}

#rename column name for y_train, y_test, subject_test and subject_train data
names(y_train)[1]<-"Activity Type"
names(subject_train)[1] <- c("Subject Train")

names(y_test)[1]<-"Activity Type"
names(subject_test)[1]<- c("Subject Test")

#get ids to merge data and  map activity type based on numeric values listed in data
for(i in 1:num_rows){
	train_id<-c(train_id, as.numeric(i))

	category_train<- as.numeric(y_train[[1]][i])
	category_test<-as.numeric(y_test[[1]][i])

	if(category_train == 1){
		y_train[[1]][i] <- "WALKING"
	}
	if(category_train == 2){
		y_train[[1]][i] <- "WALKING_UPSTAIRS"
	}
	if(category_train == 3){
		y_train[[1]][i] <- "WALKING_DOWNSTAIRS"
	}
	if(category_train == 4){
		y_train[[1]][i] <- "SITTING"
	}
	if(category_train == 5){
		y_train[[1]][i] <-"STANDING"
	}
	if(category_train == 6){
		y_train[[1]][i] <-"LAYING"
	}

	if (i < 2948){
		test_id<-c(test_id, as.numeric(i))
		if(category_test == 1){
		y_test[[1]][i] <- "WALKING"
		}
		if(category_test == 2){
			y_test[[1]][i] <- "WALKING_UPSTAIRS"
		}
		if(category_test == 3){
			y_test[[1]][i] <- "WALKING_DOWNSTAIRS"
		}
		if(category_test == 4){
			y_test[[1]][i] <- "SITTING"
		}
		if(category_test == 5){
			y_test[[1]][i] <-"STANDING"
		}
		if(category_test == 6){
			y_test[[1]][i] <-"LAYING"
		}
	}
	
}	

# #bind ids with train data
x_train_data<-cbind(train_id, x_train)
y_train_data <- cbind(train_id, y_train)
subject_train_data<-cbind(train_id, subject_train)

#perform a 2 step merge for all training datasets
merge_x_y_train<-merge(x_train_data, y_train_data, by.x="train_id", by.y="train_id")
merge_all_train<-merge(merge_x_y_train, subject_train_data, by.x="train_id", by.y="train_id")

#bind ids to test data
x_test_data<-cbind(test_id, x_test)
y_test_data <- cbind(test_id, y_test)
subject_test_data<-cbind(test_id, subject_test)

#perform a merge with only x_train and x_test values while excluding other data
merge_only_train_w_test_num_values<-merge(x_train_data, x_test_data, by.x = "train_id", by.y = "test_id")

#Find mean of each row the x_train and x_test while excluding NA values for which results are written to a file called mean.txt
mean<-rowMeans(merge_only_train_w_test_num_values, na.rm = TRUE)
mean_df<-data.frame(mean)
mean_data<-cbind(test_id, mean_df)
# write.table(mean, 'mean.txt', row.names=FALSE)

#Find standard deviation of each row the x_train and x_test while excluding NA values for which results are written to a file called standard_deviation.txt
standard_deviation<-apply(merge_only_train_w_test_num_values,1, sd)
sd_data<-data.frame(standard_deviation)
sd_data<-cbind(test_id, sd_data)

df_list <- list(mean_data, sd_data, subject_train_data, y_test_data, subject_test_data, y_train_data, x_test_data)
tidy<-join_all(df_list)
write.table(tidy, "tidyData.txt")


# #A 2 step merge of all the test data
# merge_x_y_test<-merge(x_test_data, y_test_data, by.x="test_id", by.y="test_id")
# merge_all_test<-merge(merge_x_y_test, subject_test_data, by.x="test_id", by.y="test_id")

# #Merge all the test data with all the training data and write the merged result to a file called tidy_dataset.txt
# merge_test_with_train<-merge(merge_all_train, merge_all_test, by.x="train_id", by.y="test_id", all=TRUE)
# write.table(merge_test_with_train, 'tidy_dataset.txt', row.names=FALSE)


