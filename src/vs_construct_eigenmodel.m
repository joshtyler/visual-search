%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_construct_eigenmodel.m
%% This function constructs an eigenmodel from the data, and optionally projects it to a lower dimensionality
%% Based upon methods introduced in EEE3032 Lab Worksheet 2(c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)

function vs_construct_eigenmodel(descriptor_directory, energy_to_keep)

% Construct array of file attributes for all .mat files in relevant directory
file_listing = dir( fullfile([descriptor_directory, '/*.mat']) );

%Load all descriptors
descriptors=[];
vprintf(1,'Found %d files. Loading.\n', length(file_listing));
for i = 1 : length(file_listing)
    vprintf(2,'Loading %d of %d.\n',i,  length(file_listing));
    load([descriptor_directory, '/', file_listing(i).name],'desc');
    descriptors = [descriptors ; desc];
end

%Calculate mean of each dimension
%For a matrix mean returns a row vector containing the average of each column.
avg = mean( descriptors );

%Repeat matrix to pad it to size of original.
avg = repmat(avg,size(descriptors,1),1);

%Subtract every point in the descriptor from the mean
desc_norm = descriptors - avg;

%Compute covariance matrix
C = (desc_norm' * desc_norm) ./ size(desc_norm,1);

%Calculate eigenmodel
if energy_to_keep <= 1.0
    %If we want to keep a certain energy
    val = eig(C);
    val = flipud(val); %Flip so largest value is at top
    total_energy = sum(sum(val));
    current_energy = val(1);
    no_to_keep = 1;
    while current_energy < total_energy * energy_to_keep
        no_to_keep = no_to_keep + 1;
        current_energy = current_energy + val(no_to_keep);
    end
    %Eigs keeps n strongest vectors
    [vct, val] = eigs(C,no_to_keep);
else
    %Keep all dims
    [vct, val] = eig(C);
    
end

%Sort into descending order
[val,I] = sort(diag(val),'descend');
vct = vct(:, I); % This rearranges the cols of vct for the order output by sort()


%Project data to lower space
proj_data = desc_norm * vct;

%Overwrite descriptors with new data
for i = 1 : length(file_listing)
    vprintf(2,'Saving %d of %d.\n',i,  length(file_listing));
    desc = proj_data(i,:);
    save([descriptor_directory, '/', file_listing(i).name],'desc');
end

%Save eigen vector and values to descriptor directory
% Create output directory if it does not alreay exist
eigen_model_directory = [descriptor_directory, '/eigen_model'];
if not(exist(eigen_model_directory, 'dir'))
    mkdir(eigen_model_directory);
end;
save([eigen_model_directory, '/eigen_model.mat'],'vct','val');
return;