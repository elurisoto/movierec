format bank;
data = importData('data/outputAlexPreprocessed.csv');
target = data(:,30):

%target = importTarget('data/outputAlexPreprocessed.csv');

%Extraemos las variables que vamos a usar por ahora, la puntuación de imdb,
%la de filmaffinity y la de los usuarios de rotten tomatoes
data = data(:,[1,18,27]);

results = myNeuralNetworkFunction(data');
MSE = sum((results - target').^2)/length(results);
errormedio = sum(abs(results-target'))/length(results)
