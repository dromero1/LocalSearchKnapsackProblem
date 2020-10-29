function MR = kp_scenario6(ti,n,p,m,W,A,b,mt,dbg)
%KP_SCENARIO6 Parameter comparison
%
%   Inputs:
%   ti - Test instance
%   n - Number of items
%   p - Number of objectives
%   m - Number of constraints
%   W - Objective coefficients
%   A - Constraint coefficients
%   b - Resource capacity
%   mt - Maximum execution time
%   dbg - Debug mode
%
%   Outputs:
%   MR - Results collection

% Results collection
MR = [];

% Method id
mid = 1;

%% GRASP method
for alpha = [0.05 0.15 0.25 0.35 0.45]
    % Get solutions
    tic
    [X,Z] = kp_grasp(ti,n,p,m,W,A,b,alpha,J,mt,dbg,false);
    time = toc;
    % Save results
    mr.mid = mid;
    mr.mtd = sprintf('G-%0.2f',alpha);
    mr.X = X;
    mr.Z = Z;
    mr.t = time;
    MR = [MR; mr];
    % Update method instance id
    mid = mid + 1;
end

end