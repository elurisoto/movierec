function [Y,Xf,Af] = myNeuralNetworkFunction(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 30-May-2015 19:27:51.
% 
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timsteps
%   Each X{1,ts} = 3xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 1xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

  % ===== NEURAL NETWORK CONSTANTS =====
  
  % Input 1
  x1_step1_xoffset = [1.7;2.1;1.6];
  x1_step1_gain = [0.285714285714286;0.833333333333333;0.25974025974026];
  x1_step1_ymin = -1;
  
  % Layer 1
  b1 = [3.0975567648983317603;-2.6351499847500532425;-1.758148155551967573;-1.1589187943000380798;0.088153349340024569902;-0.80111000747374150333;1.3242672002174116219;1.7938751660016969414;-2.0809391371338414878;3.1333649881014968841];
  IW1_1 = [-0.70584719592860378778 3.1299642581038553679 -1.459100268209228668;1.2869610570658480686 2.6512915779954226991 -0.41837001155391295715;0.29831233173156712635 -0.34425259612706010648 3.0057113968030684248;1.2495851067640069143 2.6452808308992423747 1.3255126779478123566;2.2447425005072836335 -1.5787735359087577969 2.0979102411138232931;-1.7467562352539891535 2.3301137452674427486 0.46450740707316984235;0.27310293243848532407 1.605754110758864428 2.8687173315894178849;0.64404374695695276731 -0.30328053468401272585 3.0076819562060599367;-0.0074967745217286996251 2.7415682636112537196 -1.4137727931795640579;1.391007894293208258 -0.49369031635925719748 2.3694839374951386368];
  
  % Layer 2
  b2 = 0.28853826756783973462;
  LW2_1 = [0.55585058979204182705 -0.103194177633306447 0.45115372856755192599 -0.047408007363932712364 0.26767622222656095587 0.084458186772185861457 0.043580056512642975641 -0.32860271678055374966 0.85672920517800421614 0.15821569415366612543];
  
  % Output 1
  y1_step1_ymin = -1;
  y1_step1_gain = 0.444444444444444;
  y1_step1_xoffset = 0.5;
  
  % ===== SIMULATION ========
  
  % Format Input Arguments
  isCellX = iscell(X);
  if ~isCellX, X = {X}; end;
  
  % Dimensions
  TS = size(X,2); % timesteps
  if ~isempty(X)
    Q = size(X{1},2); % samples/series
  else
    Q = 0;
  end
  
  % Allocate Outputs
  Y = cell(1,TS);
  
  % Time loop
  for ts=1:TS
  
    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1_gain,y1_step1_xoffset,y1_step1_ymin);
  end
  
  % Final Delay States
  Xf = cell(1,0);
  Af = cell(2,0);
  
  % Format Output Arguments
  if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings_gain,settings_xoffset,settings_ymin)
  y = bsxfun(@minus,x,settings_xoffset);
  y = bsxfun(@times,y,settings_gain);
  y = bsxfun(@plus,y,settings_ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings_gain,settings_xoffset,settings_ymin)
  x = bsxfun(@minus,y,settings_ymin);
  x = bsxfun(@rdivide,x,settings_gain);
  x = bsxfun(@plus,x,settings_xoffset);
end
