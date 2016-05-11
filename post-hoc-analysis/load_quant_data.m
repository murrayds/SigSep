data = csvread('aggregate_data.csv', 1, 0);
SCENARIOS = data(:, 1);
ALGORITHMS = data(:, 2);
NFFT = data(:, 3);
COMPONENTS = data(:, 4);
OPS = data(:, 9);
TPS = data(:, 10);
IPS = data(:, 11);
APS = data(:, 12);
TRAINTIME = data(:, 13);
SEPTIME = data(:, 14);
RESPONSE = [OPS TPS IPS APS TRAINTIME SEPTIME];
PARAMS = [SCENARIOS, ALGORITHMS, NFFT, COMPONENTS];

