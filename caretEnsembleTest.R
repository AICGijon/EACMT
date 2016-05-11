#caretEnsemble Test

#Load the library
library(caretEnsemble)

#We use the iris dataset
x=iris[,1:4]
y=iris[,5]

#Ensure same results over executions
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
                      rf=caretModelSpec(method="rf", tuneGrid=data.frame(.mtry=c(2,4))),
                      rf2=caretModelSpec(method="rf", tuneGrid=data.frame(.mtry=c(8,10)))
                    ))
#Note: This function should return 3 models but it returns 5 models (2 more with the default
#tunegrid...)

#Test 3. If our data is composed by samples, we can pass to the function this information
indexList<-c(list())
models_3<-caretList(x,y,methodList=c("svmLinear","rf"),
                    trControl=trainControl(method="cv",number=3,savePredictions="final",
                                           index=indexList))
                    


