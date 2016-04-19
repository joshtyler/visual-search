% EEE3032 2016 Coursework solution
% Joshua Tyler Spring 2016
%
% vs_L2_Norm_TEST.m
% This script tests the funtionality of vs_L2_norm.m using MATLABs script-based unit testing framework.

zero = [0 0];
random = rand(1,10);

% Expected distance is sqrt(200)
p1a = [0 10];
p1b = [10 0];

% Expected distance is sqrt(75)
p2a = [5 5 5];
p2b = [10 10 10];

%% Test 1: zero vector
dist = vs_L2_norm(zero, zero);
assert(dist == 0);

%% Test 2: Random vector with itself
dist = vs_L2_norm(random, random);
assert(dist == 0);

%% Test 3: Known result
dist = vs_L2_norm(p1a, p1b);
assert(dist == sqrt(200));

%% Test 4: Known result2
dist = vs_L2_norm(p2a, p2b);
assert(dist == sqrt(75));

%% Test 5: Test against matlab library function
p3a = rand(1,10);
p3b = rand(1,10);
dist = vs_L2_norm(p3a, p3b);
assert(dist == norm( p3a - p3b, 2));