function x_p = kp_perturb(x,n)
%KP_PERTURB Perturb knapsack problem soltuion
%
%   Inputs:
%   x - Solution to perturb
%   n - Number of items
%
%   Outputs:
%   x_p - Perturbed solution

% Get 5 random indexes to flip
idx = randperm(n,5);

% Perturbed solution
x_p = x;

% Flip items
for i = idx
   x_p(i) = ~x_p(i); 
end

end