%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_compute.m
%% This function calls the descriptor generator function passed to it for each image in the dataset.
%% based upon cvpr_computedescriptors.m (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)

function vs_compute(compute_function, image_directory, output_directory, prompt, pca_flag, pca_param)

% Check if output directory is empty
if  any(size(dir( fullfile( [output_directory, '/*.mat']) ),1))
    if prompt == 'p'
        action = input('Output directory contains at least 1 .mat file.\nDelete all .mat files and recalculate?\n','s');
    elseif prompt == 'i'
        action = 'n';
        vprintf(1,'Descriptors already exist. Not overwriting.\n');
    elseif prompt == 'o'
        action = 'y';
        vprintf(1,'Descriptors already exist. Overwriting.\n');
    else
        error('Invalid prompt option');
    end;
    if (action == 'n') || (action == 'N')
        return;
    elseif (action == 'y') || (action == 'Y')
        delete (fullfile( [output_directory, '/*.mat']) );
    else
        error('Invalid input.\n');
    end;
end;

% Create output directory if it does not alreay exist
if not(exist(output_directory, 'dir'))
    mkdir(output_directory);
end;

% Construct array of file attributes for all .bmp files
file_listing = dir( fullfile([image_directory,'/*.bmp']) );

vprintf(1,'Found %d images. Loading.\n', length(file_listing));

for i = 1 : length(file_listing)

    img = imread( [image_directory,'/', file_listing(i).name] );
    %Force greyscale images to RGB
    if size(img,3) == 1
        img = cat(3,img,img,img);
    end
    
    vprintf(2,'Computing %d of %d.\n',i,  length(file_listing));
    
    % Normalise
    img = double(img) ./255;
    desc = compute_function(img);
    % Save the descriptor to a subfolder in the desctiptor directory
    % Make the name of the subfolder the same as the compute funtion
    % Make the file name the same as the image name, but .mat instead of .bmp
    save([output_directory, '/',  file_listing(i).name(1: end-4), '.mat' ],'desc');
    
end;

if pca_flag == true
    vs_construct_eigenmodel(output_directory, pca_param);
end

vprintf(1,'Finished computing %s descriptors.\n',func2str(compute_function));


return;