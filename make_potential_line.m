function potential_func = make_potential_line(start_point, end_point, point_spacing)
    % Construct the potential field for a line
    num_points = round(norm(start_point - end_point) / point_spacing);
    x_points = linspace(start_point(1), end_point(1), num_points);
    y_points = linspace(start_point(2), end_point(2), num_points);
    
    base = @(x, y) -log(sqrt(x.^2 + y.^2));
    potential_func = @(x, y) 0;
    
    for i = 1:num_points
        potential_func = @(x, y) potential_func(x, y) + base(x - x_points(i), y - y_points(i));
    end
end