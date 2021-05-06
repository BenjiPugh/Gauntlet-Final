function [potential_func, grad_func] = make_hardcoded_gauntlet(point_spacing, bob_attraction_factor)
% Hard coded values assembled into a potential function for the gauntlet
% challenge

    % create walls
    [w_pot, w_grad] = make_rectangle(4, 4.37, [0.5, -1.185], 0, point_spacing/3);
    % create box 1
    [s1_pot, s1_grad] = make_square(0.5, [1.41, -2], 0, point_spacing);
    % create box 2
    [s2_pot, s2_grad] = make_square(0.5, [1, -0.7], pi/4, point_spacing);
    % create box 3
    [s3_pot, s3_grad] = make_square(0.5, [-0.25, -1], pi/4, point_spacing);
    % create BoB
    bob_pot = make_potential_BoB([0.75, -2.5], 0.25, point_spacing / bob_attraction_factor);
    bob_grad = make_gradient_BoB([0.75, -2.5], 0.25, point_spacing / bob_attraction_factor);

    potential_func = @(x, y) bob_pot(x, y) + w_pot(x, y) + s1_pot(x, y) + s2_pot(x, y) + s3_pot(x, y);
    grad_func = @(x, y) bob_grad(x, y) + w_grad(x, y) + s1_grad(x, y) + s2_grad(x, y) + s3_grad(x, y);
end

