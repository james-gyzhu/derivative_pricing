% Naive Monte Carlo with Brownian Bridge
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

function [simu_path, time] = naive_mc_bb(r, y, vol, cor, S0, T, N, M)

if length(vol) ~= size(cor,1) ||...
        size(cor,1) ~= size(cor,2) ||...
        length(y) ~= length(vol)
    fprintf('Input error in func_quai_mc\n\n');
    return;
end
num_asset = length(vol);

% start timing
tic;

% correlated brownian bridge
rn = randn(N, num_asset);
rn = brownian_bridge(N, M, T, num_asset, rn);

[V, D] = eig(cor);
D = repmat(diag(D, 0)', size(V,1), 1);
A = (D.^0.5) .* V;
cor_rn = zeros(size(rn));
for i = 1 : M+1
    cor_rn(:,(i-1)*num_asset+1:i*num_asset) = ...
        (A*rn(:,(i-1)*num_asset+1:i*num_asset)')';
end

% dW
dW = zeros(size(cor_rn,1), size(cor_rn,2)-num_asset);
for i = 1 : M
    dW(:,(i-1)*num_asset+1:i*num_asset) = ...
        cor_rn(:,i*num_asset+1:(i+1)*num_asset) - ...
        cor_rn(:,(i-1)*num_asset+1:i*num_asset);
end

% mc simulation using log-norm process
simu_path = zeros(N, M+1, num_asset);
for i = 1 : num_asset
    simu_path(:,:,i) = [log(S0(i))*ones(N,1), zeros(N,M)];
end

dt = T / M;
for j = 1 : M    
    rn = dW(:,(j-1)*num_asset+1:j*num_asset);
    for i = 1 : num_asset
        simu_path(:,j+1,i) = simu_path(:,j,i) + ...
            (r-y(i)-0.5*vol(i)^2)*dt + vol(i)*rn(:,i);
    end
end
simu_path = exp(simu_path);

% end timing
time = toc;

