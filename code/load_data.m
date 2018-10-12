function [uid, true_attribute] = load_data(data)
    assert(not(isempty(data)), 'Missing input to load_data()');
    if strcmp(data,'loan_status_2000_3000')
        uid_file = '../data/client_id_2000_3000_ordered.mat';
        true_attribute_file = '../data/true_status_client_id_2000_3000_ordered.mat';
        load(uid_file);
        load(true_attribute_file);
        uid = client_id;
        true_attribute = true_status;
    elseif strcmp(data,'loan_status_3000_5000')
        uid_file = '../data/client_id_3000_5000_ordered.mat';
        load(uid_file);
        uid = client_id;
        true_attribute_file = '../data/true_status_client_id_3000_5000_ordered.mat';
        load(true_attribute_file);
        true_attribute = true_status;
    elseif strcmp(data,'loan_status_5000_7000')
        uid_file = '../data/client_id_5000_7000_ordered.mat';
        load(uid_file);
        uid = client_id;
        true_attribute_file = '../data/true_status_client_id_5000_7000_ordered.mat';
        load(true_attribute_file);
        true_attribute = true_status;
    elseif strcmp(data,'loan_status_10000_12000')
        uid_file = '../data/client_id_10000_12000_ordered.mat';
        load(uid_file);
        uid = client_id;
        true_attribute_file = '../data/true_status_client_id_10000_12000_ordered.mat';
        load(true_attribute_file);
        true_attribute = true_status;
    elseif strcmp(data,'loan_status_3000_5000')
        uid_file = '../data/client_id_3000_5000_ordered.mat';
        load(uid_file);
        uid = client_id;
        true_attribute_file = '../data/true_status_client_id_3000_5000_ordered.mat';
        load(true_attribute_file);
        true_attribute = true_status;
    elseif strcmp(data,'census') %% No corresponding real outputs. Use simulation.
        uid_file = '../data/census_uids_sex_1000_6000.mat';
        load(uid_file);
        uid = census_uids;
        true_attribute = census_sexes;
    elseif strcmp(data,'client_id') %% No corresponding real outputs. Use simulation.
        uid = [2500:2600]';
        true_attribute_file = '../data/binary_client_ids_2500_2600.mat';
        load(true_attribute_file);
        true_attribute = true_status;
    else
        error(strcat('Bad input to load_data():', string(data)))
    end
end