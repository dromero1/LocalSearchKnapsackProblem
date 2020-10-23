function [found,x_star,R_delta,z_delta,X_nd,Z_nd] = kp_grasp_vns_n1(x0,n,W,A,R,b,z)
%KP_GRASP_VNS KP GRASP variable neighborhood search neighborhood 1
%
%   Inputs:
%   x0 - Solution
%   n - Number of items
%   W - Objective coefficients
%   A - Constraint coefficients
%   R - Current resource consumption
%   b - Resource capacity
%   z - Current objective values
%
%   Outputs:
%   found - A better solution was found
%   x_star - Improved solution
%   z_star - Objective values of best solution found
%   X_nd - Local non-dominated solution
%   Z_nd - Objetive values of local non-dominated solutions

% Current solution
x = x0;

% Best solution so far
x_star = x;
z_star = z;

% Deltas
R_delta = b.*0;
z_delta = z.*0;

% Best move so far
b_move = [0 0];

% Best solution found
found = false;

% Local non-dominated solutions
X_nd = [];
Z_nd = [];

% Explore neighborhood
for i = 1:n
    if x(i) == true
        for j = 1:n
            if x(j) == false
                % Determine if movement is legal
                if R + A(:,j) - A(:,i) <= b
                    % New solution objetive values
                    z_prime = z + W(:,j) - W(:,i);
                    % Determine if new solution dominates the
                    % current solution
                    if prod(z_prime>=z) == 1 && sum(z_prime>z) >= 1
                        % Update found flag
                        found = true;
                        % Determine if new solution dominates the
                        % best solution
                        if prod(z_prime>=z_star) == 1 && sum(z_prime>z_star) >= 1
                            % Update solution
                            b_move(1) = i;
                            b_move(2) = j;
                            % Update best move objective values
                            z_star = z_prime;
                        end
                        % Determine if the new solution is not
                        % dominated by the current pareto front
                    elseif ~(prod(z>=z_prime) == 1 && sum(z>z_prime) >= 1)
                        % Apply movement
                        x_nd = x;
                        x_nd(i) = false;
                        x_nd(j) = true;
                        % Save local non-dominated solution
                        X_nd = [X_nd; x_nd'];
                        Z_nd = [Z_nd; z_prime'];
                        % Get non-dominated solutions
                        [ND,~] = pareto_dominance(Z_nd);
                        X_nd = X_nd(ND,:);
                        Z_nd = Z_nd(ND,:);
                    end
                end
            end
        end
    end
end

if found == true
    % Apply best movement
    i = b_move(1);
    j = b_move(2);
    % Update best solution
    x(i) = false;
    x(j) = true;
    x_star = x;
    % Update deltas
    R_delta = A(:,j) - A(:,i);
    z_delta = W(:,j) - W(:,i);
end

end