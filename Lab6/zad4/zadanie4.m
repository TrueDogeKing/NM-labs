clear all
close all

[dates, y, M, x_fine, c, ya, c_vpa, yv] = compare_double_vpa_approximations();
saveas(gcf, 'zadanie4.png');