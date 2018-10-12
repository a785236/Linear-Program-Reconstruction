
%% Parses (cleaned) Aircloak output file.
%% I manually cleaned the file by removing the first and last couple lines
%% and deleting any queries with 'answer => ,'
function mechanism_answer = parse_aircloak_answers(num_queries, aircloak_output_file)
    fileID = fopen(aircloak_output_file);
    query_pattern = '{ %*s %*s %*s power => %f mult => %f offset => %f %*s %*s %*s answer => %d sig => %s }';
    aircloak_scanner = textscan(fileID, query_pattern, ...
        'Delimiter', {',','\r','\n','\b','\t'}, ...
        'MultipleDelimsAsOne',1, ...
        'TreatAsEmpty','"failed"',...
        'EmptyValue', -1);
    fclose(fileID);
    fclose('all');

    %% Storing the aircloak outputs on the queries.
    mechanism_answer = zeros(num_queries,1); 
    for q = 1:length(aircloak_scanner{1})
        e_val = aircloak_scanner{1}(q);
        if ismember(e_val,0:10) % Checking for integral exponents
            continue;
        end
        m_val = aircloak_scanner{2}(q);
        o_val = aircloak_scanner{3}(q);
        answer = aircloak_scanner{4}(q);
        [m,o,e] = get_moe_indices_from_moe_values(m_val,o_val,e_val);
        query = get_query_from_moe_indices(m,o,e);
        mechanism_answer(query) = answer;
    end
end

%% %%%%%%%%%%%%%%%%%%%% %% 
%% Private Function Definitions %%
%% %%%%%%%%%%%%%%%%%%%% %% 

%% Converts (m,o,e) values to (m,o,e) indices.
function [m,o,e] = get_moe_indices_from_moe_values(m_val,o_val,e_val)
    global multiplier offset exponent;
    m = find(multiplier == m_val, 1); % Specifying 1 output is unnecessary. The values should be unique.
    o = find(abs(offset - o_val) < 0.001, 1);
    e = find(abs(exponent-e_val) < 0.0001, 1);
end