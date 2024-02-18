function [f, s, h] = gauss_newton(s0, fobj, itermax, tobs, cx, cy, cz, ns, v)
tcalc = hypo_direct(s0, cx, cy, cz, ns, v);

epsilon = 1; % Gauss-Newton

% lambda = 0; % Levenberg-Maquart (realiza-se a busca pelo lambda)

f = zeros(1, itermax+1);

f(1) = fobj(s0, tobs, cx, cy, cz, ns, v);

h = zeros(itermax+1, size(s0, 2));

h(1, :) = s0;

for i=1:itermax    
    J = jacobian(s0, cx, cy, cz, ns, v);
    
    dt = tobs - tcalc;
    
    deltam=(inv(J'*J))*(J'*dt'); %% Gauss-Newton
    
    s0 = s0 + epsilon * deltam'; %% Gauss-Newton
    
    % deltam=(inv(J'*J) + lambda*eye(size(J'*J)))*(J'*dt'); % Levenberg-Maquart
    
    % s0 = s0 + deltam'; % Levenberg-Maquart
    
    tcalc = hypo_direct(s0, cx, cy, cz, ns, v);
    
    h(i+1, :) = s0;
    
    f(i+1) = fobj(s0, tobs, cx, cy, cz, ns, v);
end
s = s0;
end