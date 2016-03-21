function img = vs_gen_color(width, height, r, g, b)

if nargin < 5
    error( 'not enough input arguments');
end


r_arr = ones(height, width) * r;
g_arr = ones(height, width) * g;
b_arr = ones(height, width) * b;

img = cat(3, r_arr, g_arr, b_arr);

end

