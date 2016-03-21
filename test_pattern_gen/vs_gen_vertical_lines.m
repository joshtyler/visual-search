function img = vs_gen_vertical_lines(width, height)

    vect = [];
    for i = 1:width
        if mod(i, 2) == 0
            vect(i) = 1;
        else
            vect(i) = 0;
        end
    end
    
    img = repmat(vect, height,1);
end