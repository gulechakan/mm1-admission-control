%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assignment: ECE7353 Programming Assignment
% Author    : Hakan Gulec
% Student ID: N12134877
% Subject   : M/M/1 Queue Admission Control - Value Iteration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;


%% Recommended template


% A recommended template is provided with the assignment description:
% Define iter - maximum number of iterations; 
% queue arrival and service rates - gamma, mu; 
% reward for acceptance - R; 
% maximum queue length - maxLength.
% Define 2D array of values - v(iter,maxLength); 
% loop variable - n. Set n = 1.
% while n<=iter do
%    //enter your value iteration code
% end while
% Define 1D array of difference in values - d(maxLength-1) 
% Compute d(s) using converged values
% Compute the decision threshold, s0, using d(s)


%% Parameter setup


% Define the parameters
max_iteration     = 100000;   % The maximum number of iterations
gamma_arrival     = 37    ;   % The queue arrival rate
mu_service        = 50    ;   % The service rate
reward_acceptance = 15    ;   % Reward for acceptance
max_queue_length  = 1000  ;   % Maximum queue length
threshold         = 1e-4  ;   % Convergence threshold for value iteration


%% Value Iteration


% Initialize the value function
value_function = zeros(max_iteration + 1, max_queue_length + 1);

% Compute the value function
[value_function, num_iter] = iterateValueFunction(value_function   , ...
                                                  mu_service       , ...
                                                  gamma_arrival    , ...
                                                  reward_acceptance, ...
                                                  max_iteration    , ...
                                                  max_queue_length , ...
                                                  threshold);


%% Find the optimal queue length for the acceptance or rejection decision


% Compute the difference in state values
if num_iter <= max_iteration + 1

    num_iter = num_iter - 1; 
    differences = diff(value_function(num_iter, :), 1, 2);


else

    num_iter = num_iter - 2; 
    differences = diff(value_function(num_iter, :), 1, 2);

end


%% Display the iteration time 


% Display the iteration step where the value function converges
fprintf('The algorithm is run for %d iteration\n', num_iter);


%% Compute the decision threshold


% Find the optimal queue length for the acceptance/rejection decision
queue_length_optimal_indices = find(differences < -reward_acceptance);

if isempty(queue_length_optimal_indices)

    queue_length_optimal = max_queue_length;
    fprintf('Difference is never less than -R');

else

    queue_length_optimal = min(queue_length_optimal_indices) - 1;

end

% Print the optimal value of queue length decision point
fprintf('Decision threshold s_0: %d\n', queue_length_optimal);


%% Display the requested plots


% Plot the stationary value function against queue length
figure('Name', 'Stationary Value Function vs Queue Length', ...
    'NumberTitle', 'off');
plot(value_function(num_iter, :));
xlabel('s'); 
ylabel('v_\infty(s)');
title('v_\infty(s) vs Queue Length');

% Plot the difference in value functions
figure('Name', 'Difference in Value Functions', ...
    'NumberTitle', 'off');
plot(differences);
xlabel('s'); 
ylabel('d(s)');
title('d(s) vs Queue Length');