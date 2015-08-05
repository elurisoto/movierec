function    [data70, data30] = splitData(data, pctg)
    split = round(size(data,2)*pctg);    
    data70 = data(:,1:split);
    data30 = data(:,split+1:end);

    