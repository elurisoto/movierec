function [data, target, index, numRatings] = splitData(data, ratings, userId, folds)

    r = ratings(ratings.userId == userId, 2:3);
    data = table2array(join(r(:,'movieId'), data), 'Keys', 'movieId')';
    target = table2array(r(:,'rating'))';
    index = crossvalind('Kfold',target,folds);
    numRatings = sum(ratings.userId == userId);

    