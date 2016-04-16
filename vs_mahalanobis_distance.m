%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_mahalanobis_distance.m
%% This function calculates the Mahanalobis distance between the two arguments passed to it

function [ distance ] = vs_mahalanobis_distance( a, b, descriptor_directory )

    % Load eigen data
    eigen_model_path = [descriptor_directory, '/eigen_model/eigen_model.mat'];
    if not(exist(eigen_model_path, 'file'))
        error('Could not find Eigen Model');
    end;
    load(eigen_model_path,'val');
    
    %Our descriptors are rows, but val is a column
    val = val';
    
    assert(isequal(size(a), size(b), size(val)));
    
    % The Mahanalobis distance is a weighted L2 Norm
    x = a - b;
    
    x = x.^2;
    
    x =  x ./ val ;
    
    x = sum(x);
    
    distance = sqrt(x);
    
    
end

