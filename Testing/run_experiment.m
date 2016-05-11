function metrics = run_experiment(scenario, bins_list, k_list, alg_list, runs)
    disp('Starting New Experiment')
    currentDir = pwd;
    scenarioPath = strcat(pwd, '/scenarios/scenario', num2str(scenario), '/');

    [trainTarget, tfs] = audioread(strcat(scenarioPath, 'train_target.wav'));
    [trainInterf, ifs] = audioread(strcat(scenarioPath, 'train_interference.wav'));
    [testTarget, ttfs] = audioread(strcat(scenarioPath, 'test_target.wav'));
    [testInterf, tifs] = audioread(strcat(scenarioPath, 'test_interference.wav'));

    min_len = min([length(trainTarget), length(trainInterf), length(testTarget), length(testInterf)]);
    
    trainTarget = trainTarget(1:min_len);
    trainInterf = trainInterf(1:min_len);
    testTarget = testTarget(1:min_len);
    testInterf = testInterf(1:min_len);


    % normalize to zero mean and unit variance 
    trainTarget = (trainTarget - mean(trainTarget)) / std(trainTarget);
    trainInterf = (trainInterf - mean(trainInterf)) / std(trainInterf);
    testTarget = (testTarget - mean(testTarget)) / std(testTarget);
    testInterf = (testInterf - mean(testInterf)) / std(testInterf);

    mixture = SigSep.createMixture(testTarget, testInterf);
    
    outputDir = strcat(pwd, '/output/scenario', num2str(scenario), '/');
    mkdir(outputDir)
    mixSpec = signal2spec(mixture, 1024, 256);
    saveSpectrogramFigure(mixSpec, 'Mixture', strcat(outputDir, 'mixture_spextrogram.png'))
    
    metrics = zeros(14, length(bins_list) * length(k_list) * length(alg_list) * runs);

    count = 1;
    for alg = alg_list
        for bins = bins_list
            for k = k_list
                for run = 1:runs
                    fprintf('Run: %d\t K: %d\t Bins: %d\t alg: %d\n', run, k, bins, alg)
	            S = SigSep(k, bins);

  	 	    % training phase
 		    tic;
                    if alg == 0
			S.fit(trainTarget, trainInterf, alg);
		    else
			S.fit(trainTarget, mixture, alg);
		    end
  		    trainElapsed = toc;
			
 		    % separate and get output signals 
		    tic;
		    [outTarget, outInterf, outTspec, outIspec, phase] = S.separate(mixture);
		    sepElapsed = toc;

		    % setup output directory structure
		    audioDir = strcat(outputDir, num2str(run), '/audio/');
                    imageDir = strcat(outputDir, num2str(run), '/images/');
                    dataDir = strcat(outputDir, num2str(run), '/data/');

		    mkdir(audioDir);
		    mkdir(imageDir);
		    mkdir(dataDir);
	
	            metaData = strcat('_sc', num2str(scenario), '_alg', num2str(alg), '_bins', num2str(bins), '_k', num2str(k), '_run', num2str(run));
                     
 		    min_len = min([length(outTarget), length(testTarget), length(testInterf)]);
		    temp_testTarget = testTarget(1:min_len);
  		    temp_testInterf = testInterf(1:min_len);
 		    outTarget = outTarget(1:min_len);

		    tempDir = strcat(audioDir, 'temp/')
		    mkdir(tempDir)
	  	    
    		    audiowrite(strcat(tempDir, 'test_target.wav'), temp_testTarget, ttfs)
    		    audiowrite(strcat(tempDir, 'test_interference.wav'), temp_testInterf, tifs)
		    % have to overwrite original files becase of PEASS reasons...
 	            % save output audio files 
		    audiowrite(strcat(audioDir, 'est_target', metaData, '.wav'), outTarget, ttfs);
		    audiowrite(strcat(audioDir, 'est_interf', metaData, '.wav'), outInterf, tifs);

		    % save output image files
	            saveSpectrogramFigure(outTspec, strcat('Target: ', metaData), strcat(imageDir, 'est_target_spec', metaData, '.png'));
	            saveSpectrogramFigure(outIspec, strcat('Interf: ', metaData), strcat(imageDir, 'est_interf_spec', metaData, '.png'));
  		    saveComponentFigure(S.targetW, 'Target', strcat(imageDir, 'est_target_components', metaData, '.fig'));
  		    saveComponentFigure(S.interferenceW, 'Interf', strcat(imageDir, 'est_interf_components', metaData, '.fig'));

		    % save raw spectrogram data 
		    save(strcat(dataDir, 'rawData', metaData, '.mat'), 'outTspec', 'outIspec', 'phase');
		   
    	            origFiles = {...
 			strcat(tempDir, 'test_target.wav');...
			strcat(tempDir, 'test_interference.wav');
		    };
                    estFile = strcat(audioDir, 'est_target', metaData, '.wav'); 

		    options.segmentationFactor = 1;
		    options.destDir = strcat(pwd, '/eval_temp/');
                    res = PEASS_ObjectiveMeasure(origFiles, estFile, options);

		    metrics(:, count) = [scenario, alg, bins, k, res.SDR, res.ISR, res.SIR, res.SAR, res.OPS, res.TPS, res.IPS, res.APS, trainElapsed, sepElapsed];
			
		    count = count + 1;
    		    
                end 
            end
        end 
    end
    csvwrite(strcat(outputDir, 'scenario', num2str(scenario), '_results.csv'), metrics);
        
end
