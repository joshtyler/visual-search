%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% visual_search.m
%% This program:
%%  1 Calls the script to compute decriptors
%%  2 Calls the script to compare one image to another
%%  3 Calls the script to visualise the results

% Constants
IMAGE_DIRECTORY = 'c:/cvpr/msrc_v2/images';
DESCRIPTOR_DIRECTORY = 'c:/cvpr/computed_descriptors';

DESCRIPTOR_FUNCTION = @vs_extract_random;
COMPARATOR_FUNCTION = @vs_L2_norm;

% Stage 1. Compute descriptors
% Parameters:
%  1 Function handle to decriptor generator.
%  2 Directory containing images to compute descriptors for.
%  3 Directory to save descriptors in.
%      N.B. Images will be saved inside a subfolder with the same name as the generator function
vs_compute(DESCRIPTOR_FUNCTION, IMAGE_DIRECTORY, DESCRIPTOR_DIRECTORY);

% Stage 2. Compare descriptors
% Parameters:
%  1 Function handle to comparitor function
%  2 Directory containing descriptors
%  3 Descriptor function (for locating subfolder)
% Return values:
%  1 Matrix where:
%       Col 1: Ordered distance measures
%       Col 2: File names
%   N.B. Top result will be query image.
[ compare_result ] = vs_compare(COMPARATOR_FUNCTION, DESCRIPTOR_DIRECTORY, DESCRIPTOR_FUNCTION);