% Nicolas Tedori
% EECE 5644
% December 4, 2019
% Final Project

%% start timing
timeStart = cputime;

% surpress warnings
warning('off','all');
warning
%{
    Only warning is stating that not all data might be included in a fold.
    This is because there are some classes which have a significantly small
    number of members.

    Therefore, the warning(s) were hidden to clear up the console. If
    warnings should be displayed, set 'off' to 'on' or comment out the
    line.
%}

%% import excel data
% if the data exists in the workspace, dont bother importing it
if ~exist('rawdata')
    fprintf(">Loading Excel data...\n")
    
    % load in the excel data
    rawdata = readtable('data/dl-dashboard-ay2018-2019-q4.xls', ...
        'Sheet', 'Award Year Summary', 'Range', 'A6:AD5168');
    
    fprintf(">Data loaded.\n")
    
    % set the "state" for a college outside the US to "FC" (FC = foreign
    % country)
    obs = size(rawdata, 1);
    for val = 1:obs
        if strlength(rawdata{val,3}) == 0
            rawdata{val,3} = {'FC'};
        end
    end
end
%{
    What's going on here??
    
    From the excel document, I take the second sheet. This sheet
    contains loan disbursement information based on loan type and school,
    with information about the shools.
    
    This information is given as the school's name, location (state and
    ZIP+4 code), and institution type (non-profit private, public, 
    proprietary, or foreign).

    Note: schools outside of the US don't use normal zipcodes
    Note 2: schools might be too sparsely distributed for zipcode to be a
    strong enough indicator -- perhaps based on state alone might work
%}

% partition data for training and testing
nRows   = size(rawdata, 1);        % the number of observations
order   = randperm(nRows);      % the new order of the data
data    = rawdata(order, :);       % shuffle the rows
dataTrain = rawdata(1:ceil(0.7 * nRows),:);
dataTest = rawdata(ceil(0.7 * nRows)+1:end,:);

% rawdata.State = categorical(rawdata.State);
% pt = cvpartition(rawdata.State, 'HoldOut', 0.3);
% reldata = rawdata{:,6:end};
% dataTrain = reldata(training(pt),:);
% dataTest  = reldata(test(pt), :);
    
%% alter data for training and testing:
% data is altered by combining all recipents from all categories and
% totalling the amount of loan disbursements
% note: might get better result by not combining
adata = rawdata{:,1:5};     % get school info
asize = size(adata,1);      % number of observations

% get number of recipients
tempmat   = zeros(asize,5,3);
totals    = zeros(asize,3);
for lt = 1:5 % 5 is the number of loan categories
    reldata   = rawdata{:,6:end};   % exclude the school information
    col = (lt * 5) - 4;             % calculate the column we want
    tempmat(:,lt,1) = reldata(:,col);
    tempmat(:,lt,2) = reldata(:,col + 3);
    tempmat(:,lt,3) = reldata(:,col + 4);
end
for val = 1:3
    totals(:,val) = sum(tempmat(:,:,val),2);
end
%{
    An important note about this data:
    I'm not entirely sure how the data is partitioned: i.e. a student can 
    be included in more than 1 loan category. This processed data assumes a
    student can only belong to one category.
%}

dataCats = categorical(rawdata.SchoolType);

% assign numeric values based on state (for my own sanity)
lbls = zeros(obs,1);
for i = 1:length(categories(dataCats))
    cat = categories(dataCats);
    cat = cat(i);
    cf = (dataCats == cat);
    lbls(cf) = i;
end

dataTrain = rawdata(1:ceil(0.7 * nRows),6:end);%totals(1:ceil(0.7 * nRows),:);
labelTrain = lbls(1:ceil(0.7 * nRows));%rawdata(1:ceil(0.7 * nRows),3);

dataTest = rawdata(ceil(0.7 * nRows)+1:end,6:end);%totals(ceil(0.7 * nRows)+1:end,:);
labelTest = lbls(ceil(0.7 * nRows)+1:end);%rawdata(ceil(0.7 * nRows)+1:end,3);

%% get response variable as zipcode
% respvar = rawdata{:,4};     % make the zipcode the response variable
% respvar = regexprep(respvar, '\s','');  % remove white space from zipcodes
% 
% % negligbly slow, so lets use it bc it simplifies things for us
% for val = 1:obs
%     if strlength(respvar{val}) < 9
%         respvar{val} = '000000000';
%     end
% end
% 
% f3char  = @(x) x(1:3);
% % get the first 3 digits from ZIP+4 - this number is known as the zip code
% % zone, which is used to identify regions in a state.
% % for more information: https://en.wikipedia.org/wiki/ZIP_Code
% respvar = cellfun(f3char, respvar, 'UniformOutput', false);
% respvar = cellfun(@str2num, respvar, 'UniformOutput', false);
% respvar = cell2mat(respvar);    % convert the zones to a matrix

%% get response variable as state
% respvar = rawdata{:,3};     % get the state for a college
% 
% % set the "state" for a college outside the US to "FC" (FC = foreign
% % country)
% for val = 1:obs
%     if strlength(respvar{val}) == 0
%         respvar{val} = 'FC';
%     end
% end

%% run tree classifier training
fprintf('>Training ensembles...\n')
noCVStart = cputime;            % get the start time of the first ensemble

t = templateTree('Reproducible',true);

% train an ensemble of bagged trees without corss validation
mdl   = fitcensemble(dataTrain, labelTrain, 'Method', 'Bag', ...
    'NumLearningCycles',200,'Learners',t);

noCVTime = cputime - noCVStart; % get the amount of time it takes to train an ensemble w/o cv
cvStart  = cputime;             % get the start time for the next ensemble

% train an ensemble of bagged trees with cross-validation
mdlCV = fitcensemble(dataTrain, labelTrain, 'Method', 'Bag', ...
    'NumLearningCycles',200, 'KFold', 10,'Learners',t);

cvEnd = cputime - cvStart;      % get the amount of time it takes to train an ensemble w/ cv

fprintf("Bagged tree training time: %.2f seconds\nCV bagged tree training time: %.2f seconds\n",...
    noCVTime, cvEnd)
fprintf('>Ensembles training completed.\n')

% view classification error
fprintf('>Plotting error...\n')
plot(loss(mdl,dataTest, labelTest, 'mode','cumulative'),'b-')
hold on
plot(kfoldLoss(mdlCV,'mode','cumulative'),'r.')
xlabel('Number of trees')
ylabel('Test classification error')
legend('Test','Cross-validation','Location','NE')
title(["Matlab's Bagged trees", "with and without crossvalidation"])
hold off
fprintf('>Error plotted.\n')

%% display run time
timeEnd = cputime - timeStart;
fprintf("Total runtime: %.2f seconds\n", timeEnd)