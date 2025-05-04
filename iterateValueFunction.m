function [value_function, iter] = iterateValueFunction(value        , ...
                                                       mu           , ...
                                                       gamma        , ...
                                                       reward       , ...
                                                       max_iteration, ...
                                                       max_state    , ...
                                                       threshold)

    % This function performs value iteration for the M/M/1 Queue Admission
    % Control

    % Define the iteration variable
    i = 2;

    % Compute the value function
    while i <= (max_iteration + 1)
        
        for s = 1:(max_state + 1)

            % Compute the value function for the first state
            if s == 1
            
                value(i, s) = (mu / (mu + gamma)) * value(i - 1, s) + ...
                    (gamma / (mu + gamma)) * max(reward + ...
                    value(i - 1, s + 1), value(i - 1, s));

            % Compute the value function when both arrivals and departures
            % are possible
            elseif s < max_state
            
                value(i, s) = -(s - 1) + mu / (mu + gamma) * ...
                    value(i - 1, s - 1) + gamma / (mu + gamma) * ...
                    max(reward + value(i - 1, s + 1), value(i - 1, s));

            % Compute the value function in case of rejection
            else

                value(i, s) = -(s - 1) + (mu / (mu + gamma)) * ...
                    value(i - 1, s - 1) + gamma / (mu + gamma) * ...
                    value(i - 1, s);

            end

        end
        
        % Check the convergence
        if norm(value(i, :) - value(i - 1, :)) < threshold
            
            fprintf("It is converged!\n");
            break
    
        end

        i = i + 1;
    
    end

    iter = i;
    
    value_function = value;

end

