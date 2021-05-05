function [potential_func, grad_func] = make_rectangle(width, height, center_point, angle, point_spacing)
    % create potential and gradient functions for a general rectangle
    points = [-width/2 -height/2;
               width/2  height/2;
              -width/2  height/2;
               width/2 -height/2];
    points_rotated = points * [cos(angle), -sin(angle); sin(angle), cos(angle)]' + center_point;
    
    potential_func = @(x, y) 0;
    grad_func = @(x, y) 0;
    for i = 1:length(points)
        start_point = points_rotated(i, :);
        end_point = points_rotated(mod(i, length(points)) + 1, :);
        
        line_potential_func = make_potential_line(start_point, end_point, point_spacing);
        line_grad_func = make_gradient_line(start_point, end_point, point_spacing);
        potential_func = @(x, y) potential_func(x, y) + line_potential_func(x, y);
        grad_func = @(x, y) grad_func(x, y) + line_grad_func(x, y);
    end
end

