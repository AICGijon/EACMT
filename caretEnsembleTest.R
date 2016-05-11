#caretEnsemble Test
#First install caretEnsemble install.packages("caretEnsemble")

#Load the library
library(caret)
library(caretEnsemble)

#We use the iris dataset
x=iris[,1:4]
y=iris[,5] #class is in the fifth column

#In order to get the same results over executions
set.seed(7)

#Test 1. Simple train, just two different models with a 5-fold cross validation
models_1<-caretList(x,y,methodList=c("svmLinear","rf"),
          trControl=trainControl(method="cv",number=5,savePredictions = "final"))
#We can access the models via models_1[1], models_2[2],...


#Test 2. We can use different tunning params for each model. We can also train more than one
#model of each type. Note that we are training two rf models
models_2<-caretList(x,y,methodList=c("svmLinear","rf"),
                    trControl=trainControl(method="cv",number=5,savePredictions="final"),
                    tuneList=list(
                      svmLinear=caretModelSpec(method="svmLinear", tuneGrid=data.frame(.C=c(1,10))),
                      rf1=caretModelSpec(method="rf", tuneGrid=data.frame(.mtry=c(2,4))),
                      rf2=caretModelSpec(method="rf", tuneGrid=data.frame(.mtry=c(8,10)))
                    ))
#Note: This function should return 3 models but it returns 5 models (2 more using the default
#tunegrid or caret...) With a small modification in the source code of caretList we can avoid the
#training of this two models in order to save time

#Test 3. If our data is composed by samples, we can pass to the function this information
#We  manually make 5 samples, each one with 30 examples (ten per class)
indexList<-c(list(c(1:10,51:60,101:110),c(11:20,61:70,111:120),c(21:30,71:80,121:130),c(31:40,81:90,131:140),c(41:50,91:100,141:150)))
models_3<-caretList(x,y,methodList=c("svmLinear","rf"),
                    trControl=trainControl(method="cv",number=5,savePredictions=TRUE,
                                           indexOut=indexList))
#Printing models_3[1]$svmLinear$pred we can see how samples were used to make the CV (test with
#one sample and train with the rest of the data). 

#The problem that I see is that we can't train models with different data, because trControl is
#the same for all the models and we can only pass one trControl. tuneList is different for
#each model but we can't pass there the index list. Eventhough, we a small modification in the
#source code we can pass different sample indexes to each model.

