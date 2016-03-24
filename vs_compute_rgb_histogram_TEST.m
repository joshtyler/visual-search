% EEE3032 2016 Coursework solution
% Joshua Tyler Spring 2016
%
% vs_compute_rgb_histogram_TEST.m
% This script tests the funtionality of vs_compute_histogram_TEST.m using MATLABs script-based unit testing framework.

%Constants
width = 320;
height = 240;

%Setup test images
red = vs_gen_color(width, height, 1,0,0);
green = vs_gen_color(width, height, 0,1,0);
blue = vs_gen_color(width, height, 0,0,1);
yellow = vs_gen_color(width, height, 1,1,0);


%% Test 1: Pure red
Q = 4;
result = vs_compute_rgb_histogram(red, Q);

expected_result = zeros(1, Q^3 -1);
expected_result(Q^2 * (Q-1) +1) = 1;

assert(isequal(result, expected_result));

%% Test 2: Pure green
Q = 8;
result = vs_compute_rgb_histogram(green, Q);

expected_result = zeros(1, Q^3 -1);
expected_result(Q * (Q-1) +1) = 1;

assert(isequal(result, expected_result));

%% Test 3: Pure blue
Q = 12;
result = vs_compute_rgb_histogram(blue, Q);

expected_result = zeros(1, Q^3 -1);
expected_result(Q) = 1;

assert(isequal(result, expected_result));

%% Test 4: Yellow
Q = 4;
result = vs_compute_rgb_histogram(yellow, Q);

expected_result = zeros(1, Q^3 -1);
expected_result( (Q^2 + Q)*(Q-1) +1) = 1;

assert(isequal(result, expected_result));