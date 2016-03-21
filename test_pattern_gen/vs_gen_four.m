function img = vs_gen_four(width, height, permutation, list)


    %Warning. This will only work correctly for sizes which are multiples of four
    if mod(width,2) ~= 0 || mod(height,2) ~= 0
        error('Inputs sizes are not a multiple of two');
    end
    
    width = width /2;
    height = height / 2;

    sub = {};
    for i = 1:4
        sub{i} = list{i}(width, height);
    end;
    
    %Although there are 24 possible permutations, we only care about 4
    %Remember [X Y] horizontally concatinates [X ; Y] vertically concatinates
    switch permutation
        case 1
            img = [ [ sub{1} sub{2} ] ; [ sub{3} sub{4} ] ];
        case 2
            img = [ [ sub{4} sub{1} ] ; [ sub{2} sub{3} ] ];
        case 3
            img = [ [ sub{3} sub{4} ] ; [ sub{1} sub{2} ] ];
        case 4
            img = [ [ sub{2} sub{3} ] ; [ sub{4} sub{1} ] ];
        otherwise
            error('This script can only handle four permutations');
            
    end
    
    
end