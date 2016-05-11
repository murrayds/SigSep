function [groups, group_names] = get_groups(data, group_values, param_index, response_index)
    groups = [];
    group_names = {};
    for i = group_values
        groups = [groups;data(response_index, data(param_index, :) == i)];
        group_names{end + 1} = num2str(i);
    end
    groups = groups'; 
end
