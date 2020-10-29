function [X,Z,nsol] = kp_msils(ti,n,p,m,W,A,b,alpha,J,mt,dbg)
%KP_MSILS MS-ILS approximation to the knapsack problem
%
%   Inputs:
%   ti - Test instance
%   n - Number of items
%   p - Number of objectives
%   m - Number of constraints
%   W - Objective coefficients
%   A - Constraint coefficients
%   b - Resource capacity
%   alpha - Best candidate percentage
%   J - Number of neighborhoods
%   mt - Maximum execution time
%   dbg - Debug mode
%
%   Outputs:
%   X - Solutions
%   Z - Objective values
%   nsol - Number of solutions

% Number of perturbations per solution
pt = 1000;

% Initial time
t0 = toc;

% Solutions
X = false(1,n);
Z = zeros(1,p+1);
fc = 0;

% Main loop
i = 1;
while toc - t0 <= mt
    % Randomized constructive solution
    [x,fea,~] = kp_grasp_construct_solution(n,m,W,A,b,alpha);
    if fea == 1
        % Variable neighborhood descent
        X_star = kp_vnd(x,n,m,W,A,b,J,t0,mt);
        n_star = size(X_star,1);
        % Improve local optimal solutions
        for j = 1:n_star
            % Local optimum
            x_star = X_star(j,:)';
            z_star = W*x_star;
            % Local non-dominated solutions
            X_lnd = [];
            Z_lnd = [];
            % Perturbations
            for k = 1:pt
                % Check time
                if toc - t0 > mt
                   break; 
                end
                % Perturb solution
                x_prime = kp_perturb(x_star,n);
                % Determine if the pertubated solution is feasible
                if A*x_prime <= b
                    % Variable neighborhood descent
                    X_prime = kp_vnd(x_prime,n,m,W,A,b,J,t0,mt);
                    n_prime = size(X_prime,1);
                    for l = 1:n_prime
                        % Twice-improved solution
                        x_prime = X_prime(l,:);
                        z_prime = W*x_prime';
                        % Determine if the twice-improved solution
                        % dominates the local optimum
                        if prod(z_prime>=z_star) == 1 && sum(z_prime>z_star) >= 1
                            x_star = x_prime';
                            z_star = z_prime;
                            % Determine if the the twice-improved solution
                            % is not dominated by the local optimum
                        elseif ~(prod(z_prime>=z_star) == 1 && sum(z_prime>z_star) >= 1)
                            % Save local non-dominated solution
                            X_lnd = [X_lnd; x_prime];
                            Z_lnd = [Z_lnd; z_prime'];
                            % Get non-dominated solutions
                            [ND,~] = pareto_dominance(Z_lnd);
                            X_lnd = X_lnd(ND,:);
                            Z_lnd = Z_lnd(ND,:);
                        end
                    end
                end
            end
            % Save ILS-improved solution
            X(i,:) = x_star';
            fea = sum(A*x_star <= b)/m;
            Z(i,:) = [z_star' fea];
            if fea == 1
                fc = fc + 1;
            end
            % Display
            if dbg == true
                fprintf('MS-ILS Instance %d (alpha = %0.2f, ',ti,alpha);
                fprintf('rep. = %d, feas. = %0.2f)\n',i,fea);
            end
            i = i + 1;
            % Save local non-dominated solutions
            n_lnd = size(X_lnd,1);
            for r = 1:n_lnd
                % Local non-dominated solution
                x_lnd = X_lnd(r,:);
                z_lnd = Z_lnd(r,:);
                X(i,:) = x_lnd;
                % Determine feasibility
                fea = sum(A*x_lnd' <= b)/m;
                % Local non-dominated objective values
                Z(i,:) = [z_lnd fea];
                if fea == 1
                    fc = fc + 1;
                end
                % Display
                if dbg == true
                    fprintf('MS-ILS Instance %d (alpha = %0.2f, ',ti,alpha);
                    fprintf('rep. = %d, feas. = %0.2f)\n',i,fea);
                end
                i = i + 1;
            end
        end
    else
        % Save unfeasible solution
        X(i,:) = x;
        Z(i,:) = [(W*x)' fea];
        i = i + 1;
    end
end

% Number of solutions
nsol = i;

% Remove duplicates
[X,ix,~] = unique(X,'rows');
Z = Z(ix,:);

% Remove infeasible solutions
if fc >= 1
    If = (Z(:,p+1)==1);
    X = X(If,:);
    Z = Z(If,:);
end

% Get non-dominated solutions
[Ipo,~] = pareto_dominance(Z);
X = X(Ipo,:);
Z = Z(Ipo,:);

end