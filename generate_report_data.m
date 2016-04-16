%    COLOR = @(x)vs_compute_rgb_histogram(x,2);
%    FREQ = @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,i),0.2);
%    COLOR_AND_FREQ = @(x)horzcat( COLOR(x), FREQ(x));


% GRID_TEXT = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,Q),E) );


%% Global colour histogram

disp('Calculating global color histogram');
comparator_func = @vs_L2_norm;
descriptor_folder = 'GLOBAL_COLOUR_';

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat('global_colour_hist/',query_image{1});
    for i = 1:10
        fprintf('%d ', i);
        descriptor_func = @(x)vs_compute_rgb_histogram(x,i);
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i));
    end
    fprintf('\n');
end
    disp('Finished calculating global color histogram');
    
%% Gridding

disp('Calculating gridding');
comparator_func = @vs_L2_norm;
descriptor_folder = 'GRIDDING_';

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat('gridding/color_hist/',query_image{1});
    for i = 1:15
        fprintf('%d ', i);
        h_level = ceil(1.5*i);
        v_level = i;
        descriptor_func = @(x)vs_grid(x,h_level,v_level, @(x)vs_compute_rgb_histogram(x,4) );
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i));
    end
    fprintf('\n');
end

disp('Finished calculating gridding');

%% Texture (E=0)

disp('Calculating texture (E=0)');
comparator_func = @vs_L2_norm;
descriptor_folder = 'TEXTURE_E0_';

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat('grid_text_hist/E_0/',query_image{1});
    for i = 1:20
        fprintf('%d ', i);
        descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,i),0) );
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i));
    end
    fprintf('\n');
end

disp('Finished calculating texture');

%% Texture (Q=16)

disp('Calculating texture (Q=16)');
comparator_func = @vs_L2_norm;
descriptor_folder = 'TEXTURE_Q16_';

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat('grid_text_hist/Q_16/',query_image{1});
    for i = 0:10
        fprintf('%d ', i);
        E = i * 0.1;
        descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),E) );
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i));
    end
    fprintf('\n');
end

disp('Finished calculating texture');

%% Concatenation

disp('Calculating concatenation');
comparator_func = @vs_L2_norm;
descriptor_folder = 'CONCAT_';

texture_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
color_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat('concat/',query_image{1});
    for i = [ 0.1:0.1:1  1.5 2 3 4 8 10 20]
        fprintf('%f ', i);
        descriptor_func = @(x)horzcat( texture_func(x) .* i, color_func(x));
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},num2str(i));
    end
    fprintf('\n');
end

disp('Finished calculating concatenation');

%% Distance measures

disp('Calculating distance measures');
comparator_func = @vs_L2_norm;
descriptor_folder = 'DIST_';

%texture_func = @(x)vs_grid(x,3,2, @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,16),0) );
%color_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );
%descriptor_func = @(x)horzcat( texture_func(x) .* 4, color_func(x));
descriptor_func = @(x)vs_grid(x,3,2, @(x)vs_compute_rgb_histogram(x,4) );

for query_image = {'9_23_s' , '13_1_s'}
    fprintf('Query image: %s. Begin: ', query_image{1});
    output_folder = strcat('dist_measure/',query_image{1});
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
        vs_visual_search(output_folder, descriptor_folder, descriptor_func, comparator_func, false, query_image{1},looper{1});
    end
    fprintf('\n');
end

disp('Finished calculating distance measures');