function MR = kp_scenario3(ti,n,p,m,W,A,b,mt,dbg)
%KP_SCENARIO3 Component comparison - 2 neighborhood
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

%% GRASP VND1 method
% Get solutions
tic
[X,Z] = kp_grasp(ti,n,p,m,W,A,b,alpha,1,mt,dbg,true);
time = toc;
% Save results
mr.mid = mid;
mr.mtd = sprintf('G-VND1-%0.2f',alpha);
mr.X = X;
mr.Z = Z;
mr.t = time;
MR = [MR; mr];

%% GRASP VND2 method
% Get solutions
tic
[X,Z] = kp_grasp(ti,n,p,m,W,A,b,alpha,2,mt,dbg,true);
time = toc;
% Save results
mr.mid = mid;
mr.mtd = sprintf('G-VND2-%0.2f',alpha);
mr.X = X;
mr.Z = Z;
mr.t = time;
MR = [MR; mr];

end