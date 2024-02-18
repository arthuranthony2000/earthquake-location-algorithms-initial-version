clc
clear all
close all

latitudeParteGraus = 35;
longitudeParteGraus = 5;

cx_g = [47.56, 39.78, 52.86, 44.43, 46.19, 47.30, 40.86, 51.13, 39.57];

cy_g = [38.64, 30.92, 39.51, 30.87, 27.34, 34.62, 25.22, 34.27, 38.31];

n = 9;

cx = zeros(1, n);
cy = zeros(1, n);
cz = zeros(1, n);

for i=1:n
    latitude = -converterGrausEMinutosparaGraus(latitudeParteGraus, cx_g(i));
    longitude = -converterGrausEMinutosparaGraus(longitudeParteGraus, cy_g(i));
    [x, y] = converterParaCoordenadasCartesianas(latitude, longitude);
    cx(i) = x;
    cy(i) = y;
end

save('cx_1', 'cx');
save('cy_1', 'cy');
save('cz_1', 'cz');

tobs = [1.18, 3.11, 2.09, 2.07, 2.81, 0.91, 4.08, 1.35, 2.76];

save('tobs_1', 'tobs');

tobs = [0.78, 3.64, 1.57, 2.67, 3.44, 1.26, 4.73, 1.48, 2.86];

save('tobs_2', 'tobs');

tobs = [2.87, 1.48, 4.05, 0.77, 1.33, 1.87, 1.97, 2.68, 2.97];

save('tobs_3', 'tobs');

tobs = [1.14, 3.2, 1.99, 2.18, 2.88, 0.96, 4.19, 1.34, 2.83];

save('tobs_4', 'tobs');



