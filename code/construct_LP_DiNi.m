
%% Constructs the DiNi03 LP to be solved. The variables, implicit in the LP,
%% should be thought of as an array: [secret_attribute, slack_pos, slack_neg].
function [f,intcon,A,b,Aeq,beq,lb,ub] = construct_LP_DiNi(integer_programming, ...
    uid, error_sigma, ...
    num_queries, mechanism_answer, queries, error_bound)

    num_constraints = num_queries;
    num_variables = length(uid) + 2*num_constraints; 

    %% Variables lower and upper bounds, integrality, objective %%
    error_magnitude = error_bound*error_sigma;
    lb = zeros(1,num_variables);
    ub = [1*ones(1,length(uid)),...
        error_magnitude*ones(1,num_constraints), ...
        error_magnitude*ones(1,num_constraints)];
    intcon = 1:length(uid);
    f = zeros(1,num_variables); %DiNi uses the trivial objective function.

    
    %% Defining the constraints
    % A and b define inequality constraints. We have 1 trivial constraint.
    A = zeros(1,num_variables); % Does nothing
    b = 1; % Does nothing
    
    % Aeq and beq define equality constraints. These are the real
    % constraints of interest.
    Aeq = [queries',eye(num_constraints),-eye(num_constraints)];
    beq = mechanism_answer;   
end