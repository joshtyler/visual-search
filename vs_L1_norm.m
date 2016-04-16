%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_L2_Norm.m
%% This function calculates the L1 Norm of the two arguments passed to it

function [ distance ] = vs_L1_Norm( a,b )
    
    % The L2 Norm is the root of the sum of the squared differences
    x = a - b;
    
    x = abs(x);
    
    distance = sum(x);
    
    
end

