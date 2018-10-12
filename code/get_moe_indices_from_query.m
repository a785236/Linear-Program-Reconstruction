
%% Converts a query index into (m,o,e) indices
function [m,o,e] = get_moe_indices_from_query(query)
    global multiplier offset;
    q = query;
    max_m = length(multiplier);
    max_o = length(offset);
    e = idivide_unsafe(q - 1, max_m*max_o) + 1;
    q = q - max_m*max_o*(e-1);
    o = idivide_unsafe(q - 1, max_m) + 1;
    q = q - max_m*(o-1);
    m = q;
    query_check = get_query_from_moe_indices(m,o,e);
    assert(query_check == query, 'Error'); 
end


%% Reimpliments idivide, but without type checks.
function quotient = idivide_unsafe(a,b)
    quotient = (a - rem(a,b))/b;
end
