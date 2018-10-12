%% Run this script to perform LP reconstruction using your choice of parameters.
%% If using the real Diffix outputs provided in this repository, rather than
%% simulated answers or answers from another source, uncomment lines 27 and 28
%% of attack.m

%% Getting all the default settings.
[lp_type,integer_programming, num_primes_default, error_sigma_default...
    parsed_mechanism_answer_file, mechanism_output_file, simulation, dini_bound] ...
    = get_default_settings();

%% Which LP to use? (default:'dmt'). 
lp_type = 'dmt'; 
% lp_type = original;
% lp_type = test;
% lp_type = 'dini';
% lp_type = 'dini-max';

%% Controls DiNi error bound (as multiple of error_sigma
% dini_bound = 4;

%% Use ILP or LP? (default:false)
% integer_programming = true;

%% Which data files to use? See load_data() for options. (default:none)
% The following may be used with simulated or real outputs.
% [uid, true_attribute] = load_data('loan_status_2000_3000');
% [uid, true_attribute] = load_data('loan_status_3000_5000');
% [uid, true_attribute] = load_data('loan_status_5000_7000'); 
% [uid, true_attribute] = load_data('loan_status_10000_12000');
%% The following have no corresponding real outputs. Use simulated outputs.
% [uid, true_attribute] = load_data('census'); % Large dataset (n = 5001)
[uid, true_attribute] = load_data('client_id');

%% Choose an mechanism output file to parse. (default:'')
% mechanism_output_file = '../data/mechanism_output_cleaned_2000_3000.txt';
% mechanism_output_file = '../data/mechanism_output_cleaned_3000_5000.txt';
% mechanism_output_file = '../data/mechanism_output_cleaned_5000_7000.txt'; 
% mechanism_output_file = '../data/mechanism_output_cleaned_10000_12000.txt'; 

%% Choose a pre-parsed mechanism output file. (default:'')
% parsed_mechanism_answer_file = 'mechanism_answers_parsed_client_ids_2k_3k.mat';
% parsed_mechanism_answer_file = 'mechanism_answers_parsed_client_ids_3k_5k.mat';
% parsed_mechanism_answer_file = 'mechanism_answers_parsed_client_ids_5k_7k.mat';
parsed_mechanism_answer_file = 'mechanism_answers_parsed_client_ids_10k_12k.mat';

%% Use simulated instead of real answers (default:true)
simulation = true;

%% Chacking that real or simulated outputs are being used.
assert(simulation ...
        | not(isempty(parsed_mechanism_answer_file)) ...
        | not(isempty(mechanism_output_file)), ... 
    'Must use real or simulated outputs.');

%% Invoking the attack code
db_size = length(uid);
true_attribute = true_attribute(1:db_size);
uid = uid(1:db_size);
[guess_attribute, ...
    error_pos, ...
    error_neg, ...
    feasible_solution_found] = attack(lp_type,...
            integer_programming,...
            num_primes_default,...
            error_sigma_default,... 
            parsed_mechanism_answer_file,...
            mechanism_output_file,... 
            simulation,...
            uid,...
            true_attribute,...
            dini_bound);

%% Evaluating success, if a solution was found
if feasible_solution_found
    'Checking against the known answers:'
    guess_attribute_rounded = round(guess_attribute);
    accuracy = sum(1 - xor(true_attribute, guess_attribute_rounded)) / length(true_attribute) %Output intentionally displayed. This is the result.
end