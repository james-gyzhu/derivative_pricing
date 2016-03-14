% Beta calculation for Control Variate Monte Carlo Simulation
%
% Input:
% sys_eln: reference of improved himalaya option
% sys_basket: reference of basket evolution (parameters)
% sys_mc: reference of mc simulation (parameters)
%
% Output:
% beta: beta for control variate transfermation

function [beta] = cv_mc_beta(sys_eln, sys_basket, sys_mc)

eln = sys_eln;  basket = sys_basket;    mc = sys_mc;

num_asset = length(basket.vol);
cv_T = 1 : num_asset;
mc.N = 1e3;

% start timing
tic;

% product payoff calculation
[basket.bpm, mc.base_mc_t] = basket_evolution(eln, basket, mc);
pt_mc_payoff = naive_coupon_payment(eln, basket);

% control variate payoff calculation
bar_vec = zeros(mc.M, 1);
for i = 1 : length(eln.bar_T)-1
    bar_vec(eln.bar_T(i):eln.bar_T(i+1)-1) = eln.bar_rate(i);
end
bar_vec(length(eln.bar_T):mc.M) = eln.bar_rate(end);

cv_mc_payoff = cv_mc_discount_payoff(bar_vec, basket.bpm, basket.S0, basket.r, cv_T);

% beta calculation
rho = corrcoef(pt_mc_payoff, cv_mc_payoff);
rho = rho(1,2);
std_pt = std(pt_mc_payoff);
std_cv = std(cv_mc_payoff);
beta.value = (rho*std_pt)/(std_cv);

% end timing
beta.time = toc;

