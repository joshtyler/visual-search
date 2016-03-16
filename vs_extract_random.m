%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_extract_random.m
%% Compute a random image descriptor
%% Copied from provided example code (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)

function F=extractRandom(img)

F=rand(1,30);

% Returns a row [rand rand .... rand] representing an image descriptor
% computed from image 'img'

% Note img is a normalised RGB image i.e. colours range [0,1] not [0,255].

return;