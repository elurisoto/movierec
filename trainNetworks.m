function MSE = trainNetworks(data, target, iter, neurons, folds)

index = crossvalind('Kfold',target,folds);

total = 0;
for j=1:iter
    aux=0;
    for i = 1:folds
        t = (index == i);     %x for train data, t for test data
        x = ~t;

        net = feedforwardnet(neurons);
        net = configure(net,data(:,x),target(:,x));
        net.trainParam.showWindow=0; 
        net = train(net,data(:,x),target(:,x));
        results = net(data(:,t));

        aux = aux + sum((results - target(:,t)).^2)/length(results);
    end
    total = total + aux/folds;
end

total

