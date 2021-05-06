function position = flatlandSolution()
track_width = 0.235; % Track width (m)
lambda = 1/60; % Gradient scaling factor (unitless)
delta = 0.9;

last_heading = [0; -1]; % Initial heading (unitless)
position = [0; 0]; % Initial position (m)

linear_speed = 0.05; % (m/s)
angular_speed = 0.1;%2*linear_speed/track_width; % (rad/s)

pub = rospublisher('/raw_vel');
sub_bump = rossubscriber('/bump');
msg = rosmessage(pub);
msg.Data = [0, 0];
send(pub, msg);
pause(2); % Wait for everything to settle

placeNeato(position(1), position(2), last_heading(1), last_heading(2));
pause(2); % Wait for the neato to fall

% Point spacing of 0.2 (m) and BoB attraction factor of 7 (unitless)
[~, grad_func] = make_hardcoded_gauntlet(0.05, 7);

elapsed = rostic;
while true
    % Gradient value at the current position
    grad_value = grad_func(position(1), position(2));
    grad_value = -grad_value(:);

    % We'll turn for this amount of time and to this angle
    turn_angle = atan2(grad_value(2), grad_value(1)) - atan2(last_heading(2), last_heading(1));
    turn_time = abs(turn_angle / angular_speed);
    turn_direction = sign(turn_angle);
    last_heading = grad_value;
    
    % From standard differential drive forward kinematics equations
    msg.Data = [-turn_direction*angular_speed*track_width/2
                turn_direction*angular_speed*track_width/2];
    send(pub, msg);
    
    % Wait until we're done turning
    start_turn_time = rostic;
    while rostoc(start_turn_time) < turn_time
        pause(0.01);
    end
    
    % Don't keep turning
    msg.Data = [0, 0];
    send(pub, msg);

    % How far we'll drive straight and how long it'll take
    forward_distance = norm(grad_value*lambda);
    forward_time = forward_distance / linear_speed;
    
    % Drive straight
    msg.Data = [linear_speed, linear_speed];
    send(pub, msg);
    start_forward_time = rostic;
    while rostoc(start_forward_time) < forward_time
        pause(0.01)
    end
    
    % Don't keep driving lol
    msg.Data = [0, 0];
    send(pub, msg);
    
    % Update our position at the next timestep
    position = position + grad_value*lambda;
    
    % Break when at target or we bump something
    bumpMessage = receive(sub_bump);
    if forward_distance < 0.01 || any(bumpMessage.Data)
        break;
    end
    
    lambda = lambda * delta;
end
disp(rostock(elapsed));
end