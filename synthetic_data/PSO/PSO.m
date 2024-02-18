function [f, s_estimated, h_estimated] = PSO(fobj, nvars, lb, ub, itermax, popsize, c1, c2, limiar, epoch, w_max, w_min, tobs, cx, cy, cz, ns, v)
    % PSO - Otimização por Enxame de Partículas
    %
    % Parâmetros de Entrada:
    %   fobj - Função objetivo a ser otimizada
    %   nvars - Número de variáveis de decisão
    %   lb, ub - Limites inferior e superior das variáveis de decisão
    %   itermax - Número máximo de iterações
    %   popsize - Tamanho da população
    %   c1, c2 - Parâmetros de aprendizado cognitivo e social
    %   limiar - Limiar de convergência
    %   epoch - Número de iterações consecutivas para considerar convergência
    %   w_max, w_min - Fatores de inércia máximo e mínimo
    %   tobs, cx, cy, cz, ns, v - Outros parâmetros necessários para a função objetivo
    %
    % Parâmetros de Saída:
    %   f - Valor da função objetivo em cada iteração
    %   s_estimated - Melhor solução estimada
    %   h_estimated - Histórico das melhores soluções estimadas em cada iteração
    
    % Fator de Constrição
    phi = c1 + c2;
    
    k = 1;
    
    chi = 2*k / abs(2 - phi - sqrt(phi^2 - 4));
    
    % Fator de Inércia
    w = w_max; % Fator de inércia inicial
    w_decay = (w_max - w_min) / itermax; % Decaimento linear do fator de inércia
    
    epoch_counter = 0;
    
    % Pré-alocação de matrizes
    f = zeros(1, itermax);  
    h_estimated = zeros(itermax, nvars);
    
    % Inicializar população de partículas
    particle = struct('Position', [], 'Velocity', [], 'Score', [], 'personal_best', []);
    
    for i = 1:popsize
        particle(i).Position = unifrnd(lb, ub, [1, nvars]);
        particle(i).Velocity = unifrnd(lb, ub, [1, nvars]);
        particle(i).Score = fobj(particle(i).Position, tobs, cx, cy, cz, ns, v);
        particle(i).personal_best.Position = particle(i).Position;
        particle(i).personal_best.Score = particle(i).Score;
    end
    
    % Inicializar melhor posição global
    [~, index] = min([particle.Score]);
    global_best = particle(index).personal_best;
    
    % Iterações do PSO
    for it = 1:itermax
        for i = 1:popsize
            % Atualizar velocidade da partícula
            r1 = rand(1, nvars);
            r2 = rand(1, nvars);
            particle(i).Velocity = chi * (w * particle(i).Velocity ...
                + c1 * r1 .* (particle(i).personal_best.Position - particle(i).Position) ...
                + c2 * r2 .* (global_best.Position - particle(i).Position));
            
            % Ajustar velocidade da partícula
            particle(i).Velocity = max(min(particle(i).Velocity, ub), lb);
            
            % Atualizar posição da partícula
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
            % Ajustar posição para estar dentro dos limites
            particle(i).Position = max(min(particle(i).Position, ub), lb);
            
            % Avaliar pontuação da partícula
            particle(i).Score = fobj(particle(i).Position, tobs, cx, cy, cz, ns, v);
            
            % Atualizar melhor posição pessoal
            if particle(i).Score < particle(i).personal_best.Score
                particle(i).personal_best.Position = particle(i).Position;
                particle(i).personal_best.Score = particle(i).Score;
                
                % Atualizar melhor posição global
                if particle(i).Score < global_best.Score
                    global_best = particle(i).personal_best;
                end
            end
        end
        
        % Registrar valor da função objetivo em cada iteração
        f(it) = fobj(global_best.Position, tobs, cx, cy, cz, ns, v);
        
        % Atualizar fator de inércia
        w = max(w - w_decay, w_min);
        
        % Registrar histórico de soluções
        h_estimated(it, :) = global_best.Position;      
        
        % Avaliar convergência das soluções
        if it > 1 && abs((f(it) - f(it - 1)) / f(it - 1)) <= limiar
            epoch_counter = epoch_counter + 1;
        else
            epoch_counter = 0;
        end
        
        if epoch_counter == epoch
            break
        end
    end
    
    s_estimated = global_best.Position';
end