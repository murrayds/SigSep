function metrics = run_experiment(scenario, bins_list, k_list, alg_list, runs)
    disp('Starting New Experiment')
    currentDir = pwd;
    scenarioPath = strcat(pwd, '/scenarios/scenario', num2str(scenario), '/');

    [trainTarget, tfs] = audioread(strcat(scenarioPath, 'train_target.wav'));
    [trainMixture, mfs] = audioread(strcat(scenarioPath, 'train_mixture.wav'));
    [testMixture, tmfs] = audioread(strcat(scenarioPath, 'test_mixture.wav'));

    min_len = min([length(trainTarget), length(trainMixture), length(testMixture)]);
    
    trainTarget = trainTarget(1:min_len);
    trainMixture = trainMixture(1:min_len);
    testMixture = testMixture(1:min_len);

    % normalize to zero mean and unit variance 
    trainTarget = (trainTarget - mean(trainTarget)) / std(trainTarget);
    trainMixture = (trainMixture - mean(trainMixture)) / std(trainMixture);
    testMixture = (testMixture - mean(testMixture)) / std(testMixture);

    
    outputDir = strcat(pwd, '/output/scenario', num2str(scenario), '/');
    mkdir(outputDir)
    metrics = zeros(6, length(bins_list) * length(k_list) * length(alg_list) * runs);

    count = 1;
    for alg = alg_list
        for bins = bins_list
            for k = k_list
                for run = 1:runs
                    fprintf('Run: %d\t K: %d\t Bins: %d\t alg: %d\n', run, k, bins, alg)
	            S = SigSep(k, bins);

  	 	    % training phase
 		    tic;
	            S.fit(trainTarget, trainMixture, alg);
  		    trainElapsed = toc;
			
 		    % separate and get output signals 
		    tic;
		    [outTarget, outInterf, outTspec, outIspec, phase] = S.separate(testMixture);
		    sepElapsed = toc;

		    % setup output directory structure
		    audioDir = strcat(outputDir, num2str(run), '/audio/');
                    imageDir = strcat(outputDir, num2str(run), '/images/');
                    dataDir = strcat(outputDir, num2str(run), '/data/');

		    mkdir(audioDir);
		    mkdir(imageDir);
		    mkdir(dataDir);
	
	            metaData = strcat('_sc', num2str(scenario), '_alg', num2str(alg), '_bins', num2str(bins), '_k', num2str(k), '_run', num2str(run));
                    
                    audiowrite(strcat(audioDir, 'est_target', metaData, '.wav'), outTarget, tmfs)
                    audiowrite(strcat(audioDir, 'est_interf', metaData, '.wav'), outInterf, tmfs) 

		    % save output image files
	            saveSpectrogramFigure(outTspec, strcat('Target: ', metaData), strcat(imageDir, 'est_target_spec', metaData, '.png'));
	            saveSpectrogramFigure(outTspec, strcat('Interf: ', metaData), strcat(imageDir, 'est_interf_spec', metaData, '.png'));
  		    saveComponentFigure(S.targetW, strcat('Target: ', metaData), strcat(imageDir, 'est_interf_components', metaData, '.png'));
  		    saveComponentFigure(S.interferenceW, strcat('Interf: ', metaData), strcat(imageDir, 'est_interf_components', metaData, '.png'));

		    % save raw spectrogram data 
		    save(strcat(dataDir, 'rawData', metaData, '.mat'), 'outTspec', 'outIspec', 'phase');
		   
		    metrics(:, count) = [scenario, alg, bins, k, trainElapsed, sepElapsed];
		    count = count + 1;
    		    
                end 
            end
        end 
    end
    csvwrite(strcat(outputDir, 'scenario', num2str(scenario), '_results.csv'), metrics);
        
end
