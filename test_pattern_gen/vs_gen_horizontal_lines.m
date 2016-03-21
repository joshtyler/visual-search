function img = vs_gen_horizontal_lines(width, height)

    vect = [];
    for i = 1:height
        if mod(i, 2) == 0
            vect(i) = 1;
        else
            vect(i) = 0;
        end
    end
    
    vect = vect';
    
    img = repmat(vect, 1, width);
end