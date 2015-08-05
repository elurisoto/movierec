warning('off')
fprintf('Loading data...\n')
% ratings         = readtable('data/ml-latest-small/ratings.csv');
% genres          = readtable('data/ml-latest-small/genreMatrix.csv');
% contributors    = readtable('data/ml-latest-small/contributorMatrix.csv');
% synopsis        = readtable('data/ml-latest-small/synopsisMatrix.csv');
% tags            = readtable('data/ml-latest-small/tagsMatrix.csv');
% online          = readtable('data/ml-latest-small/onlineRatings.csv', 'TreatAsEmpty', {'NA'});

ratings = ratings(:,1:3);
userlist = table2array(unique(ratings(:,'userId')));


% target = table2array(ratings(:,'rating'))';

% Data for genres
% datos = join(ratings(:,'movieId'),genres);

% Data for contributors
% datos = join(ratings(:,'movieId'),contributors);

% Data for synopsis
% datos = join(ratings(:,'movieId'),synopsis);

% Data for tags
% datos = join(ratings(:,'movieId'),tags);

% Data for online ratings
% datos = join(ratings(:,'movieId'),online);
% 
% datos = table2array(datos(:,2:size(datos,2)))';



fprintf('Starting to configure neural networks...\n')
total.online.k1.n3 = [];
folds = 5;
iteraciones = 5;
neurons = 3;

genresNeurons = 1;
contributorsNeurons = 1;
synopsisNeurons = 1;
tagsNeurons = 1;
onlineNeurons = 2;

fullPredictions = [];

for u = 1:numel(userlist)
%     u = 106;
%     r = ratings(ratings.userId == userlist(u), 2:3);
%     datos = table2array(join(r(:,'movieId'), online), 'Keys', 'movieId')';
%     target = table2array(r(:,'rating'))';
%     index = crossvalind('Kfold',target,folds);
%     [datos, target, index] = splitData(online, ratings, u, folds);
%     aux = trainNetworks(datos, target, iteraciones, neurons, folds, index, k);
    %% Split the data from the user
    [g, target, i, numRatings] = extractUser(genres, ratings, userlist(u), folds);
    [c, target, i, numRatings] = extractUser(contributors, ratings, userlist(u), folds);
    [s, target, i, numRatings] = extractUser(synopsis, ratings, userlist(u), folds);
    [t, target, i, numRatings] = extractUser(tags, ratings, userlist(u), folds);
    [o, target, i, numRatings] = extractUser(online, ratings, userlist(u), folds);
    
    [target70, target30] = splitData(target,0.7);
    [genres70, genres30] = splitData(g,0.7);
    [contributors70, contributors30] = splitData(c,0.7);
    [synopsis70, synopsis30] = splitData(s,0.7);
    [tags70, tags30] = splitData(t,0.7);   
    [online70, online30] = splitData(o,0.7);
    
    %% Train the neural networks of the first phase
    
    predGenres = trainAndPredict(genres70, target70, genres30, genresNeurons); 
    predContributors = trainAndPredict(contributors70, target70, contributors30, contributorsNeurons); 
    predSynopsis = trainAndPredict(synopsis70, target70, synopsis30, synopsisNeurons); 
    predTags = trainAndPredict(tags70, target70, tags30, tagsNeurons); 
    predOnline = trainAndPredict(online70, target70, online30, onlineNeurons); 
    
    predictions =  [predGenres; predContributors; predSynopsis; predTags; ...
                    predOnline; ones(1,length(predGenres))*numRatings; ...
                    target30];
    
    fullPredictions = [fullPredictions predictions];
    
    %% Store the results
    fprintf('User %i/%i\n', u, length(userlist))
    
end

%% Second phase
save('data/workspace.mat')