% Monte Carlo Simulation via latin hypercube sampling
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

function [simu_path, time] = latinhypercube_mc(r, y, vol, cor, S0, T, N, M)
 

if length(vol) ~= size(cor,1) ||...
        size(cor,1) ~= size(cor,2) ||...
        length(y) ~= length(vol)
    fprintf('Input error in func_quai_mc\n\n');
    return;
end
num_asset = length(vol);

% start timing
tic;

% random number generation
z_lhc = rand(N,num_asset*M);
permN = [];
for i=1:num_asset*M
    permN = [permN, randperm(N)'];
end
z_lhc = norminv((permN-z_lhc)/N, 0, 1);


% convert to correlated random number
A       = chol(cor, 'lower');
cor_qmc = zeros(size(z_lhc));
for i = 1 : M
    cor_qmc(:,(i-1)*num_asset+1:i*num_asset) = ...
        (A*z_lhc(:,(i-1)*num_asset+1:i*num_asset)')';
end

% mc simulation using log-norm process
simu_path = zeros(N, M+1, num_asset);
for i = 1 : num_asset
    simu_path(:,:,i) = [log(S0(i))*ones(N,1), zeros(N,M)];
end

dt = T / M;
for j = 1 : M
    rn = cor_qmc(:,(j-1)*num_asset+1:j*num_asset);    
    for i = 1 : num_asset
        simu_path(:,j+1,i) = simu_path(:,j,i) + ...
            (r-y(i)-0.5*vol(i)^2)*dt + vol(i)*sqrt(dt)*rn(:,i);
    end
end
simu_path = exp(simu_path);

% end timing
time = toc;

