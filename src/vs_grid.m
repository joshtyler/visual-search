%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_compare.m
%% This function splits an image into a grid, and calls the comparator function for each block.


function F = vs_grid( img, h_level, v_level, comparator_function )

    h_size = size(img,2);
    v_size = size(img,1);

    h_thresh = [0, int32(h_size/h_level : h_size/h_level : h_size) ];
    v_thresh = [0, int32(v_size/v_level : v_size/v_level : v_size) ];

    F=[];
    for i = 1: v_level
        for j = 1: h_level
            cur_img = img( (v_thresh(i) + 1) : v_thresh(i+1) , (h_thresh(j) +1) : h_thresh(j+1), : );
            result = comparator_function(cur_img);
            F = [F , result];
        end
    end
    
end

