% payoff calculation for control variat (a portfolio of multiple bonds)
% 
% Input:
% bar_vec: vector of barriers during the contract period
% bpm: simulated basket pricing trajectories/pathes
% S0: spot prices of basket
% r: risk-free rate
% cv_T: time to maturity of each bond in the portfolio
% 
% Output:
% cv_mc_payoff: payoff of the control variate

function cv_mc_payoff = cv_mc_discount_payoff(bar_vec, bpm, S0, r, cv_T)

num_asset = length(S0);
cv_mc_payoff = zeros(size(bpm,1), 1);

for i = 1 : num_asset
    % compare with payment barrier
    cv_mc_path = bpm(:, cv_T(i)+1, i);
    rtn = cv_mc_path/S0(i) - 1;
    cv_pay_mask = double(im2bw(rtn+1, bar_vec(i)));
    
    % payoff calculation
    cv_mc_payoff(:) = cv_mc_payoff(:) + ...
        exp(-r*cv_T(i)).*max(rtn,0).*cv_pay_mask;
end