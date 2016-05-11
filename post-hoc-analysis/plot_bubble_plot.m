scatter(ALGORITHMS, SCENARIOS, TPS * 50, NFFT, 's', 'LineWidth', 10)
set(gca, 'XTick', [0:1:2])
set(gca, 'XLim', [-0.25, 2.25])
set(gca, 'YTick', [1:1:5])
set(gca, 'YLim', [-0.25, 5.25])

pot_legend('1024', '2048', '4096', '8192')
