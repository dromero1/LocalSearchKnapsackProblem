function [rT,rS,rF,rFS,rI1,rI2,rDU] = kp_testbed()
%KP_TESTBED Knapsack problem testbed
%
%   Outputs:
%   rT - Processing times
%   rS - Number of solutions
%   rF - Number of feasible solutions
%   rFS - Feasible share
%   rI1 - Probability of generating solutions in the Pareto Front
%   rI2 - Probability of generating non-dominated solutions
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
rI1 = zeros(IC,1);
rI2 = zeros(IC,1);
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
        mr.mid = mid;
        mr.mtd = sprintf('G-%0.2f',alpha);
        mr.X = X;
        mr.Z = Z;
        mr.t = time;
        MR = [MR; mr];
        % Update method instance id
        mid = mid + 1;
    end
    % MS-ILS GRASP method
    for alpha = [0.05 0.15 0.25]
        % Get solutions
        tic
        [X,Z] = kp_msils(i,n,p,m,W,A,b,alpha,dbg);
        time = toc;
        % Save results
        mr.mid = mid;
        mr.mtd = sprintf('MS-ILS-G-%0.2f',alpha);
        mr.X = X;
        mr.Z = Z;
        mr.t = time;
        MR = [MR; mr];
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
    cP = size(PX,1);
    % Upper bound
    ub = abs(W)*ones(n,1);
    % Instance statistics
    fprintf('Instance %d - Statistics\n',i);
    fprintf('Number of solutions: %d\n',size(X,1));
    fprintf('Number of feasible solutions: %d\n',fc);
    fprintf('Number of pareto-optimal solutions: %d\n',size(PX,1));
    fprintf('Number of feasible solutions in pareto front: %d\n',sum(PZ(:,p+1)==1));
    for j = 1:length(MR)
        % Method's results
        mr = MR(j,:);
        % Solution count
        cA = size(mr.Z,1);
        cF = sum(mr.Z(:,p+1)==1);
        % Solutions in Pareto Front
        IAP = intersect(mr.X,PX,'rows');
        cAP = size(IAP,1);
        % Calculate statistics
        i1 = cAP / cP;
        i2 = cAP / cA;
        % Distance to upper bound
        Z_prime = mr.Z';
        Z_prime = Z_prime(1:p,:);
        d2ub = (ub-Z_prime)./ub;
        md2ub = mean(d2ub,'all');
        % Save statistics
        rT(i,mr.mid) = mr.t;
        rS(i,mr.mid) = cA;
        rF(i,mr.mid) = cF;
        rFS(i,mr.mid) = cF / cA;
        rI1(i,mr.mid) = i1;
        rI2(i,mr.mid) = i2;
        rDU(i,mr.mid) = md2ub;
        % Display
        fprintf('Method %s (time = %0.2f, sol. = %d, ',mr.mtd,mr.t,cA);
        fprintf('fea. = %d, md2ub = %0.2f, ',cF,md2ub)
        fprintf('I1 = %0.2f, I2 = %0.2f)\n',i1,i2);
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