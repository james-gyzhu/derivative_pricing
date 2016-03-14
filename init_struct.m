% initialize the global strucutres of option(eln), basket stocks(basket),
% and monte carlo simulation(mc)

function [eln, basket, mc] = init_struct(setting_file)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load gobal setting
eval(setting_file);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test rule
% mc.type          eln.cp_method
%  quasi ------------- naive
%  quasi_bb ---------- naive
%
%      |-------------- naive
%  naive ------------- cv
%      |-------------- anti
%
%  strat ------------- naive
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reference setting
eln = struct(...    % reference for eln
    'face',         eln_face,...            % face value
    'cp_rate',      eln_coupon,...          % coupon rate
    'T',            eln_T,...               % time to maturity, e.g. 5 years
    'obs_freq',     eln_obs_freq,...        % observatin frequence
    'M',            eln_M,...               % observation time-steps
    'mc_M_ratio',   eln_mc_M_ratio,...      % = mc_M/eln_M
    'cp_method',    eln_cp_method.naive,...    % method for coupon payment (naive/cv/anti)
    'cp_rule',      eln_cp_rule.whole,...   % copoun payment rule
    'pay_bar',      eln_pay_bar,...         % coupon-pay barrier
    'bar_rate',     eln_bar_rate,...        % barrier rate against S(basket,0)
    'bar_T',        eln_bar_T,...           % barrier-changing times
    'cp_paid',      -1,...                  % cumulative coupon paid
    'method_std',   -1,...                  % std of base payment method
    'method_gain',  -1,...                  % efficience gain of used payment mehtod
    'method_time',   -1);                    % time cost of the eln method

basket = struct(...  % reference for basket
    'r',    bkt_r,...   % risk-free rate
    'y',    bkt_y,...   % dividend yield
    'vol',  bkt_vol,... % volatility
    'cor',  bkt_cor,... % correlation
    'S0',   bkt_S0,...  % spot price
    'bpm',  0);

mc = struct(...  % reference for monte carlo simulation
    'type',  mc_type.quasi_bb,...   % mc methods
    'N',     mc_N,...            % mc cycle number
    'M',     mc_M,...            % mc time-step number
    'base_mc_t', -1,...          % based mc time-consuming
    'used_mc_t', -1);            % on-using mc time-comuming, e.g. cv

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pre-process if needs
if eln.cp_method == eln_cp_method.anti
    mc.type = mc_type.anti;
end

