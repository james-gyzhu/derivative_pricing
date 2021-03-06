% Quasi Monte Carlo Simulation with Brownian Bridge
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

function [simu_path, time] = quasi_mc_bb(r, y, vol, cor, S0, T, N, M)

% 1: sobolset;  2: haltonset;
quasi_generater = 1;

if length(vol) ~= size(cor,1) ||...
        size(cor,1) ~= size(cor,2) ||...
        length(y) ~= length(vol)
    fprintf('Input error in func_quai_mc\n\n');
    return;
end
num_asset = length(vol);

% start timing
tic;

% qrs generation
nskip = round(1e4*(rand(1)+1));
%nskip = 1e4
nleap = 100;
switch quasi_generater
    case 1
        s_qmc = sobolset(num_asset, 'Skip', nskip, 'Leap', nleap);
    case 2
        s_qmc = haltonset(num_asset, 'Skip', nskip, 'Leap', nleap);
    otherwise
        fprintf('Error at quasi_generator in func_quasi_mc\n\n');
        return;
end
s_qmc = net(s_qmc, N);
rn = norminv(s_qmc, 0, 1);

% correlated brownian bridge
z_qmc = brownian_bridge(N, M, T, num_asset, rn);
[V, D] = eig(cor);
D = repmat(diag(D, 0)', size(V,1), 1);
A = (D.^0.5) .* V;
cor_qmc = zeros(size(z_qmc));
for i = 1 : M+1
    cor_qmc(:,(i-1)*num_asset+1:i*num_asset) = ...
        (A*z_qmc(:,(i-1)*num_asset+1:i*num_asset)')';
end

% dW
dW = zeros(size(cor_qmc,1), size(cor_qmc,2)-num_asset);
for i = 1 : M
    dW(:,(i-1)*num_asset+1:i*num_asset) = ...
        cor_qmc(:,i*num_asset+1:(i+1)*num_asset) - ...
        cor_qmc(:,(i-1)*num_asset+1:i*num_asset);
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

