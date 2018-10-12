
%% Constructs an LP whose solution is the best (in terms of accuracy) 
%% feasible result for the DiNi LP constructed by construct_LP_DiNi.m 
%% using the same inputs. This code is UNTESTED and provided AS IS.
%% The variables, implicit in the LP, should be thought of as an array: 
%% [secret_attribute, slack_pos, slack_neg].
function [f,intcon,A,b,Aeq,beq,lb,ub] = construct_LP_DiNi_max(integer_programming, ...
    uid, error_sigma, ...
    num_queries, mechanism_answer, queries, true_attribute, error_bound)

    num_constraints = num_queries;
    num_variables = 2*length(uid) + 2*num_constraints; 

    %% Variables lower and upper bounds, integrality, objective %%
    error_magnitude = error_bound*error_sigma;
    lb = zeros(1,num_variables);
    ub = [1-true_attribute', true_attribute',...
        error_magnitude*ones(1,2*num_constraints)];
    intcon = 1:2*length(uid);
    f_best = [ones(1,length(uid)),ones(1,length(uid)),zeros(1,2*num_constraints)];
	f = f_best;
    
    %% Defining the constraints
    % A and b define inequality constraints. We have 1 trivial constraint.
    A = zeros(1,num_variables); % Does nothing
    b = 1; % Does nothing
    
    % Aeq and beq define equality constraints. These are the real
    % constraints of interest.
    Aeq = [queries',-queries',eye(num_constraints),-eye(num_constraints)];
    beq = mechanism_answer - queries'*true_attribute;   