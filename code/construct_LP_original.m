
%% Constructs the LP originally used for the mechanism Challenge, and is  
%% provided only for transparency. The variables, implicit in the LP,
%% should be thought of as an array: [secret_attribute, slack_pos, slack_neg].
function [f,intcon,A,b,Aeq,beq,lb,ub] = construct_LP_original(integer_programming, ...
    uid, error_sigma, ...
    num_queries, mechanism_answer, queries)

    num_constraints = num_queries;
    num_variables = length(uid) + 2*num_constraints; 

    %% Variables lower and upper bounds, integrality, objective %%
    error_magnitude = 5*error_sigma;
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
    
    %% Removing bad queries. 
    % These query responses are 0 for unknown reasons, 
    % possibly due to bucket suppression, but probably not.
    good_queries = true(num_queries,1);
    good_queries(find(beq<=0)) = false; % Deletes all 0 answers
    beq = beq(good_queries);
    Aeq = Aeq(good_queries,:);
end