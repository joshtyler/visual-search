% EEE3032 2016 Coursework solution
% Joshua Tyler Spring 2016
%
% vs_construct_eigenmodel_TEST.m
% This script tests the funtionality of vs_grid.m using MATLABs script-based unit testing framework.
% The script is tested against the pca code provided by John Collomosse (J.Collomosse@surrey.ac.uk)
% The EEE3032 Lab code must be added to the search path for this to work.

descriptor_directory = 'C:/cvpr/temp/eigen_desc';
IMAGE_DIRECTORY = 'c:/cvpr/msrc_v2/images';
descriptor_func = @(x)vs_compute_rgb_histogram(x,2);

% Generate some desciptors
vs_compute(descriptor_func, IMAGE_DIRECTORY, descriptor_directory, 'o');

% Load descriptors
file_listing = dir( fullfile([descriptor_directory, '/*.mat']) );
descriptors=[];
for i = 1 : length(file_listing)
    load([descriptor_directory, '/', file_listing(i).name],'desc');
    descriptors = [descriptors ; desc];
end

% Eigen build expects obs to be one per column, with rows as independant variables
% Therefore we must flip our descriptors matrix
test_model = Eigen_Build(descriptors');

% Construct eigen model
vs_construct_eigenmodel(descriptor_directory);

% Load eigen data
load([descriptor_directory, '/eigen_model/eigen_model.mat'],'vct','val');

% Reload eigened descriptors
processed_descriptors=[];
for i = 1 : length(file_listing)
    load([descriptor_directory, '/', file_listing(i).name],'desc');
    processed_descriptors = [processed_descriptors ; desc];
end

%% Test 1: Check full output eigen model against Eigen_Build
%Check vct and val are same dims as model
assert(isequal(size(test_model.vct), size(vct)));
assert(isequal(size(test_model.val),size(val)));

%Check vct and val are equal (within a tolerance)
tolerance = 10e-10;
assert( sum(sum(abs(test_model.vct - vct))) < tolerance);
assert( sum(sum(abs(test_model.val - val))) < tolerance);

%% Test 2: Check reprocessed descriptors against Eigen_Project

% Project descriptors to eigenmodel
test_model_projected_descriptors = Eigen_Project(descriptors', test_model);

test_model_projected_descriptors = test_model_projected_descriptors';

% Check dimensions
assert(isequal(size(test_model_projected_descriptors), size(processed_descriptors)));

% Check content < tolerance
tolerance = 10e-10;
assert( sum(sum(abs(test_model_projected_descriptors - processed_descriptors))) < tolerance);


%% Test 3: Check eigen model and data against Eigen_Deflate

% Regenerate desciptors
vs_compute(descriptor_func, IMAGE_DIRECTORY, descriptor_directory, 'o');

%Reprocess data set keeping energy of 0.5
vs_construct_eigenmodel(descriptor_directory,0.5);

%Deflate test model using energy of 0.5
test_model = Eigen_Deflate(test_model,'keepf',0.5);

% Load eigen data
load([descriptor_directory, '/eigen_model/eigen_model.mat'],'vct','val');

%Eigen_Deflate sometimes produces the negative of my eienvectors, but this is okay, as direction does not matter
% If this is the case we will negate the test model vector to allow for this
if sign(test_model.vct) ~= sign(vct)
    test_model.vct = test_model.vct .* -1;
end;


%Check vct and val are same dims as model
assert(isequal(size(test_model.vct), size(vct)));
assert(isequal(size(test_model.val),size(val)));

%Check vct and val are equal (within a tolerance)
tolerance = 10e-10;
assert( sum(sum(abs(test_model.vct - vct))) < tolerance);
assert( sum(sum(abs(test_model.val - val))) < tolerance);

% Reload eigened descriptors
processed_descriptors=[];
for i = 1 : length(file_listing)
    load([descriptor_directory, '/', file_listing(i).name],'desc');
    processed_descriptors = [processed_descriptors ; desc];
end

% Project descriptors to eigenmodel
test_model_projected_descriptors = Eigen_Project(descriptors', test_model);

test_model_projected_descriptors = test_model_projected_descriptors';

% Check dimensions
assert(isequal(size(test_model_projected_descriptors), size(processed_descriptors)));

% Check content < tolerance
tolerance = 10e-10;
assert( sum(sum(abs(test_model_projected_descriptors - processed_descriptors))) < tolerance);

