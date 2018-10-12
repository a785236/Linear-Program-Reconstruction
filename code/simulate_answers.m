%% Simulates Diffix answers on random queries.
function mechanism_answer = simulate_answers(num_queries,true_attribute, queries, error_sigma)
    % Gaussian noise
    error_mean = 0;
    mechanism_answer = zeros(num_queries,1);
    noise = round(normrnd(error_mean,error_sigma, num_queries,1));
    % Low count suppression
    thresh_mean = 4;
    thresh_min = 2;
    thresh_std = 0.5;
    for q = 1:num_queries
        answer_no_noise = sum(queries(:,q) .* true_attribute); 
        noisy_thresh = max(thresh_min, normrnd(thresh_mean, thresh_std));
        if answer_no_noise >= noisy_thresh % Does diffix use > or >=?
            mechanism_answer(q) = max(0,answer_no_noise + noise(q)); % No bucket suppression
        end
        
    end
end