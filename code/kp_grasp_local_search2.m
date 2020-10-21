function [x,fea] = kp_grasp_local_search2(x0,n,m,W,A,b)
%KP_GRASP_LOCAL_SEARCH2 KP GRASP local search 2
%
%   Inputs:
%   x - Solution
%   n - Number of items
%   m - Number of constraints
%   W - Objective coefficients
%   A - Constraint coefficients
%   b - Resource capacity
%
%   Outputs:
%   x - Improved solution
%   fea - Feasibility percentage

% Current solution
x = x0;

% Current resource consumption
R = A*x0;

% Current objective values
z = W*x0;

% Stop condition
stop = false;

% Neighborhood search
while stop == false
    stop = true;
    b_move = [0 0];
    z_star = z;
    for i = 1:n
        if x(i) == true
            for j = 1:n
                if x(j) == false
                    % Determine if movement is legal
                    if R + A(:,j) - A(:,i) <= b
                        % New solution objetive values
                        z_prime = z + W(:,j) - W(:,i);
                        % Determine if new solution dominates the old one
                        if prod(z_prime>=z) == 1 && sum(z_prime>z) >= 1
                            % Update stop condition
                            stop = false;
                            % Determine if new solution dominates best sol.
                            if prod(z_prime>=z_star) == 1 && sum(z_prime>z_star) >= 1
                                % Update solution
                                b_move(1) = i;
                                b_move(2) = j;
                                % Update best move objective values
                                z_star = z_prime;
                            end
                        end
                    end
                end
            end
        end
    end
    if stop == false
        % Get best movement
        i = b_move(1);
        j = b_move(2);
        % Update solution
        x(i) = false;
        x(j) = true;
        % Update resource consumption
        R = R + A(:,j) - A(:,i);
        % New objective values
        z = z + W(:,j) - W(:,i);
    end
end

% Feasibility percentage
fea = sum(A*x <= b)/m;

end