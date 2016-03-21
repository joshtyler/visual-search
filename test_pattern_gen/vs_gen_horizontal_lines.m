function img = vs_gen_horizontal_lines(width, height, gap)

    vect = [];
    for i = 1:height
        if mod(i, gap) == 0
            vect(i) = 1;
        else
            vect(i) = 0;
        end
    end
    
    vect = vect';
    
    img = repmat(vect, 1, width);
end