function img = vs_gen_chequer(width, height, gap)

    % Generate vertical lines
    vect = [];
    for i = 1:width
        if mod(i, gap) == 0
            vect(i) = 1;
        else
            vect(i) = 0;
        end
    end
    
    img = repmat(vect, height,1);
   
    
    %Invert every other row
    for i = 1:height
        if mod(i, gap) == 0
            img(i,:) = ~img(i,:);
        end
    end
    
end