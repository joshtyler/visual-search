% EEE3032 2016 Coursework solution
% Joshua Tyler Spring 2016
%
% vs_grid_TEST.m
% This script tests the funtionality of vs_grid.m using MATLABs script-based unit testing framework.

%Constants
width = 320;
height = 240;

% Setup test image
% R G
% B RG
gens = { @(x,y)vs_gen_color(x,y,1,0,0), @(x,y)vs_gen_color(x,y,0,1,0), @(x,y)vs_gen_color(x,y,0,0,1), @(x,y)vs_gen_color(x,y,1,1,0)};
img = vs_gen_four(width, height, 1, gens);

%Setup anonymous function to rehshape image to long vector for for us
%Format [R G B] per row
test_func =  @(x)reshape(x, [], 3);

%% Test 1: Check output for 1x1 grid
% The descriptors are horizontally concatinated.
% Therefore expect each row to be identical and of the format
% [R G B R G B R G B R G B] (top left, top right, bottom left, bottom right)
out = vs_grid(img, 1, 1, test_func);
out = cat(3, reshape(out(:,1),size(img,1),size(img,2)), reshape(out(:,2),size(img,1),size(img,2)), reshape(out(:,3),size(img,1),size(img,2)) ); %Reshape back to image.

assert(isequal(out, img));



%% Test 2: Check 2x2 output size
out = vs_grid(img, 2, 2, test_func);
assert(size(out,1) == (width*height)/4 );
assert(size(out,2) == 4 * 3);

%% Test 3: Check 2x2 output content
out = vs_grid(img, 2, 2, test_func);
for i = 1:size(out,1)
    assert( isequal(out(i,:), [1 0 0, 0 1 0, 0 0 1, 1 1 0]) );
end

