function [fss, ssf, fmss, mss, ssh] = multi_start(fobj, tobs, num_sol, itermax, type, cx, cy, cz, v)

rng('shuffle');  % Isso define a semente aleatória com base no relógio do sistema
ns = numel(cx);

if strcmp(type, "gaussian")
    
    [~, idx] = min(tobs);
    
    % Defina a média e o desvio padrão para ajustar o intervalo desejado
    media_profundidade = -8; % Média desejada
    dpp = 2; % Desvio padrão desejado
    
    % Gere um número aleatório com distribuição gaussiana ajustando a média e o desvio padrão
    profundidade = randn * dpp + media_profundidade;
    
    stt = [cx(idx), cy(idx), profundidade]; % Estação que obteve o menor tempo de percurso
    
    % Desvio padrão desejado para os valores aleatórios
    dp = 1; % Altere este valor conforme necessário
    
    % Gere uma matriz de números aleatórios com distribuição gaussiana
    ss0 = randn(num_sol, length(stt)) * dp + stt;
    
else
    min_value = min(cx);  % Valor mínimo desejado
    max_value = max(cx);  % Valor máximo desejado 
    
    num_amostras = 10;  % Número de amostras desejado
    
    ss0x = min_value + (max_value - min_value) * rand(num_amostras, 1);
    
    min_value = min(cy);  % Valor mínimo desejado
    max_value = max(cy);  % Valor máximo desejado
    
    ss0y = min_value + (max_value - min_value) * rand(num_amostras, 1);
    
    min_value = -10;  % Valor mínimo desejado
    max_value = -3;  % Valor máximo desejado
    
    ss0z = min_value + (max_value - min_value) * rand(num_amostras, 1);
    
    ss0 = [ss0x ss0y ss0z]; 
end

ssf = zeros(size(ss0));

fss = zeros(size(ss0, 1), itermax+1);

ssh = zeros(itermax + 1, 3 * (num_sol));

col_idx = 1; % Índice da próxima coluna em ssh

for i = 1:size(ss0, 1)
    [f, s_estimated, h_estimated] = gauss_newton(ss0(i, :), fobj, itermax, tobs, cx, cy, cz, ns, v);
    ssf(i, :) = s_estimated;
    fss(i, :) = f;
    
    ssh(:, col_idx:col_idx+2) = h_estimated;
    
    col_idx = col_idx + 3;
end

mss = mean(ssf(:, 1:size(ssf, 2)));
fmss = fobj(mss, tobs, cx, cy, cz, ns, v);

end




