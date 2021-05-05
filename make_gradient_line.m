function potential_func = make_gradient_line(start_point, end_point, point_spacing)
    % Funciton for making the gradient field function of a line
    num_points = round(norm(start_point - end_point) / point_spacing);
    x_points = linspace(start_point(1), end_point(1), num_points);
    y_points = linspace(start_point(2), end_point(2), num_points);
    
    function out = base(x, y)
        out = [];
        out(:, :, 1) = -x./(x.^2+y.^2);
        out(:, :, 2) = -y./(x.^2+y.^2);
    end
    potential_func = @(x, y) 0;
    
    for i = 1:num_points
        potential_func = @(x, y) potential_func(x, y) + base(x - x_points(i), y - y_points(i));
    end
end