% payoff calculatioin using the results of naive Monte Carlo
% simulation
%
% Input:
% eln: reference of improved himalaya option
% basket: reference of basket evolution (parameters)
% 
% Output:
% payment: payoff for simulated trajectories
% method_std: standard error of the payoffs
% gain: efficiency gain of the method
% method time: time cost

function [payment, method_std, method_time] = naive_coupon_payment(eln, basket)

global eln_cp_method;

bpm = basket.bpm(:,2:end,:);
if eln.cp_method == eln_cp_method.anti % antithetic coupon payment
    if 0 ~= mod(size(bpm,1), 2)
        fprintf('Input error in func_anti_coupon_payment\n\n');
        payment = -1;   return;
    end
end

mask = ones(size(bpm,1), length(basket.S0)); % mask for stock removing
payment = zeros(size(bpm, 1), 1); % basket return

rv_order = zeros(size(mask));

% start timing
tic;

for i = 1 : eln.M
    fprintf('Observation time: %d\n', i);
    % update coupon-pay barrier if needs
    if find(eln.bar_T == i)
        eln.pay_bar = eln_barrier_setting(basket,eln.bar_rate(find(eln.bar_T==i)));
    end
       
    % go through all the mc trajectories (paths)
    for j = 1 : size(bpm, 1)
        % get basket data
        asset_idx = find(mask(j,:)>0);
        if isempty(asset_idx)
            continue;
        end
        bpm_t = bpm(j, i*eln.mc_M_ratio, asset_idx);
        bpm_t = squeeze(bpm_t);
        
        % sum return if satisfied
        [is_pay, perf] = is_coupon(eln.pay_bar, bpm_t, asset_idx,...
            basket, eln.cp_rule);
        if is_pay
            % sum return
            [max_perf, max_idx] = max(perf);
            payment(j) = payment(j) + max(max_perf, 0);
            
            % remove the best
            mask(j, asset_idx(max_idx)) = 0;
            % remove orderly
%              mask(j, i) = 0;
            
            % save order
            rv_order(j,i) = asset_idx(max_idx);
        else
            mask(j, :) = 0;
            payment(j) = 0;
        end
        
        if 0 == mod(j, 1e4)
            fprintf('\tTrajectory %d\n', j);
        end
    end
end

% discount
if eln.cp_method == eln_cp_method.anti % antithetic coupon payment
    N = size(bpm,1) / 2;
    payment2 = zeros(N, 1);
    for i = 1 : N
        payment2(i) = (payment(i) + payment(i+N)) / 2;
    end    
    % discount
    payment = exp(-basket.r*eln.T) .* payment2;    
    fprintf('std of antithetic method:\n');
else
    % discount
    payment = exp(-basket.r*eln.T) .* payment;
    fprintf('std of naive method:\n');
end

% end timing
method_time = toc;

method_std = std(payment)/sqrt(length(payment));
disp(method_std);

