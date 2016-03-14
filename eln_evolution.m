% eln evolution upon barrier
% basket evolution/pricing, evaluate via monte carlo simulation
%
% Input:
% eln: reference of improved himalaya option
% basket: reference of basket evolution (parameters)
% mc: reference of mc simulation (parameters)
% 
% Output:
% cp_paid: cumulative payoff
% method_std: standard error of the payoffs
% gain: efficiency gain of the method
% method time: time cost

function [cp_paid, method_std, gain, method_time] = eln_evolution(eln, basket, mc)

global eln_cp_method;

cp_paid = -1;
method_std = -1;
gain = -1;

switch eln.cp_method
    case eln_cp_method.naive
        fprintf('Copuon payment: naive version\n');
        [bpm_rtn, method_std, method_time] = naive_coupon_payment(eln, basket);
    case eln_cp_method.cv
        fprintf('Coupon payment: control variate version\n');
        beta = cv_mc_beta(eln, basket, mc);
        [bpm_rtn, method_std, gain, method_time] =...
            cv_coupon_payment(eln, basket, mc, beta);
    case eln_cp_method.anti
        fprintf('Coupon payment: antithetic variate version\n');
        [bpm_rtn, method_std, method_time] = naive_coupon_payment(eln, basket);
    otherwise
        fprintf('Input error in func_eln_evolution\n\n');
        cp_paid = -1;
        return;
end

% for part 1
cp_paid = eln.face * mean(bpm_rtn);


