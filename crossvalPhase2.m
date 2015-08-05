data    = csvread('data/ml-latest-small/predictions.csv');
target  = data(:,7)';
data    = data(:,1:6)';

%results.phase2 = [];
iteraciones = 25;
folds = 5;
k = 1;
index = crossvalind('Kfold',target,folds);
fprintf('Starting training...\n');

for neurons = 26:35
    fprintf('%i neurons: \t', neurons)
    aux = trainNetworks(data, target, iteraciones, neurons, folds, index, k);
    fprintf('%f\n', aux)
    results.phase2 = [results.phase2 aux];
end

save('data/workspace.mat')