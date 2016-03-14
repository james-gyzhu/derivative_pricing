% Monte Carlo via stratification and brownian bridge
%
% INPUT:
% r: risk-free rate
% y: dividend yield
% vol: volatility
% cor: correlation matrix
% S0: spot price
% T: time to maturity
% N: number of mc cycles
% M: time steps in mc simulation
%
% OUTPUT
% simu_path: simulation path matrix
% time: simulation time cost

function [simu_path, time] = strat_mc(r, y, vol, cor, S0, T, N, M)

if length(vol) ~= size(cor,1) ||...
        size(cor,1) ~= size(cor,2) ||...
        length(y) ~= length(vol)
    fprintf('Input error in func_quai_mc\n\n');
    return;
end
num_asset = length(vol);

% start timing
tic;

% parameter definition for stratification
rn = rand(N,num_asset);
permN = [];
for i=1:num_asset
    permN = [permN, randperm(N)'];
end
rn = norminv((permN-rn)/N, 0, 1);

% independant brownian bridge
W = brownian_bridge(N, M, T, num_asset, rn);

% generate correlated brownian bridges
[V, D] = eig(cor);
D = repmat(diag(D, 0)', size(V,1), 1);
A = (D.^0.5) .* V;
cor_W = zeros(size(W));
for i = 1 : M+1
    cor_W(:,(i-1)*num_asset+1:i*num_asset) = ...
        (A * W(:,(i-1)*num_asset+1:i*num_asset)')';
end

% dW
dW = zeros(size(cor_W,1), size(cor_W,2)-num_asset);
for i = 1 : M
    dW(:,(i-1)*num_asset+1:i*num_asset) = ...
        cor_W(:,i*num_asset+1:(i+1)*num_asset) -...
        cor_W(:,(i-1)*num_asset+1:i*num_asset);
end

% mc simulation using log-norm process
simu_path = zeros(N, M+1, num_asset);
for i = 1 : num_asset
    simu_path(:,:,i) = [log(S0(i))*ones(N,1), zeros(N,M)];
end

dt = T / M;
for j = 1 : M
    dW_j = dW(:,(j-1)*num_asset+1:j*num_asset);
    for i = 1 : num_asset
        simu_path(:,j+1,i) = simu_path(:,j,i) + ...
            (r-y(i)-0.5*vol(i)^2)*dt + vol(i)*dW_j(:,i);
    end
end
simu_path = exp(simu_path);

% end timing
time = toc;

