% Wrapper for vs_visual_search
% This file allows for easy execution of vs_visual_search, without needing to modify the function

% Constants
DESCRIPTOR_BASE_DIRECTORY = 'c:/cvpr/computed_descriptors/';
OUTPUT_BASE_DIRECTORY = 'c:/cvpr/computed_results/';

descriptor_directory = strcat(DESCRIPTOR_BASE_DIRECTORY,'TEMP');
output_directory = strcat(OUTPUT_BASE_DIRECTORY,'TEMP/');

%Comparator functions
%Uncomment desired function
%comparator_func = @vs_L1_norm;
comparator_func = @vs_L2_norm;
%comparator_func = @vs_L2_norm_squared;
%comparator_func = @vs_L_Inf_norm;
%comparator_func = @(x,y)vs_mahalanobis_distance(x,y,descriptor_directory); %Must enable PCA to run


%Descriptor functions
%Global RGB Hist
%descriptor_func = @(x)vs_compute_rgb_histogram(x,4);
%Gridded RGB Hist
%descriptor_func = @(x)vs_grid(x,h_level,v_level, @(x)vs_compute_rgb_histogram(x,4) );
%Edge orientation histogram
%descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
%Concatenated descriptors
texture_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
color_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );
descriptor_func = @(x)horzcat( texture_func(x) .* 4, color_func(x));

%PCA
enable_pca = false; %Make true to enable PCA
eigenvalue_energy = 0.99; %Preserve 99% of eigenvector energy

%Display
enable_display = true; %Make false to disable output

%Query image
query_image = '13_1_s';

%Average precision calcuation
%Set to a value less than the items in the dataset for ap at a recall value
%Otherwise this does global ap
ap_at = 99999; 


%Parameters:
% 1 output directory
% 2 descriptor base directory
% 3 descriptor function
% 4 comparator function
% 5 display flag (displays plots if true)
% 6 query image. text string of filename to use as query
% 7 iteration. This is used for scripting to set the filename differently on sequential iterations
% 8 pca_flag. If true, pca will be performed
% 9 pca_param. Eigenvector energy propertion to presserve
% 10 ap_at. Returned value is average precision at this number. If larger than number of images in set, it will be overall average precision.

%Clear descriptor directory for fresh calculation.
%Comment this line out for repeated tests, but MUST be uncommented to recalculate descriptors
delete (fullfile( [descriptor_directory, '/*.mat']) );

avg_precision = vs_visual_search(output_directory, descriptor_directory, descriptor_func, comparator_func, enable_display, query_image, '', enable_pca, eigenvalue_energy, ap_at);

fprintf('Done. Average precision: %.3f.\n',avg_precision);