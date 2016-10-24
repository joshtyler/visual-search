function F = vs_edge_detect( img, compute_function, strength )
    %Based upon lab week 1 code
    
%    subplot(3,2,1);
%    imgshow(img);
%    title('original image');
    
    %convert to greyscale image
    img = img(:,:,1)*0.30 + img(:,:,2)*0.59 + img(:,:,3)*0.11;
    
%    subplot(3,2,2);
%    imgshow(img);
%    title('greyscale image');
    
    Ky = [1 2 1 ; 0 0 0 ; -1 -2 -1];
    Kx = Ky';
    
    dx = conv2(img, Kx, 'valid');
    dy = conv2(img, Ky, 'valid');
    
    mag = sqrt (dx.^2 + dy.^2);
    mag = mag ./ max(max(mag)); %Normalise to 0 - 1
    
    %atan2 is used to preserve sign information
    %-dy is used to maintain compatability with the library function for test
    theta = atan2(-dy, dx);
    
    
    %atan2 gives results from -pi to pi. Normalise to 0 to 1
    theta = theta + pi;
    theta = theta ./ (2*pi);
    
 %   subplot(3,2,3);
 %   imgshow(mag);
%   title('magnitude ');
    
 %   subplot(3,2,4);
 %   imgshow(theta);
 %   title('theta (raw)');
    
    theta(mag <= strength) = 0.5; %0.5 is the nominal '0' value as 0 is -pi
 
 %   subplot(3,2,5);
  %  imgshow(theta);
  %  title('theta (only strong edges)');

    F = compute_function(theta);



end

