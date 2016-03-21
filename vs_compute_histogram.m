function H = vs_compute_histogram( img, Q )
% Q is the quantisation level

    if not( size(img,3) == 1 )
        error('Image does not have one dimension');
    end;

    H = hist(img(:), Q);
    
    H = H ./ sum(H);
    
end

