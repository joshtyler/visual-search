% Constants
DESCRIPTOR_BASE_DIRECTORY = 'c:/cvpr/computed_descriptors/';
OUTPUT_BASE_DIRECTORY = 'c:/cvpr/computed_results/';


%% Global colour histogram

disp('Calculating global color histogram');
comparator_func = @vs_L2_norm;
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'GLOBAL_COLOUR_');

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat(OUTPUT_BASE_DIRECTORY,'global_colour_hist/',query_image{1},'/');
    for i = 1:10
        fprintf('%d ', i);
        descriptor_func = @(x)vs_compute_rgb_histogram(x,i);
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i),false,1,1000);
    end
    fprintf('\n');
end
    disp('Finished calculating global color histogram');
    
%% Gridding

disp('Calculating gridding');
comparator_func = @vs_L2_norm;
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'GRIDDING_');

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat(OUTPUT_BASE_DIRECTORY,'gridding/color_hist/',query_image{1},'/');
    for i = 1:15
        fprintf('%d ', i);
        h_level = ceil(1.5*i);
        v_level = i;
        descriptor_func = @(x)vs_grid(x,h_level,v_level, @(x)vs_compute_rgb_histogram(x,4) );
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i),false,1,1000);
    end
    fprintf('\n');
end

disp('Finished calculating gridding');

%% Texture (E=0)

disp('Calculating texture (E=0)');
comparator_func = @vs_L2_norm;
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'TEXTURE_E0_');

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat(OUTPUT_BASE_DIRECTORY,'grid_text_hist/E_0/',query_image{1},'/');
    for i = 1:20
        fprintf('%d ', i);
        descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,i),0) );
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i),false,1,1000);
    end
    fprintf('\n');
end

disp('Finished calculating texture');

%% Texture (Q=16)

disp('Calculating texture (Q=16)');
comparator_func = @vs_L2_norm;
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'TEXTURE_Q16_');

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat(OUTPUT_BASE_DIRECTORY,'grid_text_hist/Q_16/',query_image{1},'/');
    for i = 0:10
        fprintf('%d ', i);
        E = i * 0.1;
        descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),E) );
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i),false,1,1000);
    end
    fprintf('\n');
end

disp('Finished calculating texture');

%% Concatenation

disp('Calculating concatenation');
comparator_func = @vs_L2_norm;
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'CONCAT_');

texture_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
color_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat(OUTPUT_BASE_DIRECTORY,'concat/',query_image{1},'/');
    for i = [ 0.1:0.1:1  1.5 2 3 4 8 10 20]
        fprintf('%f ', i);
        descriptor_func = @(x)horzcat( texture_func(x) .* i, color_func(x));
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i),false,1,1000);
    end
    fprintf('\n');
end

disp('Finished calculating concatenation');

%% Distance measures

disp('Calculating distance measures');
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'DIST_');

descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat(OUTPUT_BASE_DIRECTORY,'dist_measure/',query_image{1},'/');
    for looper = {'L1', 'L2', 'L2_sq', 'L_Inf', 'Mahal'}
        fprintf('%s ', looper{1});
        if strcmp(looper{1},'L1')
            comparator_func = @vs_L1_norm;
        elseif strcmp(looper{1},'L2')
            comparator_func = @vs_L2_norm;
        elseif strcmp(looper{1},'L2_sq')
            comparator_func = @vs_L2_norm_squared;
        elseif strcmp(looper{1},'L_Inf')
            comparator_func = @vs_L_Inf_norm;
        elseif strcmp(looper{1},'Mahal')
            desc_path = strcat(DESCRIPTOR_BASE_DIRECTORY,'DIST_',looper{1});
            comparator_func = @(x,y)vs_mahalanobis_distance(x,y,desc_path);
        else
            error('Invalid looper option');
        end
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},looper{1},true,0.99,1000);
    end
    fprintf('\n');
end

disp('Finished calculating distance measures');

%% Distance measures (no PCA)

disp('Calculating distance measures (no PCA)');
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'DIST_NO_PCA_');

descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat(OUTPUT_BASE_DIRECTORY,'dist_measure_no_pca/',query_image{1},'/');
    for looper = {'L1', 'L2', 'L2_sq', 'L_Inf'}
        fprintf('%s ', looper{1});
        if strcmp(looper{1},'L1')
            comparator_func = @vs_L1_norm;
        elseif strcmp(looper{1},'L2')
            comparator_func = @vs_L2_norm;
        elseif strcmp(looper{1},'L2_sq')
            comparator_func = @vs_L2_norm_squared;
        elseif strcmp(looper{1},'L_Inf')
            comparator_func = @vs_L_Inf_norm;
        else
            error('Invalid looper option');
        end
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},looper{1},false,0.99,1000);
    end
    fprintf('\n');
end

disp('Finished calculating distance measures (no PCA)');

%% Colour grid PCA

disp('Calculating colour grid PCA');
descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'COLOUR_GRID_PCA_');
comparator_func = @vs_L2_norm;

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat(OUTPUT_BASE_DIRECTORY,'pca/grid_color_hist/',query_image{1},'/');
    for i = [0:11 9.5, 9.9]
        fprintf('%d ', i);
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i),true, i*0.1,1000);
    end
    fprintf('\n');
end

%Create dimension report
report = [];
index = 1;
for i = [1:9 9.5, 9.9 11]
    path = strcat(DESCRIPTOR_BASE_DIRECTORY,'COLOUR_GRID_PCA_',num2str(i),'/1_1_s.mat');
    load(path,'desc');
    
    %We use the 11 value for E=1 to avoid the floating error of the E=1 discarding negligable dimensions
    if i == 11
        num = 1;
    else
        num = i/10;
    end
    
    current = [ num ; size(desc,2) ];
    report = [report , current];
    
    index = index + 1;
end

total_dims = repmat(report(2,size(report,2)),1,size(report,2));
percent_of_orig = ( report(2,:) ./ total_dims ) .*100;

report = [report ; percent_of_orig];

file = fopen(strcat(OUTPUT_BASE_DIRECTORY,'pca/grid_color_hist/dim_report.txt'),'w');
fprintf(file,'e,dims,percent\n');
fprintf(file,'%.2f,%i,%.1f\\%%\n',report);

disp('Finished calculating colour grid PCA');

%% Global MAP Calc

disp('Calculating global MAP');
comparator_func = @vs_L2_norm;
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'GLOBAL_MAP_');

texture_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
color_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );

%Create matrices to store concatinated stats for each looper val
map_cat_mat = [ 1:20];
global_map = [];

looper_options = {'gch', 'gridch', 'eoh', 'concat'};

for looper = looper_options
    fprintf('%s\n', looper{1});
    if strcmp(looper{1},'gch')
        descriptor_func = @(x)vs_compute_rgb_histogram(x,4);
    elseif strcmp(looper{1},'gridch')
        descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );
    elseif strcmp(looper{1},'eoh')
        descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
    elseif strcmp(looper{1},'concat')
        descriptor_func = @(x)horzcat( texture_func(x) .* 4, color_func(x));
    else
        error('Invalid looper option');
    end
    %Matrix to store mean average precision stats.
    map_mat = [ zeros(1,20) ] ;
    global_map_sum = 0;
    for set = 1:20
        %Count no. of files in series
        D = dir(['C:\cvpr\msrc_v2\Images\',num2str(set),'_*']);
        num_images = length(D(not([D.isdir])));
        cur_map_sum = 0;
        fprintf('Set: %i. %i images: ', set, num_images);
        for i = 1:num_images
            query_image = strcat(num2str(set),'_',num2str(i),'_s');
            output_folder = strcat(OUTPUT_BASE_DIRECTORY,'temp/',query_image,'/');
            fprintf('%d ', i);
            cur_map_sum = cur_map_sum + vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image,looper{1},false,1,1000);
        end

        map_mat(1,set) = cur_map_sum / num_images;
        global_map_sum = global_map_sum + cur_map_sum;
        fprintf('\n');
    end
    global_map = [global_map , (global_map_sum / 591)]; % No. images in database.
    map_cat_mat = [map_cat_mat ; map_mat ];
    

end
    mkdir(strcat(OUTPUT_BASE_DIRECTORY,'global_stats/'));
    file = fopen(strcat(OUTPUT_BASE_DIRECTORY,'global_stats/map_overall.txt'),'w');
    str = [];
    for i = 1: size(looper_options,2)
        str = strcat(str,',',looper_options{1,i});
    end
    fprintf(file,'set%s\n',str);
    %Output main series
    format = '%i';
    for i = 1 : size(looper_options,2)
        format = strcat(format,',%.2f');
    end
    format = strcat(format,'\n');
    fprintf(file,format,map_cat_mat);
    
    %Output global stats
    format = 'Global';
    for i = 1 : size(looper_options,2)
        format = strcat(format,',%.2f');
    end
    format = strcat(format,'\n');
    fprintf(file,format,global_map);
    fclose(file);

disp('Finished calculating global MAP');

%% Global MAP Calc at 10

disp('Calculating global MAP at 10');
comparator_func = @vs_L2_norm;
descriptor_folder = strcat(DESCRIPTOR_BASE_DIRECTORY,'GLOBAL_MAP_');

texture_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
color_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );

