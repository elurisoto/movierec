warning('off')
fprintf('Loading data...\n')
ratings         = readtable('data/ml-latest-small/ratings.csv');
genres          = readtable('data/ml-latest-small/genreMatrix.csv');
contributors    = readtable('data/ml-latest-small/contributorMatrix.csv');
synopsis        = readtable('data/ml-latest-small/synopsisMatrix.csv');
tags            = readtable('data/ml-latest-small/tagsMatrix.csv');
online          = readtable('data/ml-latest-small/onlineRatings.csv', 'TreatAsEmpty', {'NA'});


ratings = ratings(1:10000,1:3);
userlist = table2array(unique(ratings(:,'userId')));

% target = table2array(ratings(:,'rating'))';

% Data for genres
% datos = join(ratings(:,'movieId'),contributors);

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

results.online = [];
iteraciones = 1;
k = 1;

for neurons = 1:15
    total = 0;
    for u = 1:numel(userlist)
        r = ratings(ratings.userId == userlist(u), 2:3);
        [datos, target, index] = extractUser(online, ratings, u, folds);
        aux = trainNetworks(datos, target, iteraciones, neurons, folds, index, k);
        fprintf('[%i] User %i: \t %f\n',neurons, u, aux)
        total = total + aux;
    end
    results.online = [results.online total/length(userlist)];
end

save('data/workspace.mat')