%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% visual_search.m
%% This program:
%%  1 Calls the script to compute decriptors
%%  2 Calls the script to compare one image to another
%%  3 Calls the script to visualise the results

%% Constants
IMAGE_DIRECTORY = 'c:/cvpr/msrc_v2/images';
DESCRIPTOR_DIRECTORY = 'c:/cvpr/computed_descriptors';

%% Stage 1. Compute descriptors
%% Parameters:
%%  1 Function handle to decriptor generator.
%%  2 Directory containing images to compute descriptors for.
%%  3 Directory to save descriptors in.
%%      N.B. Images will be saved inside a subfolder with the same name as the generator function
vs_compute(@vs_extract_random, IMAGE_DIRECTORY, DESCRIPTOR_DIRECTORY);

%% Stage 2. Compare descriptors
%% Parameters:
%%  1 Function handle to comparitor function
%%  2 Directory containing descriptors
%% Return values:
%%  1 Matrix of distance measures