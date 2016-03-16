%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_compute.m
%% This function calls the descriptor generator function passed to it for each image in the dataset.
%% based upon cvpr_computedescriptors.m (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)

function vs_compute(compute_function, image_directory, desciptor_directory)

% Create output directory if it does not alreay exist
output_directory = [desciptor_directory,'/', func2str(compute_function)];
mkdir(output_directory);

% Construct array of file attributes for all .bmp files
file_listing = dir( fullfile([image_directory,'/*.bmp']) );

fprintf('Found %d images.\n', length(file_listing));

for i = 1 : length(file_listing)

    img = imread( [image_directory,'/', file_listing(i).name] );
    
    fprintf('Computing %d of %d.\n',i,  length(file_listing));
    
    % Normalise
    img = double(img) ./255;
    desc = compute_function(img);
    % Save the descriptor to a subfolder in the desctiptor directory
    % Make the name of the subfolder the same as the compute funtion
    % Make the file name the same as the image name, but .mat instead of .bmp
    save([output_directory, '/',  file_listing(i).name(1: end-4), '.mat' ],'desc');
    
end;

fprintf('Finished computing %s descriptors.\n',func2str(compute_function));


return;