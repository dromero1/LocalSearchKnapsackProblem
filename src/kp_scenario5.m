function MR = kp_scenario5(ti,n,p,m,W,A,b,mt,dbg)
%KP_SCENARIO5 Component comparison - VND vs. ML-ILS
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

%% GRASP VND3 method
% Get solutions
tic
[X,Z,nsol] = kp_grasp(ti,n,p,m,W,A,b,alpha,3,mt,dbg,true);
time = toc;
% Save results
mr.mid = mid;
mr.mtd = sprintf('G-VND2-%0.2f',alpha);
mr.X = X;
mr.Z = Z;
mr.t = time;
mr.nsol = nsol;
MR = [MR; mr];
% Update method instance id
mid = mid + 1;

%% MS-ILS method
% Get solutions
tic
[X,Z,nsol] = kp_msils(ti,n,p,m,W,A,b,alpha,3,mt,dbg);
time = toc;
% Save results
mr.mid = mid;
mr.mtd = sprintf('MS-ILS-G-%0.2f',alpha);
mr.X = X;
mr.Z = Z;
mr.t = time;
mr.nsol = nsol;
MR = [MR; mr];

end