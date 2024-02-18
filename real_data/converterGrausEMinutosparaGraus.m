function [graus] = converterGrausEMinutosparaGraus(parteGraus, parteMinutos)
    graus = parteGraus + (parteMinutos / 60);
end