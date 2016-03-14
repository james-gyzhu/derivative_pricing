%%%%% Global configuration file %%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting for option
eln_face = 1;                 % face value of of eln
eln_coupon = 0.1;               % coupon rate
eln_T = 4;                      % time to maturity, e.g. 3 years
eln_obs_freq = 1;               % observation frequence
eln_M = eln_T*eln_obs_freq;     % eln obervation steps
eln_mc_M_ratio = 1;             % = mc_M/eln_M
eln_pay_bar = 0;                % coupon-pay barrier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test variable
% !!!dim(eln_bar_rate) = dim(eln_bar_T)
eln_bar_rate = [0; 0];      % barrier rate against S(basket, 0)
eln_bar_T = [1; 2];         % barrier-changing times
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global eln_cp_method;   
eln_cp_method.naive = 1;    % naive method to calculate coupon payment
eln_cp_method.cv = 2;       % control variate method for calculate
eln_cp_method.anti = 3;     % antithetic variate method for calculate

global eln_cp_rule;
eln_cp_rule.min = 1;            % min > pay_bar
eln_cp_rule.max = 2;            % max > pay_bar
eln_cp_rule.whole = 3;          % all performance higher
eln_cp_rule.avg_rv_minmax = 4;  % average values excluding min & max > pay_bar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting for basket evolution
% test variable
% !!!dim(bkt_y) = dim(bkt_vol) = dim(bkt_S0)
bkt_r = 0.05;                       % risk-free rate
bkt_y = [0; 0; 0; 0];               % dividend yield
bkt_vol = 0.2*ones(4,1);            % volatility: 0.2
bkt_cor = 0.4*(ones(4,4)-eye(4,4))+eye(4,4);   % correlation matrix: 0.6
% bkt_vol = [0.2; 0.2; 0.2; 0.2];     % volatility: 0.2
% bkt_cor = [ 1.0, 0.6, 0.6, 0.6;...  % 0.6
%             0.6, 1.0, 0.6, 0.6;...
%             0.6, 0.6, 1.0, 0.6;...
%             0.6, 0.6, 0.6, 1.0 ];   % correlation matrix
bkt_S0 = [100; 100; 100; 100];      % spot price

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting for monte carlo simulation
mc_N = 1e4;                     % number of mc cycles
mc_M = eln_M*eln_mc_M_ratio;    % time steps in mc simulation

global mc_type;
mc_type.naive = 1;      % naive mc
mc_type.quasi = 2;      % quasi mc
mc_type.anti = 3;       % antithetic mc
mc_type.strat = 4;      % stratified mc
mc_type.latin = 5;      % latinhypercube mc
mc_type.quasi_bb = 6;   % quasi mc with brownian bridge

global cv_type;     % control variate
cv_type.call = 1;   % european call
cv_type.put = 2;    % european put

