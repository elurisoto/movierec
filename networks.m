warning('off')
fprintf('Loading data...\n')
ratings         = readtable('data/ml-latest-small/biggestUser.csv');
genres          = readtable('data/ml-latest-small/genreMatrix.csv');
contributors    = readtable('data/ml-latest-small/contributorMatrix.csv');
synopsis        = readtable('data/ml-latest-small/synopsisMatrix.csv');

ratings = ratings(:,2:3);

folds = 5;
iteraciones = 75;

fprintf('Starting to configure neural networks...\n')
genresMSE = [];
for neuronas=1:1:15
    target = table2array(ratings(:,'rating'))';
    datos = join(ratings(:,'movieId'),genres);
    datos = table2array(datos(:,2:20))';
    % Funciones
    mse = trainNetworks(datos, target, iteraciones, neuronas, folds)
   
    fprintf('%i neuron(s): \t %f\n', neuronas, mse)
    genresMSE = [genresMSE mse];
end
save('data/workspace.mat')