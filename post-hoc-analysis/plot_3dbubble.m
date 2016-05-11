var = NFFT;
var(var == 1024) = 1;
var(COMPONENTS == 10) = 2;
var(COMPONENTS == 15) = 3;
var(COMPONENTS == 20) = 4;

grid on
figure
scatter3(ALGORITHMS, SCENARIOS, var, TPS * 8, ALGORITHMS)
set(gca, 'XTick', [0:1:2])
set(gca, 'XLim', [-0.5, 2.5])
set(gca, 'YTick', [1:1:5])
set(gca, 'YLim', [-0.25, 5.25])
set(gca, 'ZLim', [0.25, 4.25])
set(gca, 'ZTick', [1:1:4])
set(gca, 'ZTickLabel', {'5', '10', '15', '20'})

xlabel('Algorithm');
ylabel('Scenario');
zlabel('NFFT');
