clc
clear all
close all

for i = 1:4
    % Carrega o arquivo mss_i.mat
    filename = ['mss_', num2str(i), '.mat'];
    load(filename);

    % Calcula as coordenadas absolutas
    [latitude, longitude] = converterParaCoordenadasAbsolutas(mss(1), mss(2));
    mss_numeric = [latitude, longitude];
    
    save(['mss_', num2str(i), '_numeric', '.mat'], 'mss_numeric');

    [graus_lat, minutos_lat] = converterGrausParaGrausEMinutos(latitude);
    minutos_lat = abs(minutos_lat);

    if graus_lat < 0
        latitude_str = [num2str(abs(graus_lat)), '°', num2str(minutos_lat), ''' S'];
    else
        latitude_str = [num2str(graus_lat), '°', num2str(minutos_lat), ''' N'];
    end

    [graus_long, minutos_long] = converterGrausParaGrausEMinutos(longitude);
    minutos_long = abs(minutos_long);

    if graus_long < 0
        longitude_str = [num2str(abs(graus_long)), '°', num2str(minutos_long), ''' W'];
    else
        longitude_str = [num2str(graus_long), '°', num2str(minutos_long), ''' E'];
    end

    % Exibe e salva os resultados
    result_str = [latitude_str, ' ', longitude_str];
    disp(result_str);

    % Salva a string em um novo arquivo
    output_filename = ['mss_', num2str(i), '_abs.mat'];
    save(output_filename, 'result_str');
end
