function path = gradient_descent(grad_f, r_0, lambda_0, delta, tolerance, max_steps)
% A function for determining the gradient ascent path using leisure seeker
% tactics

r_i = r_0;
grad_i = grad_f(r_i(1), r_i(2));
grad_i = grad_i(:)';
n = 0;
lambda = lambda_0;

path = r_i;

% Use gradient descent until end conditions reached
while (n < max_steps) && (norm(grad_i) > tolerance)
    r_i = r_i + lambda * grad_i;
    
    grad_i = -grad_f(r_i(1), r_i(2));
    grad_i = grad_i(:)';
    
    lambda = delta * lambda;
    
    n = n + 1;
    
    path = [path; r_i];
end