% EEE3032 2016 Coursework solution
% Joshua Tyler Spring 2016
%
% vs_compute_histogram_TEST.m
% This script tests the funtionality of vs_compute_histogram_TEST.m using MATLABs script-based unit testing framework.

%% Test 1: Known data set 1
data = 0.9: 1 : 9.9;
data = data ./max(data); %Normalise
expected_result = ones(1,10) ./ 10 ;

result = vs_compute_histogram(data, 10);

assert( isequal(result, expected_result) );

%% Test 2: Known data set 2
data = [ 0.9 0.9 0.9 0.8 1.1 5.5 5.3 5.1 9.5 10];
data = data ./max(data); %Normalise
%Result will be:
%   4 items 0 - 1
%   1 items 1 - 2
%   3 items 5 - 6
%   2 items 9+
expected_result = [ 4 1 0 0 0 3 0 0 0 2] ./10;

result = vs_compute_histogram(data, 10);

assert( isequal(result, expected_result) );