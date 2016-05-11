% need to have multcompare results, m
[c, m] = multcompare(anovan_stats{2}, 'Dimension', [1, 2]);
m = reshape(m, 5, []);
m = m(:, 1:3);

rownames = {'Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5'};
nfft_names = {'x1024', 'x2048', 'x4096', 'x8192'};
comp_names = {'x5', 'x10', 'x15', 'x20'};
alg_names = {'Supervised', 'SS_Fixed', 'SS_Unfixed'};

T = array2table(m, 'RowNames', rownames, 'VariableNames', alg_names);
writetable(T, 'performance_table_scenarioXalgortihm_tps.csv')