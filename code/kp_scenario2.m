function MR = kp_scenario2(ti,n,p,m,W,A,b,mt,dbg)
%KP_SCENARIO2 Component comparison - 1 neighborhood
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

% Fixed alpha
alpha = 0.15;

% Number of neighborhoods
J = 1;

%% GRASP method
% Get solutions
tic
[X,Z,nsol] = kp_grasp(ti,n,p,m,W,A,b,alpha,J,mt,dbg,false);
time = toc;
% Save results
mr.mid = mid;
mr.mtd = sprintf('G-%0.2f',alpha);
mr.X = X;
mr.Z = Z;
mr.t = time;
mr.nsol = nsol;
MR = [MR; mr];
% Update method instance id
mid = mid + 1;

%% GRASP VND method
% Get solutions
tic
[X,Z,nsol] = kp_grasp(ti,n,p,m,W,A,b,alpha,J,mt,dbg,true);
time = toc;
% Save results
mr.mid = mid;
mr.mtd = sprintf('G-VND-%0.2f',alpha);
mr.X = X;
mr.Z = Z;
mr.t = time;
mr.nsol = nsol;
MR = [MR; mr];

end