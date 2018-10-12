%% The core attack function. Performs LP reconstruction using the input parameters.

function [guess_attribute, ...
    error_pos,...
    error_neg,...
    feasible_solution_found] ...
    =    attack(lp_type,...
                integer_programming,...
                num_primes,...
                error_sigma,... 
                parsed_mechanism_answer_file,...
                mechanism_output_file,... 
                simulation,...
                uid,...
                true_attribute,...
                dini_bound)
      
    %% Declaring constants %%
    global multiplier offset exponent;
    multiplier = zeros(num_primes, 1);
    prime = primes(1000);
    for i=1:num_primes
        multiplier(i) = prime(i);
    end
    offset = [5,10,50,100,500,1000,5000,10000,50000,100000];
    exponent = (0.5 + 0.1 .* (0:4)); 
    %% For data originally used in Diffix attack, uncomment the following:
    % exponent_with_integers = (0.5 + 0.1 .* (0:15)); % exponent(6) = 1 and exponent(16) = 2 need to be removed
    % exponent = exponent_with_integers([1:5 7:end-1]); % removing integer exponentsclient
    num_queries = length(multiplier)*length(offset)*(length(exponent));

    %% Determining which subsets of uid's are in each query
    % The result: queries(id, query) == 1 if the id is included in the query, 0 otherwise.
    queries = get_queries(uid, num_queries);    

    %% Simulating / Loading / Parsing mechanism answers
    % To import pgAdmin output, save the output and call:
    % importdata(FILENAME, '\t', 1);

    % Real outputs: If parsed_mechanism_answer_file = '', then the code will
    % parse the file at mechanism_output_file. The parsed result should be
    % manually saved. If parsed_mechanism_answer_file = 'filename', then it will
    % just use that file.

    % Simulated outputs: If simulation = true, then this code will generate
    % simulated mechanism results.
    mechanism_answer = 0;
    if simulation == true
        mechanism_answer = simulate_answers(num_queries,true_attribute, queries, error_sigma);
    else
        if not(isempty(parsed_mechanism_answer_file))
            load(parsed_mechanism_answer_file); % sets mechanism_answer;
        else
            mechanism_answer = parse_aircloak_answers(num_queries, mechanism_output_file);
        end
    end

    %% Construct the LP: DMT, DiNi, DiNi-Max or the original LP used for the Diffix attack
    if strcmp(lp_type,'dini-max')
        if ~exist('dini_bound', 'var')
            error('Must specify dini_bound when using lp_type dini-max');
        end
        [f,intcon,A,b,Aeq,beq,lb,ub] = construct_LP_DiNi_max(integer_programming, ...
            uid, error_sigma, ...
            num_queries, mechanism_answer, queries, true_attribute, dini_bound);
    elseif strcmp(lp_type,'dini')
        if ~exist('dini_bound', 'var')
            error('Must specify dini_bound when using lp_type dini');
        end
        [f,intcon,A,b,Aeq,beq,lb,ub] = construct_LP_DiNi(integer_programming, ...
            uid, error_sigma, ...
            num_queries, mechanism_answer, queries, dini_bound);
    elseif strcmp(lp_type,'dmt')
        [f,intcon,A,b,Aeq,beq,lb,ub] = construct_LP_DMT(integer_programming, ...
            uid, error_sigma, ...
            num_queries, mechanism_answer, queries);
    elseif strcmp(lp_type,'original')
        [f,intcon,A,b,Aeq,beq,lb,ub] = construct_LP_original(integer_programming, ...
            uid, error_sigma, ...
            num_queries, mechanism_answer, queries);
    else
        error(strcat('Invalid lp_type:',lp_type)); 
    end
        
    %% Solving and parsing the output
    if integer_programming
        options = optimoptions('intlinprog', 'Display', 'iter', 'MaxTime', 30);
        [x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,options);
    else
        options = optimoptions('linprog', 'Display', 'off', 'MaxTime', 30);
        [x,fval,exitflag,output] = linprog(f,A,b,Aeq,beq,lb,ub,options);
    end

    %% Checking whether a feasible solution was found, and parsing it.
    if exitflag == -2 % No feasible solution
        feasible_solution_found = false;
        guess_attribute = -1;
        error_pos = -1;
        error_neg = -1;
    else
        feasible_solution_found = true;
        if strcmp(lp_type,'dini-max')
            guess_attribute = true_attribute - (x(1:length(uid)) - x(length(uid)+1:2*length(uid)));
        else
            guess_attribute = x(1:length(uid)); 
        end
        error_pos = x(length(uid)+1:length(uid)+num_queries);
        error_neg = x(length(uid)+num_queries+1:length(uid)+2*num_queries);
    end
    
end

%% Determining which subsets of uid's are in each query %%
function queries = get_queries(uid, num_queries)
    global multiplier offset exponent
    queries = zeros(length(uid), num_queries); %Initialize the array
    for query = 1:num_queries
        [m,o,e] = get_moe_indices_from_query(query);
        for id = 1:length(uid)
            queries(id,query) = floor(offset(o) * ...
                ((uid(id) * multiplier(m))^exponent(e)) + 0.5) == ...
                floor(offset(o) * ((uid(id) * multiplier(m))^exponent(e)));
        end
    end
end