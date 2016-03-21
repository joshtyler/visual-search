
%Constants
img_width = 320;
img_height = 240;

save_directory = 'c:/cvpr/test_imgs';

freq_gens = { @vs_gen_vertical_lines, @vs_gen_horizontal_lines, @vs_gen_white, @vs_gen_chequer };

%r, g, b, rg, rb, gb, black
color_gens = { @(x,y)vs_gen_color(x,y,1,0,0), @(x,y)vs_gen_color(x,y,0,1,0), @(x,y)vs_gen_color(x,y,0,0,1), @(x,y)vs_gen_color(x,y,1,1,0), @(x,y)vs_gen_color(x,y,1,0,1), @(x,y)vs_gen_color(x,y,0,1,1), @(x,y)vs_gen_color(x,y,0,0,0) };

% Generate frequency only test patters
freq = {};
for i = 1 : size(freq_gens,2)
    freq{i} = freq_gens{i}(img_width, img_height);
    writestr = strcat(save_directory,'/freq_',int2str(i),'.png');
    imwrite(freq{i}, writestr);
    
end
% Generate concatinated frequency test patterns
freq_cat = {};
for i = 1 : 4
    freq_cat{i} = vs_gen_four(img_width, img_height, i, freq_gens);
    writestr = strcat(save_directory,'/freq_cat_',int2str(i),'.png');
    imwrite(freq_cat{i}, writestr);
end

%Generate color test patterns
color = {};
for i = 1 : size(color_gens,2)
    color{i} = color_gens{i}(img_width, img_height);
    writestr = strcat(save_directory,'/color_',int2str(i),'.png');
    imwrite(color{i}, writestr);
end

% Generate concatinated color test patterns
color_cat = {};
for i = 1 : 4
    color_cat{i} = vs_gen_four(img_width, img_height, i, color_gens);
    writestr = strcat(save_directory,'/color_cat_',int2str(i),'.png');
    imwrite(color_cat{i}, writestr);
end

% Generate combined color and frequency test patterns
if size(color_gens,2) < size(freq_gens,2)
    smaller = size(color_gens,2);
else
    smaller = size(freq_gens,2);
end

for i = 1 : smaller
    writestr = strcat(save_directory,'/color_freq_',int2str(i),'.png');
    imwrite(imfuse(color{i},freq{i},'blend'), writestr);
end

% Generate combined tiled color and frequency test patterns

for i = 1 : 4
    writestr = strcat(save_directory,'/color_freq_cat_',int2str(i),'.png');
    imwrite(imfuse(color_cat{i},freq_cat{i},'blend'), writestr);
end