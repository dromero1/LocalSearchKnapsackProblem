function X = kp_grasp_local_search(x0,n,m,W,A,b)
%KP_GRASP_LOCAL_SEARCH KP GRASP local search
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
%   X - Pareto front of local search

% Solutions in pareto front
X = x0';

% Objetives values in pareto front
Z = X*W';

% Solutions to explore
sol = 1;

% Index
idx = 1;

while sol >= 1
    % Current solution
    x = X(idx,:)';
    % Current resource consumption
    R = A*x;
    % Current objective values
    z = W*x;
    % Stop condition
    stop = false;
    % Local non-dominated solutions
    X_nd = [];
    Z_nd = [];
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
                            % Determine if new solution dominates the
                            % current solution
                            if prod(z_prime>=z) == 1 && sum(z_prime>z) >= 1
                                % Update stop condition
                                stop = false;
                                % Determine if new solution dominates the
                                % solution
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
        if stop == false
            % Get best movement
            i = b_move(1);
            j = b_move(2);
            % Update current solution
            x(i) = false;
            x(j) = true;
            % Update resource consumption
            R = R + A(:,j) - A(:,i);
            % New objective values
            z = z + W(:,j) - W(:,i);
        end
    end
    % Save improved solution
    X(idx,:) = x';
    Z(idx,:) = z;
    % Update index
    idx = idx + 1;
    % Update explored solutions
    sol = sol - 1;
    % Number of global solutions
    ns = size(X,1);
    % Add solutions to explore
    lnd = size(X_nd,1);
    for j = 1:lnd
        % Solution to explore
        x_nd = X_nd(j,:);
        z_nd = Z_nd(j,:);
        nd_flag = true;
        % Evaluate dominance
        for k = 1:ns
            if prod(Z(k,:)>=z_nd) == 1 && sum(Z(k,:)>z_nd) >= 1
                nd_flag = false;
                break;
            end
        end
        if ~ismember(x_nd,X,'rows') && nd_flag == true
            X = [X; x_nd];
            Z = [Z; z_nd];
            sol = sol + 1;
        end
    end
end

% Get non-dominated solutions
[Ipo,~] = pareto_dominance(Z);
X = X(Ipo,:);

end