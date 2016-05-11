figure


groupings = ones(240, 1);

x = 1;
for i = unique(SCENARIOS)
   for j = unique(ALGORITHMS)
       groupings(SCENARIOS == i & ALGORITHMS == j) = x;
       x = x + 1;
   end
end
    
boxplot(APS, groupings)

set(gca, 'XTickLabel', {'S1*Alg0','S1*Alg2','S1*Alg2','S2*Alg0','S2*Alg1',...
    'S2*Alg2','S3*Alg0','S3*Alg1','S3*Alg2','S4*Alg0',...
    'S4*Alg1','S4*Alg2','S5*Alg0','S5*Alg1','S5*Alg2'});

set(gca, 'YLim', [0, 100])
xlabel('Scenario/Algorithm Combinations')
ylabel('Artifact Perceptual Score (/100)')

