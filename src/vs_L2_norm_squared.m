%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_L2_Norm.m
%% This function calculates the L2 Norm squared of the two arguments passed to it

function [ distance ] = vs_L2_norm_squared( a,b )
    
    % The L2 Norm is the sum of the squared differences
    x = a - b;
    
    x = x.^2;
    
    distance = sum(x);
    
    
end

