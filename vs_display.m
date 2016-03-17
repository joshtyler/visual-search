%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% vs_display.m
%% This program displays results as a MATLAB plot


function vs_display( input, image_directory, no_to_disp )

    close all;
    
    %Setup nextplot
    next_plot(no_to_disp);
    
    for i = 1:no_to_disp
        next_plot();
        img = imread( [image_directory,'/', input{i,2}(1:end-4),'.bmp'] );
        imshow(img);
        str1 = sprintf('Result %d',i);
        str2 = sprintf('\nDistance %f File: %s\n',input{i,1},input{i,2});
        if i == 1
            str = strcat(str1,'(Query Image)',str2);
        else
            str = strcat(str1,str2);
        end;
        title(str, 'Interpreter', 'none');

    end;

end

% Auxillary function

%Helps simplify subplot(), by handing the indexing itself.
function next_plot(init)

    persistent curPlot;
    persistent noPlots;
    
    %if we have input arguments, initialise.
    if nargin == 1
        figure; %Create new figure
        noPlots = init;
        curPlot = 1;
        return; % Return as this call was just to set up the function.
    end
    
    % Figure out arrangement of plots.
    noRowsCols = ceil(sqrt(noPlots));
    
    subplot(noRowsCols, noRowsCols, curPlot);
    
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1.2 1]) % stretch its width and height
    
    curPlot = curPlot + 1;
    
end