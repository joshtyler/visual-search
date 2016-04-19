% EEE3032 2016 Coursework solution
% Joshua Tyler Spring 2016
%
% vs_grid_TEST.m
% This script tests the funtionality of vs_grid.m using MATLABs script-based unit testing framework.

%Constants
width = 320;
height = 240;
gap = 4;

IMAGE_DIRECTORY = 'c:/cvpr/msrc_v2/images';

% Setup test images
horiz = vs_gen_horizontal_lines(width, height, gap);
horiz = cat(3, horiz, horiz, horiz); %Make RGB

vert = vs_gen_vertical_lines(width, height, gap);
vert = cat(3, vert, vert, vert); %Make RGB

chequer = vs_gen_chequer(width, height, gap);
chequer = cat(3, chequer, chequer, chequer); %Make RGB


path = strcat(IMAGE_DIRECTORY,'/10_10_s.bmp');
real = imread(path);
%convert to greyscale image
real_gray = real(:,:,1)*0.30 + real(:,:,2)*0.59 + real(:,:,3)*0.11;

% Define dummy function
dummy_function = @(x) x;


%% Test 1: Check operation against library function with horizontal pattern
theta = vs_edge_detect(horiz, dummy_function, 0); % 0 to keep all edges

[mag_standard, theta_standard] = imgradient(horiz(:,:,1), 'sobel');
%Normalise
theta_standard = theta_standard + 180;
theta_standard = theta_standard ./360;
%Ignore outside border of image, as imgradient just replicates it from nearest cells!
theta_standard = theta_standard( 2 : size(theta_standard,1)-1 , 2 : size(theta_standard,2)-1 );

assert( isequal(theta, theta_standard) );

%% Test 2: Check operation against library function with vertical pattern
theta = vs_edge_detect(vert, dummy_function, 0); % 0 to keep all edges

[mag_standard, theta_standard] = imgradient(vert(:,:,1), 'sobel');
%Normalise
theta_standard = theta_standard + 180;
theta_standard = theta_standard ./360;
%Ignore outside border of image, as imgradient just replicates it from nearest cells!
theta_standard = theta_standard( 2 : size(theta_standard,1)-1 , 2 : size(theta_standard,2)-1 );

assert( isequal(theta, theta_standard) );

%% Test 3: Check operation against library function with chequer pattern
theta = vs_edge_detect(chequer, dummy_function, 0); % 0 to keep all edges

[mag_standard, theta_standard] = imgradient(chequer(:,:,1), 'sobel');
%Normalise
theta_standard = theta_standard + 180;
theta_standard = theta_standard ./360;
%Ignore outside border of image, as imgradient just replicates it from nearest cells!
theta_standard = theta_standard( 2 : size(theta_standard,1)-1 , 2 : size(theta_standard,2)-1 );

assert( isequal(theta, theta_standard) );

%% Test 4: Check operation against library function with real image
theta = vs_edge_detect(real, dummy_function, 0); % 0 to keep all edges

[mag_standard, theta_standard] = imgradient(real_gray, 'sobel');
%Normalise
theta_standard = theta_standard + 180;
theta_standard = theta_standard ./360;
%Ignore outside border of image, as imgradient just replicates it from nearest cells!
theta_standard = theta_standard( 2 : size(theta_standard,1)-1 , 2 : size(theta_standard,2)-1 );

diff = (theta - theta_standard);
diff = diff .^2;
diff = sum(sum(diff));
diff = sqrt(diff);

assert( diff < 10e-10 );

close all;

