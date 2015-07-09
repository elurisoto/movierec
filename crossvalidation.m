% data must be in column format, not vector format
folds = 5;
iteraciones = 75;
indices = crossvalind('Kfold',target,folds);
MSE.normalidados8 = [];
for neuronas=1:1:15
    total = 0;
    for j=1:iteraciones
        aux=0;
        for i = 1:folds
            t = (indices == i);     %x for train data, t for test data
            x = ~t;
            
            net = feedforwardnet(neuronas);
            net = configure(net,normalizados(:,x),target(:,x));
            net.trainParam.showWindow=0; 
            net = train(net,normalizados(:,x),target(:,x));
            results = net(normalizados(:,t));
%             tree = TreeBagger(neuronas,normalized(x,:),target(x,:), 'method', 'regression');
%             results = predict(tree, normalized(t,:));
            aux = aux + sum((results - target(:,t)).^2)/length(results);
        end
        total = total + aux/folds;
    end

    MSE.normalidados8 = [MSE.normalidados8 total/iteraciones]
end

MSE