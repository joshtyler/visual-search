%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_L_Inf_norm.m
%% This function calculates the L_Inf norm of the two arguments passed to it

function [ distance ] = vs_L_Inf_norm( a,b )
    
    % The L_Inf Norm is the max of all the differences
    x = a - b;
    
    x = abs(x);
    
    distance = max(x);
    
    
end

