
%% Converts (m,o,e) indices to a query index
function query = get_query_from_moe_indices(m, o, e)
    global multiplier offset;
    max_m = length(multiplier);
    max_o = length(offset);
    query = max_m*max_o*(e-1) + max_m*(o-1) + m;
end
