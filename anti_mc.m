% Antithetic Monte Carlo Simulation
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

function [simu_path, time] = anti_mc(r, y, vol, cor, S0, T, N, M)

if length(vol) ~= size(cor,1) ||...
        size(cor,1) ~= size(cor,2) ||...
        length(y) ~= length(vol)
    fprintf('Input error in func_quai_mc\n\n');
    return;
end
num_asset = length(vol);

% start timing
tic;

% correlated random number generation
A = chol(cor, 'lower');
rn = randn(N, M*num_asset);
cor_rn = zeros(size(rn));
for i = 1 : M
    cor_rn(:,(i-1)*num_asset+1:i*num_asset) = ...
        (A*rn(:,(i-1)*num_asset+1:i*num_asset)')';
end
% negative random number
cor_rn = [cor_rn; -cor_rn];
N2 = 2 * N;

% mc simulation using log-norm process
dt = T / M;
simu_path = zeros(N2, M+1, num_asset);
for i = 1 : num_asset
    simu_path(:,:,i) = [log(S0(i))*ones(N2,1), zeros(N2,M)];
end
for j = 1 : M
    rn = cor_rn(:,(j-1)*num_asset+1:j*num_asset);
    for i = 1 : num_asset
        simu_path(:,j+1,i) = simu_path(:,j,i) + ...
            (r-y(i)-0.5*vol(i)^2)*dt + vol(i)*sqrt(dt)*rn(:,i);
    end
end

simu_path = exp(simu_path);

% end timing
time = toc;
