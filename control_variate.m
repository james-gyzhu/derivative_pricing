% Contral Variate calculation for monte carlo simulation via control
% variate strategy
%
% Input:
% r: risk-free rate
% y: dividend yield
% vol: volatility
% S0: spot price
% T: time to maturity
% cv_idx: type of control variate
%
% Output:
% cv: value of control variate

function cv = control_variate(r, y, vol, S0, T, cv_idx)

global cv_type;

switch cv_idx
    case cv_type.call 
        [call, put] = blsprice(S0, S0, r, T, vol, y);
        cv = call;
    case cv_type.put
        [call, put] = blsprice(S0, S0, r, T, vol, y);
        cv = put;
    otherwise
        fprintf('Input error for control variate type\n\n');
        cv = -1;
        return;
end
