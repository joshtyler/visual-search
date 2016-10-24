% EEE3032 2016 Coursework solution
% Joshua Tyler Spring 2016
%
% vs_mahalanobis_distance_TEST.m
% This script tests the funtionality of vs_mahalanobis_distance.m using MATLABs script-based unit testing framework.

descriptor_directory = 'C:/cvpr/temp/mahan_test';
eigen_model_directory = [descriptor_directory, '/eigen_model'];
eigen_model_path = [eigen_model_directory, '/eigen_model.mat'];
if not(exist(eigen_model_directory, 'dir'))
    mkdir(eigen_model_directory);
end;



%% Test 1: zero vector
zero = [0 0];
val = ones(2,1);
save(eigen_model_path,'val');
dist = vs_mahalanobis_distance(zero, zero, descriptor_directory);
assert(dist == 0);

%% Test 2: Random vector with itself
random = rand(1,10);
val = ones(10,1);
save(eigen_model_path,'val');
dist = vs_mahalanobis_distance(random, random, descriptor_directory);
assert(dist == 0);

%% Test 3: Known result

% Expected distance is sqrt(200)
p1a = [0 10];
p1b = [10 0];

val = ones(2,1);
save(eigen_model_path,'val');

dist = vs_mahalanobis_distance(p1a, p1b, descriptor_directory);
assert(dist == sqrt(200));

%% Test 4: Known result 2

% Expected distance is sqrt(100) = 10
val = [0.5 ; 1 ; 1];
p2a = [5 5 5];
p2b = [10 10 10];
save(eigen_model_path,'val');

dist = vs_mahalanobis_distance(p2a, p2b, descriptor_directory);
assert(dist == 10);

%% Test 5: Known result 3

% Expected distance is sqrt(50 + 25 + 25 + 10 +100) = sqrt(210)

val = [0.5 ; 1 ; 1 ; 10 ; 100];
p3a = [5 5 5 0 100];
p3b = [10 10 10 10 0];
save(eigen_model_path,'val');

dist = vs_mahalanobis_distance(p3a, p3b, descriptor_directory);
assert(dist == sqrt(210));