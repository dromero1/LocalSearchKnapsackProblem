function [rT,rS,rF,rFS,rMS,rPC,rPS,rDU] = kp_testbed()
%KP_TESTBED Knapsack problem testbed
%
%   Outputs:
%   rT - Processing times
%   rS - Number of solutions
%   rF - Number of feasible solutions
%   rFS - Feasible share
%   rMS - Mix share
%   rPC - Number of pareto solutions
%   rPS - Pareto share
%   rDU - Mean perc. distance to upper bound

rng('default');

%% Technical parameters

% Instance count
IC = 20;

% Filenames
input_file = 'files/Input.xlsx';
output_file = 'files/Output.xlsx';

% Debug mode
dbg = false;

%% Results
rT = zeros(IC,1);
rS = zeros(IC,1);
rF = zeros(IC,1);
rFS = zeros(IC,1);
rMS = zeros(IC,1);
rPC = zeros(IC,1);
rPS = zeros(IC,1);
rDU = zeros(IC,1);

%% Main loop
for i = 1:IC
    %% Extraction
    % Raw problem
    P_raw = readmatrix(input_file,'Sheet',['I',num2str(i)],'NumHeaderLines',0);
    % Extraction
    cr = P_raw(1,1:3);
    % Items count
    n = cr(1);
    % Restrictions count
    m = cr(2);
    % Objectives count
    p = cr(3);
    % Constraints coefficients
    A = P_raw(2:m+1,1:n);
    % Resources capacity
    b = P_raw(2:m+1,n+1);
    % Objective coefficients
    W = P_raw(m+2:m+p+1,1:n);
    %% Execution
    % Results collection
    MR = [];
    mid = 1;
    % GRASP method
    for alpha = [0.05 0.15 0.25]
        % Get solutions
        tic
        [X,Z] = kp_grasp(i,n,p,m,W,A,b,alpha,dbg);
        time = toc;
        % Save results
        ms.mid = mid;
        ms.mtd = sprintf('G-%0.2f',alpha);
        ms.X = X;
        ms.Z = Z;
        ms.t = time;
        MR = [MR; ms];
        % Update method instance id
        mid = mid + 1;
    end
    %% Pareto front
    % Mix solutions
    X = [];
    Z = [];
    for j = 1:length(MR)
        Z = [Z; MR(j,:).Z];
        X = [X; MR(j,:).X];
    end
    % Remove duplicates
    [X,ix,~] = unique(X,'rows');
    Z = Z(ix,:);
    % Remove infeasible solutions
    If = (Z(:,p+1)==1);
    fc = sum(If);
    if fc >= 1
        X = X(If,:);
        Z = Z(If,:);
    end
    % Get non-dominated solutions
    [Ipo,~] = pareto_dominance(Z);
    PX = X(Ipo,:);
    PZ = Z(Ipo,:);
    % Upper bound
    ub = abs(W)*ones(n,1);
    % Instance statistics
    fprintf('Instance %d - Statistics\n',i);
    fprintf('Number of solutions: %d\n',size(X,1));
    fprintf('Number of feasible solutions: %d\n',fc);
    fprintf('Number of pareto-optimal solutions: %d\n',size(PX,1));
    fprintf('Number of feasible solutions in pareto front: %d\n',sum(PZ(:,p+1)==1));
    for j = 1:length(MR)
        % Calculate statistics
        ms = MR(j,:);
        num_solutions = size(ms.Z,1);
        num_feasible = sum(ms.Z(:,p+1)==1);
        inMix = intersect(ms.X,X,'rows');
        solutions_in_mix = size(inMix,1);
        inPareto = intersect(ms.X,PX,'rows');
        solutions_in_pareto = size(inPareto,1);
        mix_share = solutions_in_mix / size(X,1);
        pareto_share = solutions_in_pareto / size(PX,1);
        % Distance to upper bound
        Z_prime = ms.Z';
        Z_prime = Z_prime(1:p,:);
        dist_2_ub = (ub-Z_prime)./ub;
        mean_dist_2_ub = mean(dist_2_ub,'all');
        % Save statistics
        rT(i,ms.mid) = ms.t;
        rS(i,ms.mid) = num_solutions;
        rF(i,ms.mid) = num_feasible;
        rFS(i,ms.mid) = num_feasible / num_solutions;
        rMS(i,ms.mid) = mix_share;
        rPC(i,ms.mid) = solutions_in_pareto;
        rPS(i,ms.mid) = pareto_share;
        rDU(i,ms.mid) = mean_dist_2_ub;
        % Display
        fprintf('Method %s (time = %0.2f, sol. = %d, ',ms.mtd,ms.t,num_solutions);
        fprintf('fea. = %d, md2ub = %0.2f, sol. mix = %d, ',num_feasible,mean_dist_2_ub,solutions_in_mix)
        fprintf('mix share = %0.2f, sol. pareto = %d, pareto share = %0.2f)\n',mix_share,solutions_in_pareto,pareto_share);
    end
    %% Download results
    nsol = size(PX,1);
    % Build output matrix
    O = NaN(nsol+1,1+max(sum(PX,2))+m+p);
    O(1,1) = nsol;
    for j = 1:nsol
        x = PX(j,:);
        sline = [sum(x) find(x) (A*x')' (W*x')'];
        O(j+1,1:length(sline)) = sline;
    end
    % Write solutions to output file
    writematrix(O,output_file,'Sheet',['I',num2str(i)]);
end

end