function potential_func = make_potential_BoB(center_point, radius, point_spacing)
    % Construct the potential field for the BoB
    base = @(x, y) log(sqrt(x.^2 + y.^2));
    potential_func = @(x, y) 0;
    
    for theta = linspace(0, 2*pi, round(2*pi*radius / point_spacing))
        x_point = radius*cos(theta) + center_point(1);
        y_point = radius*sin(theta) + center_point(2);
        potential_func = @(x, y) potential_func(x, y) + base(x - x_point, y - y_point);
    end
end