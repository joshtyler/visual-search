function H = vs_compute_histogram( img, Q )
% Q is the quantisation level
% Max is the largest number to encode
max = 1.0; %Expect normalised input

    if not( size(img,3) == 1 )
        error('Image does not have one dimension');
    end;

    bin_edges = linspace(0, max, Q + 1);
	H = histcounts(img(:),bin_edges);
    
    H = H ./ sum(H);
    
end

