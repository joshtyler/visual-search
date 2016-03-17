%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_compare.m
%% This function calls the comparator generator function passed to it for each descriptor, to calcluate the distance from a random query descriptor.
%% based upon cvpr_visualsearch.m (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)

function [ result ] = vs_compare(compare_function, desciptor_directory, desciptor_function)

% Construct array of file attributes for all .mat files in relevant directory
file_listing = dir( fullfile([desciptor_directory, '/', func2str(desciptor_function),'/*.mat']) );

%Load all descriptors
descriptors=[];
for i = 1 : length(file_listing)
    fprintf('Loading %d of %d.\n',i,  length(file_listing));
    load([desciptor_directory, '/', func2str(desciptor_function), '/',file_listing(i).name],'desc');
    descriptors = [descriptors ; desc];
end

%Pick a random query image
query = floor(rand()* size(descriptors,1));
fprintf('Query image is %s. (index %d)\n',file_listing(query).name(1:end-4), query );

%Compute distances
dists = [];
for i = 1:length(descriptors)
    fprintf('Comparing %d of %d.\n',i,  length(descriptors));
    dists = [dists; compare_function(descriptors(query), descriptors(i))];
end;

%Concatinate names and dists
names = {file_listing.name}';
dists = num2cell(dists);
result = horzcat(dists,names);

%Sort the result in inceasing order of distance
result = sortrows(result,1);

%Ensure that the top result is the query image
if not( strcmp( result{1,2}, file_listing(query).name ) )
    fprintf('Error. Top image is not query image');
end;

return;