%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% visual_search.m
%% This program:
%%  1 Calls the script to compute decriptors
%%  2 Calls the script to compare one image to another
%%  3 Calls the script to visualise the results

%Globals
global verbosity_level;
verbosity_level = 1;
%0 is no debug messages
%1 is short debug messages
%2 is extended debug messages

% Constants
IMAGE_DIRECTORY = 'c:/cvpr/msrc_v2/images';
%IMAGE_DIRECTORY = 'c:/cvpr/test_imgs';
DESCRIPTOR_BASE_DIRECTORY = 'c:/cvpr/computed_descriptors';
OUTPUT_DIRECTORY = 'c:/cvpr/computed_results/9_23_s/';

%Overall loop
for i = 1:30
    vprintf(1,'Running visual_search, i = %d\n',i);
%    COLOR = @(x)vs_compute_rgb_histogram(x,2);
%    FREQ = @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,i),0.2);
%    COLOR_AND_FREQ = @(x)horzcat( COLOR(x), FREQ(x));
    
%    grid_q = 2;
%    h_level = ceil(1.5*grid_q);
%    v_level = grid_q;   
%    GRID_RGB = @(x)vs_grid(x,h_level,v_level, @(x)vs_compute_rgb_histogram(x,4) );
    
    Q = i;
    E = 0;
    GRID_TEXT = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,Q),E) );

    DESCRIPTOR_FUNCTION = GRID_TEXT;
    COMPARATOR_FUNCTION = @vs_L2_norm;
    
    DESCRIPTOR_DIRECTORY = strcat(DESCRIPTOR_BASE_DIRECTORY,'/GRID_TEXT_',num2str(i));

    % Stage 1. Compute descriptors
    % Parameters:
    %  1 Function handle to decriptor generator.
    %  2 Directory containing images to compute descriptors for.
    %  3 Directory to save descriptors in.
    %  5 An argument to decide whether the user should be prompted to overwrite descriptors, or if the program should just do it.
    %       'p' for prompt, 'o' for overwrite, 'i' for ignore and don't recalculate.
    vs_compute(DESCRIPTOR_FUNCTION, IMAGE_DIRECTORY, DESCRIPTOR_DIRECTORY, 'o');

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
    [ compare_result ] = vs_compare(COMPARATOR_FUNCTION, DESCRIPTOR_DIRECTORY, '9_23_s');

    % Stage 3. Display results
    % Parameters:
    %  1 Matrix output by vs_compare
    %  2 Directory containing images
    %  3 Number of images to display
    vs_display(compare_result, IMAGE_DIRECTORY, 10);

    % Stage 4. Plot precision-recall curve
    % Parameters:
    %  1 Matrix output by vs_compare
    %  2+3 Output directory and filename(optional)
    vs_compute_pr(compare_result, OUTPUT_DIRECTORY,strcat('pr_',int2str(i),'.txt'));

end
vprintf(1,'Done!\n');