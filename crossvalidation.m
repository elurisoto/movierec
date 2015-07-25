% data must be in column format, not vector format
folds = 5;
iteraciones = 150;
indices = crossvalind('Kfold',target,folds);
% carpeta = 'data/clusters/';
% 
% for file=16:1:25
%     ruta = strcat(carpeta, num2str(file));
%     ruta = strcat(ruta, '.csv')
%     col = csvread(ruta,1,0);
%     
%     datos = [normalizados col]';
vector = [];
    for neuronasi=1:1:1
        for neuronasj=1:1:1
            total = 0;
            for j=1:iteraciones
                aux=0;
                for i = 1:folds
                    t = (indices == i);     %x for train data, t for test data
                    x = ~t;

                    net = feedforwardnet([1 3]);
                    net = configure(net,datos(:,x),target(:,x));
                    net.trainParam.showWindow=0; 
                    net = train(net,datos(:,x),target(:,x));
                    results = net(datos(:,t));
        %             tree = TreeBagger(neuronas,normalized(x,:),target(x,:), 'method', 'regression');
        %             results = predict(tree, normalized(t,:));
                    aux = aux + sum((results - target(:,t)).^2)/length(results);
                end
                total = total + aux/folds;
            end
            total
        end
    end
%     vector(1:5)
%     Clusters = [Clusters ; vector];
% end
save('data/workspace.mat')