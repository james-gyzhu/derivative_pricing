% main body for product payoff calculation given one mc simulation and
% payoff method

close all;
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load gobal setting
setting_file = 'global_setting';
eval(setting_file);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reference setting
fprintf('Initialize structure references ...\n');
[eln, basket, mc] = init_struct(setting_file);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% basket evolution via mc simulation
% row of bpm - each asset in basket
% col of bpm - each obervation step
fprintf('Basket evolution using MC simulation ...\n');
[basket.bpm, mc.base_mc_t] = basket_evolution(eln, basket, mc);
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eln evolution
fprintf('Option evolution ...\n');
[eln.cp_paid, eln.method_std, eln.method_gain, eln.method_time] =...
    eln_evolution(eln, basket, mc);
fprintf('\n');

fprintf('Cumulative payment:\n');
disp(eln.cp_paid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all done
fprintf('\n');

