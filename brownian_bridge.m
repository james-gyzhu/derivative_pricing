% Brownian Bridge (BB) for single underlying or a basket
%
% Input
% NCycles: trajectories for BB estimation
% NSteps: time steps for BB estimation
% T: time to maturity
% NAssets: number of underlying in the basket
% RN_T: random number for the estimation at T (for stratification and
% quasi MC)
%
% Output
% WSamples: estimated Brownian Motion Trajectories

function WSamples = brownian_bridge(NCycles, NSteps, T, NAssets, RN_T)

% pre-processing to verify the avaiblity of input parameters
NBisections = log2(NSteps);
if round(NBisections) ~= NBisections
    fprintf('Error input in func_brownian_bridge\n\n');
    WSamples = -1;
    return;
end

% Set the random number for the brownian motion at maturity T
WSamples = zeros(NCycles, (NSteps+1)*NAssets);
WSamples(:, 1:NAssets) = 0;
if isempty(RN_T)
    WSamples(:, NSteps*NAssets+1:(NSteps+1)*NAssets) = sqrt(T)*randn(NCycles, NAssets);
else
    if NAssets ~= size(RN_T, 2)
        fprintf('Error input in func_brownian_bridge\n\n');
        WSamples = -1;
        return;
    end
    WSamples(:, NSteps*NAssets+1:(NSteps+1)*NAssets) = sqrt(T)*RN_T;
end

% BB estimation recursively
TJump = T/2;
IJump = NSteps;
for k = 1 : NBisections
    left = 1;
    i = IJump/2 + 1;
    right = IJump + 1;
    for j = 1 : 2^(k-1)
        a = 0.5*(WSamples(:,(left-1)*NAssets+1:left*NAssets) +...
            WSamples(:,(right-1)*NAssets+1:right*NAssets));
        b = sqrt(0.5*TJump);
        
        WSamples(:,(i-1)*NAssets+1:i*NAssets) = a + b.*randn(NCycles,NAssets);
        
        right = right + IJump;
        left = left + IJump;
        i = i + IJump;
    end
    IJump = IJump/2;
    TJump = TJump/2;
end

% for test
% kk = 1;
