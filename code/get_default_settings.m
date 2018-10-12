function [lp_type, integer_programming, num_primes, error_sigma, ...
    parsed_mechanism_answer_file, mechanism_output_file, simulation, dini_bound] ...
    = get_default_settings()
    
    lp_type = 'dmt'; % Which LP to use? 'dmt', 'dini', 'original', or 'test'
    integer_programming = false; % Use LP or Integer LP
    num_primes = 25; % a number between 1 and 168
    error_sigma = 4; % Noise standard deviation
    parsed_mechanism_answer_file = '';
    mechanism_output_file=''; % should be non-empty if the above is '' and simulation == false.
    simulation = true;
    dini_bound = 4;
end