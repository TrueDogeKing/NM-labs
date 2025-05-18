clear all
close all

[dates, y, rmse_values, M, c_vpa, ya] = calculate_rmse_vpa();
saveas(gcf, 'zadanie3.png');