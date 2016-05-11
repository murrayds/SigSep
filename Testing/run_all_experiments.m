function run_all_experiments
    
    warning('off', 'all');
    % setup algorithm variables
    bins_list = [1024, 2048, 4096, 8192];
    k_list = [5, 10, 15, 20];
    alg_list = [0, 1, 2];
    runs = 5;

    % get the directory structure reset and ready to go
    setupPath
    delete('eval_temp/*');
    rmdir('output/*');
        	
    scenarios = 1:8;

    for sce = scenarios
        run_experiment(sce, bins_list, k_list, alg_list, runs);
    end


end

