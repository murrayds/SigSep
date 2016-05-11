function [SDR, SIR, SAR] = run_experiment(train_target, train_interference, mixture, test_target, test_interference, nfft, k, algorithm)
	S = SigSep(k, nfft);
	if strcmp(algorithm, 'known')
            S.fit(train_target, train_interference, algorithm);
        else
            S.fit(train_target, mixture, algorithm);
        end
        
        target_components = S.targetW
	interference_components = S.interferenceW

	[out_target, out_interference, tspec, ispec, C] = S.separate(mixture);

	%setup values for testing purposes
	len = min([length(testTarget), length(testInterference), length(mixture)]);
	se = [out_target(1 : len) out_interference(1: len)];
	s = [testTarget(1 : len) testInterference(1 : len)];

	testTspec = signal2spec(testTarget(1 : len), nfft, nfft / 4);
	testIspec = signal2spec(testInterference(1 : len), nfft, nfft / 4);
	mspec = signal2spec(mixture(1 : len), nfft, nfft / 4);

	ispec = ispec * diag( 1 ./ sum(ispec));
	tspec = tspec * diag( 1 ./ sum(tspec));

	Mt = tspec - testTspec;
	Mi = ispec - testIspec;

	%run tests
	SNR = [snr(testTspec, tspec - testTspec), snr(testIspec, ispec - testIspec)];
	[SDR, SIR, SAR, perm] = bss_eval_sources(se',s');
end
