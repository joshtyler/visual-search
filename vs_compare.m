%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_compare.m
%% This function calls the comparator generator function passed to it for each descriptor, to calcluate the distance from a random query descriptor.
%% based upon cvpr_visualsearch.m (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)

function [ result ] = vs_compare(compare_function, desciptor_directory, desciptor_function, query_name)

% Construct array of file attributes for all .mat files in relevant directory
file_listing = dir( fullfile([desciptor_directory, '/', func2str(desciptor_function),'/*.mat']) );

%Load all descriptors
descriptors=[];
vprintf(1,'Found %d files. Loading.\n', length(file_listing));
for i = 1 : length(file_listing)
    vprintf(2,'Loading %d of %d.\n',i,  length(file_listing));
    load([desciptor_directory, '/', func2str(desciptor_function), '/',file_listing(i).name],'desc');
    descriptors = [descriptors ; desc];
end

%Select the index of the query image
%Find input string if provided, otherwise choose random
if nargin > 3
    str = strcat(query_name,'.mat');
    query = find(strcmp({file_listing.name}, str)==1);
    
    if isempty(query)
        error('Error. Query file %s not found.\n', str);
    end;
else
    query = floor(rand()* size(descriptors,1));
end;

fprintf(1,'Query image is %s. (index %d)\n',file_listing(query).name(1:end-4), query );

%Compute distances
dists = [];
vprintf(1,'Found %d descriptors. Comparing.\n', size(descriptors,1));
for i = 1:size(descriptors,1)
    vprintf(2,'Comparing %d of %d.\n',i,  size(descriptors,1));
    dists = [dists; compare_function(descriptors(query,:), descriptors(i,:))];
end;



%Concatinate names and dists
names = {file_listing.name}';
dists = num2cell(dists);
result = horzcat(dists,names);

%Sort the result in inceasing order of distance
result = sortrows(result,1);

%We might have the case that some results are exactly as good as the query.
%This makes sure the query is top if that is the case
cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
cells = cellfun(cellfind(file_listing(query).name),result);
index = find(cells(:,2));
if isempty(index)
    error('Index not found!');
elseif size(index) > 1
    error('Index found multiple times!');
end;
%Check if weight of query is identical to top weight, and if so swap.
if result{index,1} == result{1,1}
    temp = result{index,2};
    result{index,2} = result{1,2};
    result{1,2} = temp;
end;

%Ensure that the top result is the query image
if not( strcmp( result{1,2}, file_listing(query).name ) )
    error('Error. Top image is not query image');
end;

return;