% payoff calculatioin using the results of Contral Variate Monte Carlo
% simulation
%
% Input:
% eln: reference of improved himalaya option
% basket: reference of basket evolution (parameters)
% mc: reference of mc simulation (parameters)
% beta: beta for control variate tranformation
% 
% Output:
% simu_path: payoff for simulated trajectories
% method_std: standard error of the payoffs
% gain: efficiency gain of the method
% method time: time cost

function [simu_path, method_std, gain, method_time] = cv_coupon_payment(eln, basket, mc, beta)

global cv_type; % control variate

% parameter definition
r = basket.r;       y = basket.y;
vol = basket.vol;   S0 = basket.S0;

num_asset = length(S0);
T = 1 : num_asset;

% start timing
tic;

% product payoff calculation
pt_payoff = naive_coupon_payment(eln, basket);
pt_time = toc;

% control variate via analystic solution
cv = zeros(num_asset, 1);
for i = 1 : num_asset
    cv(i) = control_variate(r,y(i),vol(i),S0(i),T(i),cv_type.call)./S0(i);
end

% control variate payoff calculation
bar_vec = zeros(mc.M, 1);
for i = 1 : length(eln.bar_T)-1
    bar_vec(eln.bar_T(i):eln.bar_T(i+1)-1) = eln.bar_rate(i);
end
bar_vec(length(eln.bar_T):mc.M) = eln.bar_rate(end);

cv_payoff = cv_mc_discount_payoff(bar_vec, basket.bpm, S0, basket.r, T);

% control variate transformation
simu_path = pt_payoff + beta.value.*(sum(cv) - cv_payoff);

% end timing
cv_time = toc;
method_time = cv_time;

% calculate efficiency gain & standard error
rho = corrcoef(pt_payoff, cv_payoff);   rho = rho(1,2);
total_time = mc.base_mc_t + beta.time + cv_time;
gain = (total_time / (mc.base_mc_t+pt_time)) * (1 - rho^2);
gain = 1./gain;
fprintf('efficiency gain:\n')
disp(gain);

% inform output
fprintf('std of naive method:\n');
base_std = std(pt_payoff)/sqrt(length(pt_payoff));
disp(base_std);
fprintf('std of cv method:\n');
method_std = std(pt_payoff)*sqrt(1-rho^2)/sqrt(length(pt_payoff));
disp(method_std);

