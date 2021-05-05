function [potential_func, grad_func] = make_square(side_length, center_point, angle, points_per_side)
    % create potential and gradient functions for a general rectangle
    [potential_func, grad_func] = make_rectangle(side_length, side_length, center_point, angle, points_per_side);
end

