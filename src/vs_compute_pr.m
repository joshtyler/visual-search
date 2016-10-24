function average_precision =  vs_compute_pr( compare_result, display, output_directory, pr_filename, ap_filename, ap_at )

%Remove query image from results
compare_result = compare_result( 2:end , :);

num_relevant_images = sum( cell2mat(compare_result(:, 3)) );
%Number in each msrc sample set, minus one for query
vprintf(1,'Found %d relevant images.\n',num_relevant_images);


%Create a matrix containing the indices of the valid images.
precision = [];
recall = [];
index = [];
validity_mat = cell2mat(compare_result(:,3));
total_relevant_imgs = sum( validity_mat);
average_precision = 0;
ap_ctr = 0;
for n = 1:size(compare_result,1)
    cur_num_relevant_imgs = sum( validity_mat( 1:n));
    % Precision is the number of images which are relevant in a result set
    % Therefore if in ten returned images, 5 were relevant, precision = 0.5
    cur_precision = cur_num_relevant_imgs / n;
    % Recall is simply the percentage of the total number of relevant images returned at any point
    cur_recall = cur_num_relevant_imgs / total_relevant_imgs;
    
    %When we have a vertical line, we don't need every single point
    %Just the first and last. The vertical line will be interpolated
    write_flag = true;
    %If we are not at the beginnning or end of the matrix
    if n > 1 && n < size(compare_result,1)
       %If the current result is invalid
       if validity_mat(n) == 0
            %And the next result is also invalid
            if validity_mat(n+1) == 0
                %We do not need to store that result
                write_flag = false;
            end
        end
    end
    
    if write_flag
        precision = [precision , cur_precision ];
        recall = [ recall, cur_recall ];
        index = [index , n];
    end
    if (ap_ctr < ap_at) && (validity_mat(n) == 1)
        average_precision = average_precision + cur_precision;
        ap_ctr = ap_ctr + 1;
    end
end

if(ap_at > total_relevant_imgs)
    assert(ap_ctr == total_relevant_imgs);
else
    assert(ap_ctr == ap_at);
end

average_precision = average_precision / ap_ctr;

%Calculate pure chance stats
pure_chance_precision = num_relevant_images / size(compare_result,1);
pure_chance_precision = [ pure_chance_precision pure_chance_precision];
pure_chance_recall = [ 0 1 ];

if display == true
    %If no figure exists, create a new one. Otherwise clear existing.
    valid_figs = findall(0,'Type','Figure','Name', 'P-R Graph');
    if isempty(valid_figs)
        figure('Name', 'P-R Graph');
    else
        figure(valid_figs(1)); %Set Results figure to active
        clf;
    end;
    hold on;
    plot(recall, precision, 'b.-');
    plot(pure_chance_recall,pure_chance_precision, 'r');
    xlabel('Recall');
    ylabel('Precision');
    title('P-R Graph');
    axis([0 1 0 1.05]); %// Adjust axes for better viewing
    grid;
end

if nargin > 3
    % Create output directory if it does not alreay exist
    if not(exist(output_directory, 'dir'))
        mkdir(output_directory);
    end;
    dists = cell2mat(compare_result(:,1))';
    output_name = strcat(output_directory,'/',pr_filename);
    file = fopen(output_name,'w');
    fprintf(file,'recall,precision,chance_precision\n');
    %Output main series
    out_mat1 = vertcat(recall, precision);
    fprintf(file,'%.5f,%.5f,\n',out_mat1);
    %Output pure chance series
    out_mat2 = vertcat(pure_chance_recall, pure_chance_precision);
    fprintf(file,'%.5f,,%.5f,\n',out_mat2);
    fclose(file);
    
    %Output average precision
    output_name = strcat(output_directory,'/',ap_filename);
    file = fopen(output_name,'w');
    fprintf(file,'%.10f\n',average_precision);
    fclose(file);
end