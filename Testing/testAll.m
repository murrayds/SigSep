% The problem was that I was using the interference for the semi-supervised when I
% should have been using the mixture as the interference
function OUT = testAll(OUT, count, startK, startNfft)
cd ..
setupPath
cd Testing
K = [5, 10, 20, 40];
NFFT = [1024, 2048, 4096, 8192];
algorithm = 'fixed'
iterations = 100;
tests = 5;
trainLen = 3;
testLen = 3;
scenario = '1';
outfile = strcat('output/output_',  algorithm, '_sc', scenario, '.csv');

if nargin < 1
    OUT = zeros(11, 5, 16);
end
if nargin < 2
    count = 1;
end
if nargin < 3
	startK = 1;
end
if nargin < 4
	startNfft = 1;
end
%load the data
[interference, ifs] = audioread('/home/murrayds/sigsep_code/AudioSamples/chimes.wav');
[target, tfs]  = audioread('/home/murrayds/sigsep_code/AudioSamples/voice.wav');
[testTarget, ttfs]  = audioread('/home/murrayds/sigsep_code/AudioSamples/voice.wav');
[testInterference, itfs] = audioread('/home/murrayds/sigsep_code/AudioSamples/chimes.wav');

interference = interference(1:ifs * trainLen, 1);
target = target(1:tfs * trainLen, 1);
testInterference = testInterference(1:ttfs * testLen, 1);
testTarget = testTarget(1:itfs * testLen, 1);

%normalize to zero mean and unit variance
interference = (interference - mean(interference)) / std(interference);
target = (target - mean(target)) / std(target);
mixture = SigSep.createMixture(target, interference);
features = zeros(1, 9);
try
for k = startK : length(K)
	for nfft = startNfft : length(NFFT)
		for i = 1 : tests
			fprintf('Iteration: %d\t nfft: %d\t k: %d\t test: %d\n', count, NFFT(nfft), K(k), i);
            tic;
			[SNR, SDR, SIR, SAR] = runTest(target, interference, mixture, target, interference, NFFT(nfft), K(k), algorithm);
            elapsed = toc;
			features = [SNR(1), SNR(2), SDR(1), SDR(2), SIR(1), SIR(2), SAR(1), SAR(2), elapsed];
            OUT(:, i, count) = [NFFT(nfft), K(k), features];
		end
		count = count + 1;

        %save the current state of the program
        state = [count, k, nfft];
        csvwrite(outfile, OUT);
        save('output/savestate5', 'OUT');
    end
end
exit
catch err
    disp('Error!')
    disp(getReport(err))
    save(outfile, 'OUT');
end
outfile = strcat('output/output_',  algorithm, '_sc2', '.csv');
save(outfile, 'OUT');
end
