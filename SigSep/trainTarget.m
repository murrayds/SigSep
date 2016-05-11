function [W H] = trainTarget(signal, FFTSIZE, K, maxitr, delta)
	%
	% Author :   Dakota Murray
	% Version:  08 November 2015 
	%
	% Trains a set of basis vectors representing the main components of a signal. In the context of the 
	% SigSep class function trains basis vectors for the "target" sound, or the sound 
	% which is to be separated from all other sounds of a mixture.
	%
	% Inputs:
    %   signal :	A time series signal containing the target sound. May also be given as a spectrogram
    %	maxitr :    The maximum number of iterations to be ran 
	%
	% Outputs:
	%

    if nargin < 1
        disp('Please provide a valid Time Series signal or Spectrogram');
    end
    if nargin < 2
        FFTSIZE = 1024;
    end
    if nargin < 3
	K = 10;
    end
    if nargin < 4
	maxitr = 300;
    end

    V = [];
    if size(signal, 2) == 2
        disp('Time Series signal must be a vector!\n Using first channel only');
        signal = signal(:, 1);
    end
    if isvector(signal)
        signal(signal == 0) = 1e-12;
        V = signal2spec(signal, FFTSIZE, FFTSIZE / 4);
    elseif ismatrix(signal)
        V = signal;
    else
        disp('Please enter a Time Series Signal or a Spectrogram for signal!\n');
        return;
    end

    F = size(V, 1);
    T = size(V, 2);

    % Pt(Z)
    H = rand(K, T);

    % P(f|z)
    W = rand(F, K);

    % Pt(Z | F)
    Y = rand(F, T, K);

    %normalize 
    sw = sum(W);
    W = W * diag(1 ./ sw);

    sh = sum(H);
    H = H * diag(1 ./ sh);

    %end initial normalization

    U = ones(F, K);
    Z = ones(F, T, K);
    D = ones(K, T);
    
    %iterate until convergence or max iterations is reached
    for i = 1 : maxitr
    	oldW = W;
    	
    	for z = 1 : K
    		Z(:, :, z) = W(:, z) * H(z, :);
    	end
        Y = bsxfun(@rdivide, Z, sum(Z, 3));
        
        for z = 1 : K
            U(:, z) = sum( Y(:, :, z) .* V, 2);
        end
        W = U  * diag(1 ./ sum(U));
        
        for z = 1 : K
         	D(z, :) = sum(Y(:, :, z) .* V, 1);
        end
        H = D * diag( 1 ./ sum(D));
        
        if sum( sum( abs(W - oldW))) < delta
        	break;
        end
    end

end
