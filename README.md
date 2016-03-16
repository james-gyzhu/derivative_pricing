# Financial Derivative Pricing

This set of code is implemented to price an improved Himalaya option with barrier features. The pricing is conducted by multiple Monte Carlo simulation approaches including:

*	Naïve Monte Carlo simulation (classical version of MC)
*	Control variant Monte Carlo simulation
* Quasi Monte Carlo simulation (high-dimensional version)
**	Support Sobol sampling set and Halton sampling set
*	Quasi Monte Carlo simulation using Brownian bridge
*	Stratified Monte Carlo simulation using Brownian bridge 
*	Antithetic Monte Carlo simulation

The underlying asset is a basket which consists of multiple stocks. When pricing the option, the correlation among multiple stocks is considered. 

The main files for running the code are as following:

1. `global_setting.m`: the file includes all the parameter definition. For example, the underlying basket features (risk-free rate, dividend yields, volatilities, spot prices, and correlations), the option features (time to maturity, callable barrier), and Monte Carlo simulation parameters (type of MC algorithm used, number of simulation paths, and number of time steps for simulation).

2. `init_struct.m`: three structures (for Monte Carlo simulation, basket, and option, respectively) are declared and initialized, which includes all the global information used in the running time. One can change “mc.type” (line 48 in the file) and “eln. cp_method” (line 32 in the file) to choose the preferred MC algorithms for pricing.

  * The method of Quasi Monte Carlo simulation using Brownian Bridge is set as default. The options can be changed as:
    * mc_type.naive/eln_cp_method.naive:  Naïve Monte Carlo simulation
    * mc_type.quasi /eln_cp_method.naive:  Quasi Monte Carlo simulation (high-dimensional version)
    * * mc_type.quasi_bb/eln_cp_method.naive:  Quasi Monte Carlo simulation using Brownian bridge
    * * mc_type.naive/eln_cp_method.cv:  Control variant Monte Carlo simulation
    * * mc_type.strat/ eln_cp_method.naive:  Stratified Monte Carlo simulation using Brownian bridge
    * * mc_type.anti/ eln_cp_method.naive:  Antithetic Monte Carlo simulation

  * Regarding the computing power of my laptop, the number of MC simulations (paths) is initialized as 1e4. One can change it to obtain more accurate simulated results.

3. `main.m`: the main function which is can be run directly in the Matlab environment. One can run this file to see the price.

Some basic functions employed the Matlab functions, like Sobol sample generation, eigenvalue decomposition.
