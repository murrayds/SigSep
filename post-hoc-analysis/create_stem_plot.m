figure
possNFFTs = [1024, 2048, 4096, 8192];

colors = ['r', 'b', 'g', 'm'];
color_index = 1;
for i = possNFFTs
    index = NFFT == i;
    stem3(ALGORITHMS(index), SCENARIOS(index), TRAINTIME(index), 'Color', colors(color_index), 'MarkerSize', 8);
    color_index = color_index + 1;
    hold on
end
hold off

set(gca, 'XTick', [0:1:2])
set(gca, 'XLim', [-0.25, 2.25])
set(gca, 'YTick', [1:1:5])
set(gca, 'YLim', [-0.25, 5.25])
set(gca, 'ZLIM', [0, 100])

xlabel('Algorithm Variant');
ylabel('Scenario');
zlabel('Training Time (seconds)');
legend('1024', '2048', '4096', '8192', 'Location', 'NorthEast')