clc
clear all
close all

latitudeParteGraus = 35;
longitudeParteGraus = 5;

cx_g = [47.56, 39.78, 52.86, 44.43, 46.19, 47.30, 40.86, 51.13, 39.57];

cy_g = [38.64, 30.92, 39.51, 30.87, 27.34, 34.62, 25.22, 34.27, 38.31];

n = 9;

cx_grade = zeros(1, n);
cy_grade = zeros(1, n);

for i=1:n
    latitude = -converterGrausEMinutosparaGraus(latitudeParteGraus, cx_g(i));
    longitude = -converterGrausEMinutosparaGraus(longitudeParteGraus, cy_g(i));
    cx_grade(i) = latitude;
    cy_grade(i) = longitude;
end

save('cx_grade', 'cx_grade');
save('cy_grade', 'cy_grade');


