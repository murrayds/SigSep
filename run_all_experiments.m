function run_all_experiments
    try
    warning('off', 'all')
    % setup algorithm variables
    bins_list = [1024];
    k_list = [5];
    alg_list = [0, 1, 2];
    runs = 3;

    % get the directory structure reset and ready to go
    setupPath
    delete('eval_temp/*');
        	
    scenarios = 1:1;

    for sce = scenarios
        run_experiment(sce, bins_list, k_list, alg_list, runs);
    end

    quit;
    catch 
        quit;
    end
end

