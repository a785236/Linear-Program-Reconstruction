
%% Runs a series of simulated experiments, iterating over the specified 
%% parameter sets. The results are stored in the local variable 'results' 
%% which should be manually saved. 'results' contains two maps, one with
%% accuracy information, the other with timing. Both are keyed by the 
%% strings output by get_results_key.

%% The file ../data/experiments_dmt.mat was generated using:
% db_size_set = [50:25:150];
% num_primes_set = [1:2:60];
% integer_programming_set = [false];
% error_sigma_set = [2:1:8];
% lp_type = "dmt";
% num_trials=10;
% trials = 1:num_trials;
% dini_bound_set = [0];

%% The file ../data/experiments_dini.mat was generated using:
% db_size_set = [100];
% num_primes_set = [1:2:60];
% integer_programming_set = [false];
% error_sigma_set = [2:1:8]; %2:1:8
% lp_type_set = ["dini"]; %dini
% dini_bound_set = [0:.5:10];%0:.5:10
% num_trials=10; %10
% trials = 1:num_trials;

%% Parameters, and their default settings.
% Choose data file for true uids and inputs
[all_uid, all_true_attribute] = load_data('census');
starting_index = 1;

% Size of dataset
db_size_set = [50];

% Which LP?
lp_type = "dini";

% Error standard deviation
error_sigma_set = [4];

% DiNi error bound (multiplied by the standard deviation). 
% Has no effect if using lp_type = "dmt"
dini_bound_set = [4];

% How many primes? Each prime adds 50 more queries.
num_primes_set = [10];

% Set to true to solve the Integer LP
integer_programming = false;

% How many repetitions?
num_trials = 1;
trials = 1:num_trials;

% Set to true to iterate over the results of the previous execution. 
% Useful for testing.
iterate_results = false;

%% Initializing other variables
simulation = true; % false is unsupported here.
parsed_mechanism_answer_file = '';
mechanism_output_file = '';

time = 0;
total_time = 0;
max_time=0;

if not(iterate_results)
    timing_results = containers.Map;
    accuracy_results = containers.Map;
    results = struct('time',timing_results,'accuracy',accuracy_results);
end

for db_size = db_size_set
    for num_primes = num_primes_set
        for error_sigma = error_sigma_set
            for trial = trials
                for dini_bound = dini_bound_set
                    if iterate_results
                        key = get_results_key(db_size,num_primes,integer_programming,error_sigma,lp_type,trial,dini_bound);
                        time = results.time(key);
                        accuracy = results.accuracy(key);
                    else
                        true_attribute = all_true_attribute(starting_index:starting_index+db_size-1);
                        uid = all_uid(starting_index:starting_index+db_size-1);
                        tic % Starts timer
                        [guess_attribute,~,~] = attack(lp_type, ...
                                                        integer_programming,...
                                                        num_primes,...
                                                        error_sigma,... 
                                                        parsed_mechanism_answer_file,...
                                                        mechanism_output_file,... 
                                                        simulation,...
                                                        uid,...
                                                        true_attribute,...
                                                        dini_bound);
                        time = toc; % Ends timer

                        %% Evaluating success
                        if not(guess_attribute == -1) % No feasible solution found
                            guess_attribute_rounded = round(guess_attribute);
                            accuracy = sum(1 - xor(true_attribute, guess_attribute_rounded)) / length(true_attribute);
                        else
                            accuracy = 0;
                        end
                        
                        %% Recording accuracy and time in results struct
                        key = get_results_key(db_size,num_primes,integer_programming,error_sigma,lp_type,trial, dini_bound);
                        results.time(key) = time;
                        results.accuracy(key) = accuracy;
                    end
                end
            end
        end
    end
end

