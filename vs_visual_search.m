%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_visual_search.m
%% This function:
%%  1 Calls the script to compute decriptors
%%  2 Calls the script to compare one image to another
%%  3 Calls the script to visualise the results
%%  4 Calls the script to generate PR stats.

function vs_visual_search(output_subdirectory, descriptor_subdirectory, descriptor_function, comparator_function, display, query_image, iteration)

%Globals
global verbosity_level;
verbosity_level = 0;
%0 is no debug messages
%1 is short debug messages
%2 is extended debug messages

% Constants
IMAGE_DIRECTORY = 'c:/cvpr/msrc_v2/images';
%IMAGE_DIRECTORY = 'c:/cvpr/test_imgs';
DESCRIPTOR_BASE_DIRECTORY = 'c:/cvpr/computed_descriptors/';
OUTPUT_BASE_DIRECTORY = 'c:/cvpr/computed_results/';

vprintf(1,'Begin visual_search.\n');

output_directory = strcat(OUTPUT_BASE_DIRECTORY,output_subdirectory,'/');
descriptor_directory = strcat(DESCRIPTOR_BASE_DIRECTORY,descriptor_subdirectory,iteration,'/');

% Stage 1. Compute descriptors
% Parameters:
%  1 Function handle to decriptor generator.
%  2 Directory containing images to compute descriptors for.
%  3 Directory to save descriptors in.
%  5 An argument to decide whether the user should be prompted to overwrite descriptors, or if the program should just do it.
%       'p' for prompt, 'o' for overwrite, 'i' for ignore and don't recalculate.
vs_compute(descriptor_function, IMAGE_DIRECTORY, descriptor_directory, 'i');

% Stage 2. Compare descriptors
% Parameters:
%  1 Function handle to comparator function
%  2 Directory containing descriptors
%  3 File name of the desired query file (no extension)
%       N.B. Argument 4 is optional, if omitted, a random image will be selected.
% Return values:
%  1 Matrix where:
%       Col 1: Ordered distance measures
%       Col 2: File names
%       Col 3: Boolean - true if relevant.
%   N.B. Top result will be query image.
[ compare_result ] = vs_compare(comparator_function, descriptor_directory, query_image);

% Stage 3. Display results
% Parameters:
%  1 Matrix output by vs_compare
%  2 Directory containing images
%  3 Number of images to display
if display == true
    vs_display(compare_result, IMAGE_DIRECTORY, 15);
end

% Stage 4. Plot precision-recall curve
% Parameters:
%  1 Matrix output by vs_compare
%  2 Boolean. Display graph if true.
%  3+4 Output directory and filename(optional)
vs_compute_pr(compare_result, display, output_directory, strcat('pr_',iteration,'.txt'));

vprintf(1,'Done!\n');

end