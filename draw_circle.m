function points = draw_circle(center_point, radius)
    % Draw a circle in points
    points = [];
    for theta = linspace(0, 2*pi, 15)
        x_point = radius*cos(theta) + center_point(1);
        y_point = radius*sin(theta) + center_point(2);
        points = [points; x_point, y_point];
    end
end