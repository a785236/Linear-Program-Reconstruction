
%% Constructs the DMT07 LP to be solved. The variables, implicit in the LP,
%% should be thought of as an array: [secret_attribute, slack_pos, slack_neg].
function [f,intcon,A,b,Aeq,beq,lb,ub] = construct_LP_DMT(integer_programming, ...
    uid, error_sigma, ...
    num_queries, mechanism_answer, queries)

    num_constraints = num_queries;
    num_variables = length(uid) + 2*num_constraints; 

    %% Variables lower and upper bounds, integrality, objective %%
    error_magnitude = realmax; % realmax = 1.7977e+308 is the maximum double precision number
    lb = [0*ones(1,length(uid)),...
        0*ones(1,num_constraints), ...
        0*ones(1,num_constraints)];
    ub = [1*ones(1,length(uid)),...
        error_magnitude*ones(1,num_constraints), ...
        error_magnitude*ones(1,num_constraints)];
    intcon = 1:length(uid);
    f = [zeros(1,length(uid)),ones(1,2*num_constraints)];

    %% Defining the constraints
    % A and b define inequality constraints. We have 1 trivial constraint.
    A = zeros(1,num_variables); % Does nothing
    b = 1; % Does nothing
    
    % Aeq and beq define equality constraints. These are the real
    % constraints of interest.
    Aeq = [queries',eye(num_constraints),-eye(num_constraints)];
    beq = mechanism_answer;   
end