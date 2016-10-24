%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vprintf.m
%% This program is a 'verbosity aware' print function. It allows settting of different verbosity levels.
%% Adapted from code by 'Frederick' at http://stackoverflow.com/questions/17974217/ideas-best-practices-for-controlling-verbosity-in-matlab-functions


function vprintf(l,varargin)

global verbosity_level;

if nargin<2
    error('Not enough arguments');
end
if l<=verbosity_level
    fprintf(varargin{:});
end