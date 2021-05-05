function points_rotated = draw_rectangle(width, height, center_point, angle)
    % draw a rectangle in points
    points = [-width/2 -height/2;
              -width/2  height/2;
               width/2  height/2;
               width/2 -height/2
              -width/2 -height/2];
    points_rotated = points * [cos(angle), -sin(angle); sin(angle), cos(angle)]' + center_point;
end