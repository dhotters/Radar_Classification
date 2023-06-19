function [svm_model] = classifier(training_data, validation_data)
% The code to train the SVM goes here

svm_model = fitcecoc(Tbl,ResponseVarName);
end

