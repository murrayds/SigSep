data = csvread('qualitative-scenarios-results.csv', 1, 0);
SCENARIOS = data(:, 1);
ALGORITHMS = data(:, 2);
NFFT = data(:, 3);
COMPONENTS = data(:, 4);
TRAINTIME = data(:, 5);
SEPTIME = data(:, 6);
RESPONSE = [TRAINTIME SEPTIME];
PARAMS = [SCENARIOS, ALGORITHMS, NFFT, COMPONENTS];

