function saveComponentFigure(components, label, filename)
	% remove any singleton dimensions
	W = squeeze(W);

	F = size(W, 1);
	K = size(W, 2);
        
	figure;
	for i = 1 : K
    	    x_axis = ( i - 1) * max(max(W(:, :, 1))) * 2 + (1 - (W(:, i)));
    	    plot( x_axis, 1 : F, 'LineWidth', 1);
    	    hold on;
	end
	title(label);
        savefig(filename)
end
