function position = flatlandSolution()
track_width = 0.235; % Track width (m)
lambda = 1/100; % Gradient scaling factor (unitless)

heading = [0; 1]; % Initial heading (unitless)
position = [0; 0]; % Initial position (m)

angular_speed = 0.1; % (rad/s)
linear_speed = 0.05; % (m/s)

pub = rospublisher('/raw_vel');
sub_bump = rossubscriber('/bump');
msg = rosmessage(pub);
msg.Data = [0, 0];
send(pub, msg);
pause(2); % Wait for everything to settle

placeNeato(position(1), position(2), heading(1), heading(2));
pause(2); % Wait for the neato to fall

% Point spacing of 0.05 (m) and BoB attraction factor of 7 (unitless)
[~, grad_func] = make_hardcoded_gauntlet(0.05, 7);

while true
    % Gradient value at the current position
    grad_value = -grad_func(position(1), position(2));
    grad_value = grad_value(:);

    % We'll turn for this amount of time and to this angle
    turn_angle = atan2(grad_value(2), grad_value(1));
    turn_time = double(turn_angle) / angular_speed;
    turn_direction = sign(turn_angle);
    
    % From standard differential drive forward kinematics equations
    msg.Data = [-turn_direction*angular_speed*track_width/2
                turn_direction*angular_speed*track_width/2];
    send(pub, msg);
    
    % Wait until we're done turning
    rostic;
    while rostoc < turn_time
        pause(0.01);
    end

    % How far we'll drive straight and how long it'll take
    forward_distance = norm(grad_value*lambda);
    forward_time = forward_distance / linear_speed;
    
    % Drive straight
    msg.Data = [linear_speed, linear_speed];
    send(pub, msg);
    rostic;
    while rostoc < forward_time
        pause(0.01)
    end
    
    % Update our position at the next timestep
    position = position + grad_value*lambda;
    
    % Break when at target or we bump something
    bumpMessage = receive(sub_bump);
    if forward_distance < 0.01 || any(bumpMessage.Data)
        break;
    end
end

% Don't keep driving lol
msg.Data = [0, 0];
send(pub, msg);

end