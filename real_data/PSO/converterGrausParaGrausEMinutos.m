function [graus, minutos] = converterGrausParaGrausEMinutos(valorEmGraus)
    graus = fix(valorEmGraus);  % Obtém a parte inteira (graus)
    minutos = (valorEmGraus - graus) * 60;  % Converte a parte decimal para minutos
end