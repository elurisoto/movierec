function predictions = trainAndPredict(tra, target, test, neurons)
    k = 1;

    aux = fixunknowns(tra(size(tra,1),:));
    tra(size(tra,1),:) = aux(1,:);
    tra = knnimpute(tra,k);
    
    aux = fixunknowns(test(size(test,1),:));
    test(size(test,1),:) = aux(1,:);
    test = knnimpute(test,k);
    
    
    net = feedforwardnet(neurons, 'trainrp');
    net = configure(net,tra,target);
    net.trainParam.showWindow=0; 
    net = train(net,tra,target);
    predictions = net(test);
    
    