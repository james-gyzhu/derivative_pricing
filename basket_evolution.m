% basket evolution/pricing, evaluate via monte carlo simulation
%
% Input:
% eln: reference of improved himalaya option
% basket: reference of basket evolution (parameters)
% mc: reference of mc simulation (parameters)
% 
% Output:
% bpm: basket performance (matrix of simulation pathes/trajectories)
% time: simulation time cost

function [bpm, time] = basket_evolution(eln, basket, mc)

global mc_type;

% mc simulation
switch mc.type 
    case mc_type.naive
        fprintf('MC simulation: naive version\n');
        % function simu_path = naive_mc(r, y, vol, cor, S0, T, N, M)
        [bpm, time] = naive_mc(...
            basket.r,...
            basket.y,...
            basket.vol,...
            basket.cor,...
            basket.S0,...
            eln.T,...
            mc.N,...
            mc.M);
    case mc_type.quasi
        fprintf('MC simulation: quasi version\n');
        % function simu_path = quasi_mc(r, y, vol, cor, S0, T, N, M)
        [bpm, time] = quasi_mc(...
            basket.r,...
            basket.y,...
            basket.vol,...
            basket.cor,...
            basket.S0,...
            eln.T,...
            mc.N,...
            mc.M); 
    case mc_type.quasi_bb
        fprintf('MC simulation: quasi with brownian bridge version\n');
        % function simu_path = quasi_mc_bb(r, y, vol, cor, S0, T, N, M)
        [bpm, time] = quasi_mc_bb(...
            basket.r,...
            basket.y,...
            basket.vol,...
            basket.cor,...
            basket.S0,...
            eln.T,...
            mc.N,...
            mc.M); 
    case mc_type.anti
        fprintf('MC simulation: antithetic version\n');
        % function simu_path = anti_mc(r, y, vol, cor, S0, T, N, M)
        [bpm, time] = anti_mc(...
            basket.r,...
            basket.y,...
            basket.vol,...
            basket.cor,...
            basket.S0,...
            eln.T,...
            mc.N,...
            mc.M); 
    case mc_type.strat
        fprintf('MC simulation: stratification version\n');
        % function simu_path = strat_mc(r, y, vol, cor, S0, T, N, M)
        [bpm, time] = strat_mc(...
            basket.r,...
            basket.y,...
            basket.vol,...
            basket.cor,...
            basket.S0,...
            eln.T,...
            mc.N,...
            mc.M); 
    case mc_type.latin
        fprintf('MC simulation: latinhypercube version\n');
        [bpm, time] = latinhypercube_mc(...
            basket.r,...
            basket.y,...
            basket.vol,...
            basket.cor,...
            basket.S0,...
            eln.T,...
            mc.N,...
            mc.M);
    otherwise
        fprintf('Input error for MC type\n\n');
        bpm = -1;
        return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for test
% mean_val = zeros(size(bpm,3), size(bpm,2));
% for i = 1 : size(bpm,3)
%     mean_val(i,:) = mean(bpm(:,:,i),1);
% end
% disp(mean_val);
% kk = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    