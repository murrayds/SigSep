function [tW, iW] = trainInterference_SemiSupervisedUnfixed(V, priorW, priorH, priorK,  maxitr, delta)
 	%
    % Author : Dakota Murray
    % Version: 26 June 2014
    %
    % Implements the semi-supervised algorithm where the interference model is trained from 
    % a mixture by using the target model as a starting point and training components for 
    % all parts of the signal not related to the target. In this algorithm the target model
    % is fixed.
    %
    % This algorithm is designated 2 or 'fixed'
    % Inputs:
    %   V       : A spectrogram of the provided training data
    %   maxitr  : This function implements an interative algorithmn. maxitr deifnes the maximum number 
    %             of iterations to calculate. 
    %
    % Outputs:
    %   W       : W is the set of basis vectors representing the training data V
    %


    K = priorK * 2;
    
    F = size(V, 1);
    T = size(V, 2);

    % Pt(Z)
    H = rand(K, T);
    sh = sum(H);
    H = H * diag(1 ./ sh);
    H(1 : priorK, :) = priorH;

    % P(f|z)    
    W = rand(F, K);
    sw = sum(W);
    W = W * diag(1 ./ sw);
    W(:, 1 : priorK) = priorW;

    % Pt(F | Z)
    Y = rand(F, T, K);
    
    U = ones(F, K);
    Z = ones(F, T, K);
    D = ones(K, T);
    
    for i = 1 : maxitr
    	oldW = W;

    	% Update Pt(z|f);
    	for z = 1 : K
    		Z(:, :, z) = W(:, z) * H(z, :);
    	end
        Y = bsxfun(@rdivide, Z, sum(Z, 3));
        
        % Update Ps(f | z)
        for z = 1 : K
            U(:, z) = sum( Y(:, :, z) .* V, 2);
        end
        W = U  * diag(1 ./ sum(U));

        % Update Pt(z)
        for z = 1 : K
         	D(z, :) = sum(Y(:, :, z) .* V, 1);
        end
        H = D * diag( 1 ./ sum(D));

        if sum( sum( abs(W - oldW))) < delta
        	break;
        end
    end
    tW = W(:, 1 : priorK);
    iW = W(:, priorK + 1 : size(W, 2));
end
