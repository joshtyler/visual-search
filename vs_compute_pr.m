function  vs_compute_pr( compare_result, output_directory, output_filename )

%Remove query image from results
compare_result = compare_result( 2:end , :);

num_relevant_images = sum( cell2mat(compare_result(:, 3)) );
%Number in each msrc sample set, minus one for query
vprintf(1,'Found %d relevant images.\n',num_relevant_images);


%Create a matrix containing the indices of the valid images.
valid_locations = [];
for i = 1:size(compare_result,1)
    if compare_result{i,3} == 1
        valid_locations = [ valid_locations , i];
    end
end

% Precision is the number of images which are relevant in a result set
% Therefore if in ten returned images, 5 were relevant, precision = 0.5
% This formula works, because for each cell is is:
%   [number of relevant images] / [number of images before that image was returned]
% Therefore if the fifth relevant image, was in location 10, precision = 0.5
precision = (1: num_relevant_images) ./ valid_locations;

% Recall is simply the percentage of the total number of relevant images returned at any point
recall = (1: num_relevant_images) ./ num_relevant_images;

%If no figure exists, create a new one. Otherwise clear existing.
valid_figs = findall(0,'Type','Figure','Name', 'P-R Graph');
if isempty(valid_figs)
    figure('Name', 'P-R Graph');
else
    figure(valid_figs(1)); %Set Results figure to active
    clf;
end;
pure_chance_precision = precision; %Create a matrix of same dims
pure_chance_precision(:) = num_relevant_images / size(compare_result,1);
hold on;
plot(recall, precision, 'b.-');
plot(recall,pure_chance_precision, 'r');
xlabel('Recall');
ylabel('Precision');
title('P-R Graph');
axis([0 1 0 1.05]); %// Adjust axes for better viewing
grid;

if nargin > 2
    % Create output directory if it does not alreay exist
    if not(exist(output_directory, 'dir'))
        mkdir(output_directory);
    end;
    output_name = strcat(output_directory,'/',output_filename);
    file = fopen(output_name,'w');
    fprintf(file,'recall,precision,chance_precision\n');
    out_mat = vertcat(recall, precision, pure_chance_precision);
    fprintf(file,'%.10f,%.10f,%.10f\n',out_mat);

    fclose(file);
end