function H =  vs_compute_rgb_histogram( img, Q )

	% INPUT: img, a normalised RGB image (pixels range 0-1)
	% INPUT: Q, the level of quantization of the RGB space e.g. 4

	% First, create qimg, an image where RGB are normalised in range 0 to (Q-1)
	% We do this by dividing each pixel value by 256 (to give range 0 - just
	% under 1) and then multiply this by Q, then drop the decimal point.
    
    if not( size(img,3) == 3 )
        error('Image does not have three dimensions');
    end;

	qimg=(double(img).*255)./256;
	qimg=floor(qimg.*Q);
	% Now, create a single integer value for each pixel that summarises the
	% RGB value. We will use this as the bin index in the histogram.
	bin = qimg(:,:,1)*Q^2 + qimg(:,:,2)*Q^1 + qimg(:,:,3);
	% 'bin' is a 2D image where each 'pixel' contains an integer value in
	% range 0 to Q^3-1 inclusive.
	% We will now use Matlab's hist command to build a frequency histogram
	% from these values. First, we have to reshape the 2D matrix into a long
	% vector of values.
	vals=reshape(bin,1,size(bin,1)*size(bin,2));
	% Now we can use hist to create a histogram of Q^3 - 1 bins.
    % These bins are evenly spaced from 0 to Q^3 - 1
    bin_edges = linspace(0, (Q^3 -1), Q^3);
	H = histcounts(vals,bin_edges);
	% It is convenient to normalise the histogram, so the area under it sum
	% to 1.
	H = H ./sum(H);



end

