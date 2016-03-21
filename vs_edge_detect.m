function F = vs_edge_detect( img, compute_function )
    %Based upon lab week 1 code
    % Modify to only return edges with a certain strength!!
    
    subplot(3,2,1);
    imgshow(img);
    
    %convert to greyscale image
    img = img(:,:,1)*0.30 + img(:,:,2)*0.59 + img(:,:,3)*0.11;
    
    subplot(3,2,2);
    imgshow(img);
    
    Ky = [1 2 1 ; 0 0 0 ; -1 -2 -1];
    Kx = [1 0 -1 ; 2 0 -2 ; 1 0 -1];
    
    dx = conv2(img, Kx, 'same');
    dy = conv2(img, Ky, 'same');
    
    mag = sqrt (dx.^2 + dy.^2);
    
    %theta = atan(dy ./ dx);
    
    theta = atan2(dy, dx);
    
    theta = theta ./ max(max(theta));
    
    subplot(3,2,3);
    imgshow(mag);
    
    subplot(3,2,4);
    imgshow(theta);
    
    theta(mag < 0.2) = 0;
 
    subplot(3,2,5);
    imgshow(theta);

    F = compute_function(theta);



end

