% identify if pay the payoff for eln
%
% pay_bar: barrier for payoff
% pfm: performance of basket
% idx: identification rule 

function [is_pay, perf] = is_coupon(pay_bar, pfm, pfm_idx, basket, rule_idx)

global eln_cp_rule;

switch rule_idx
%     case eln_cp_rule.min
%         fprintf('Coupon pay-rule: min rule\n');
%         min_pfm = min(pfm, [], 2);
%         is_pay = int8(im2bw(min_pfm-pay_bar, 0));
%     case eln_cp_rule.max
%         fprintf('Coupon pay-rule: max rule\n');
%         max_pfm = max(pfm, [], 2);
%         is_pay = int8(im2bw(max_pfm-pay_bar, 0));
%     case eln_cp_rule.avg_rv_minmax
%         fprintf('Coupon pay-rule: average excluding min & max\n');
%         rv_minmax = sum(pfm,2) - min(pfm,[],2) - max(pfm,[],2);
%         rv_minmax = rv_minmax./(size(pfm,2)-2);
%         is_pay = int8(im2bw(rv_minmax-pay_bar, 0));
    case eln_cp_rule.whole
        perf = pfm./basket.S0(pfm_idx) - 1; % return Si/S0-1
        whole_pfm = im2bw(perf+1, pay_bar);
        is_pay = int8(prod(double(whole_pfm), 1));
    otherwise
        fprintf('Input error for cupoun payment rule\n\n');
        is_pay = -1;
        return;
end

