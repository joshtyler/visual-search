function img = vs_gen_vertical_lines(width, height, gap)

    vect = [];
    for i = 1:width
        if mod(i, gap) == 0
            vect(i) = 1;
        else
            vect(i) = 0;
        end
    end
    
    img = repmat(vect, height,1);
end