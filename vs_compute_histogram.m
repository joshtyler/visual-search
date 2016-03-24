function H = vs_compute_histogram( img, max, Q )
% Q is the quantisation level
% Max is the largest number to encode

    if not( size(img,3) == 1 )
        error('Image does not have one dimension');
    end;

    bin_edges = linspace(0, max, Q + 1);
	H = histogram(img(:),bin_edges);
    H = H.Values;
    
    H = H ./ sum(H);
    
end

