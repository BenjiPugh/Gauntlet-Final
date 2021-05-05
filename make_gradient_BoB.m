function potential_func = make_gradient_BoB(center_point, radius, point_spacing)
    % Funciton for making the gradient field function of BoB
    function out = base(x, y)
        out = [];
        % Derivatives of the potential equation
        out(:,:,1) = x./(x.^2+y.^2);
        out(:,:,2) = y./(x.^2+y.^2); 
    end
    potential_func = @(x, y) 0;
    
    for theta = linspace(0, 2*pi, round(2*pi*radius / point_spacing))
        x_point = radius*cos(theta) + center_point(1);
        y_point = radius*sin(theta) + center_point(2);
        potential_func = @(x, y) potential_func(x, y) + base(x - x_point, y - y_point);
    end
end