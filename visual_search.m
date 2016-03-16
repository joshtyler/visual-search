%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% visual_search.m
%% This program:
%%  1 Calls the script to compute decriptors
%%  2 Calls the script to compare one image to another
%%  3 Calls the script to visualise the results


%% Stage 1. Compute descriptors
%% Parameters:
%%  1 Function pointer to decriptor generator
%%  2 Directory containing images to compute descriptors for
%%  3 Directory to save descriptors in
vs_compute(globalRGBHistogram, IMAGE_DIRECTORY, DESCRIPTOR_DIRECTORY);