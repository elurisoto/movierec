function MSE = trainNetworks(data, target, iter, neurons, folds, index, k)


% if sum(sum(isnan(data))) > 0
%     aux = fixunknowns(data(size(data,1),:));
%     data(size(data,1),:) = aux(1,:);
%     data = knnimpute(data,k);
% end
% 
% fprintf('knn done\n');

total = 0;
for j=1:iter
    aux=0;
    for i = 1:folds
        t = (index == i);     %x for train data, t for test data
        x = ~t;
        net = feedforwardnet(neurons, 'trainrp');
        net = configure(net,data(:,x),target(:,x));
        net.trainParam.showWindow=0; 
        net = train(net,data(:,x),target(:,x));
        results = net(data(:,t));

        aux = aux + sum((results - target(:,t)).^2)/length(results);
    end
    total = total + aux/folds;
end

MSE = total/iter;