%Create matrices to store concatinated stats for each looper val
map_cat_mat = [ 1:20];
global_map = [];

looper_options = {'gch', 'gridch', 'eoh', 'concat'};

for looper = looper_options
    fprintf('%s\n', looper{1});
    if strcmp(looper{1},'gch')
        descriptor_func = @(x)vs_compute_rgb_histogram(x,4);
    elseif strcmp(looper{1},'gridch')
        descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );
    elseif strcmp(looper{1},'eoh')
        descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
    elseif strcmp(looper{1},'concat')
        descriptor_func = @(x)horzcat( texture_func(x) .* 4, color_func(x));
    else
        error('Invalid looper option');
    end
    %Matrix to store mean average precision stats.
    map_mat = [ zeros(1,20) ] ;
    global_map_sum = 0;
    for set = 1:20
        %Count no. of files in series
        D = dir(['C:\cvpr\msrc_v2\Images\',num2str(set),'_*']);
        num_images = length(D(not([D.isdir])));
        cur_map_sum = 0;
        fprintf('Set: %i. %i images: ', set, num_images);
        for i = 1:num_images
            query_image = strcat(num2str(set),'_',num2str(i),'_s');
            output_folder = strcat(OUTPUT_BASE_DIRECTORY,'temp/',query_image,'/');
            fprintf('%d ', i);
            cur_map_sum = cur_map_sum + vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image,looper{1},false,1,10);
        end

        map_mat(1,set) = cur_map_sum / num_images;
        global_map_sum = global_map_sum + cur_map_sum;
        fprintf('\nCurrent map: %.2f\n', cur_map_sum / num_images);
    end
    fprintf('Current global MAP: %.2f', (global_map_sum / 591) );
    global_map = [global_map , (global_map_sum / 591)]; % No. images in database.
    map_cat_mat = [map_cat_mat ; map_mat ];
    

end

    mkdir(strcat(OUTPUT_BASE_DIRECTORY,'global_stats/'));
    file = fopen(strcat(OUTPUT_BASE_DIRECTORY,'global_stats/map_at_10.txt'),'w');
    str = [];
    for i = 1: size(looper_options,2)
        str = strcat(str,',',looper_options{1,i});
    end
    fprintf(file,'set%s\n',str);
    %Output main series
    format = '%i';
    for i = 1 : size(looper_options,2)
        format = strcat(format,',%.2f');
    end
    format = strcat(format,'\n');
    fprintf(file,format,map_cat_mat);
    
    %Output global stats
    format = 'Global';
    for i = 1 : size(looper_options,2)
        format = strcat(format,',%.2f');
    end
    format = strcat(format,'\n');
    fprintf(file,format,global_map);
    fclose(file);

disp('Finished calculating global MAP at 10');
