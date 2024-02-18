clc
clear all
close all

textlabel = [56, 124, 775, 541];

hold on
% HYPO71
for i = 1:4
    load(['s_', num2str(i), '_hypo71.mat']);
    s = eval(['s_', num2str(i), '_hypo71']);
    h1 = plot(s(2), s(1), 'kp', 'MarkerFaceColor', 'black', 'MarkerSize', 10, 'DisplayName', 'HYPO71'); % 'p' specifies a pentagram marker
    text(s(2) - 0.005, s(1) + 0.01, {num2str(textlabel(i))}, 'Color', 'k', 'FontSize', 10, 'FontWeight', 'bold');
end

% PSO
for i = 1:4
    load(['PSO/mss_', num2str(i), '_numeric.mat']);
    s = eval(['mss_', 'numeric']);
    h2 = plot(s(2), s(1), 'kp', 'MarkerFaceColor', 'yellow', 'MarkerSize', 10, 'DisplayName', 'PSO'); % 'p' specifies a pentagram marker
end

% GA
for i = 1:4
    load(['GA/mss_', num2str(i), '_numeric.mat']);
    s = eval(['mss_', 'numeric']);
    h3 = plot(s(2), s(1), 'kp', 'MarkerFaceColor', 'green', 'MarkerSize', 10, 'DisplayName', 'GA'); % 'p' specifies a pentagram marker
end

% HGWO
for i = 1:4
    load(['HGWO/mss_', num2str(i), '_numeric.mat']);
    s = eval(['mss_', 'numeric']);
    h4 = plot(s(2), s(1), 'kp', 'MarkerFaceColor', 'cyan', 'MarkerSize', 10, 'DisplayName', 'HGWO'); % 'p' specifies a pentagram marker
end

% GM
for i = 1:4
    load(['GM/mss_', num2str(i), '_numeric.mat']);
    s = eval(['mss_', 'numeric']);
    h5 = plot(s(2), s(1), 'kp', 'MarkerFaceColor', 'red', 'MarkerSize', 10, 'DisplayName', 'GM'); % 'p' specifies a pentagram marker
end

load('cx_grade.mat');
load('cy_grade.mat');

h6 = plot(cy_grade, cx_grade + 0.01, 'b^', 'MarkerFaceColor', 'blue', 'MarkerSize', 10, 'DisplayName', 'Seismographic Stations');

h7 = plot(-5.54387, -35.8145, 'ksquare', 'MarkerSize', 25, 'DisplayName','João Câmara/RN City');

text(-5.54387 - 0.01, -35.8145 + 0.015, {'João Câmara/RN'}, 'Color', 'k', 'FontSize',10);

text(cy_grade - 0.005, cx_grade, {'SM', 'LU', 'SC', 'LR', 'SP', 'AZV', 'UM', 'PA', 'PB'}, 'Color', 'k', 'FontWeight', 'bold');

hold off

xlabel('Longitude');
ylabel('Latitude');
title('Event Locations');
grid on;
legend([h1, h2, h3, h4, h5, h6], 'Location', 'Best');
