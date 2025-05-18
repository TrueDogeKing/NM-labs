function [dates, y, rmse_values, M, c_vpa, ya] = calculate_rmse_vpa()

    digits(120);  % Set high precision for VPA calculations

    M = 90;  % Polynomial degree for plotting

    load energy_2025

    % --- SET COUNTRY AND ENERGY SOURCE ---
    dates = energy_2025.Germany.Solar.Dates;
    y = energy_2025.Germany.Solar.EnergyProduction;

    N = numel(y);
    degrees = [N-10, N-1];  % Required by Grader
    % degrees = 1:N-1;      % Alternative for plotting more degrees

    x_vpa = linspace(vpa(0), vpa(1), N)';
    y_vpa = vpa(y);
    rmse_values = vpa(zeros(numel(degrees), 1));  % Use vpa for rmse_values

    % --- Calculate RMSE for each degree ---
    for i = 1:numel(degrees)
        m = degrees(i);
        c_m = polyfit_qr_vpa(x_vpa, y_vpa, m);
        y_approx = polyval_vpa(c_m(end:-1:1), x_vpa);
        err = y_approx - y_vpa;
        rmse = sqrt(mean(err.^2));
        rmse_values(i) = rmse;  % Store as vpa
    end

    % --- High-degree approximation for plotting ---
    c_vpa = polyfit_qr_vpa(x_vpa, y_vpa, M);
    c_vpa = c_vpa(end:-1:1);  % Adjust for polyval
    ya = double(polyval_vpa(c_vpa, x_vpa));
    x = double(x_vpa);

    % Convert rmse_values to double for output
    rmse_values = double(rmse_values);

    % --- Plots ---
    figure;
    subplot(2,1,1);
    plot(degrees, rmse_values, 'o-', 'LineWidth', 1.5);
    xlabel('Polynomial degree');
    ylabel('RMSE');
    title('RMSE of approximation vs polynomial degree');
    grid on;

    subplot(2,1,2);
    plot(dates, y, 'b', 'DisplayName', 'Original data');
    hold on;
    plot(dates, ya, 'r--', 'DisplayName', ['Polynomial M = ' num2str(M)]);
    xlabel('Date');
    ylabel('Energy production');
    title('High-degree polynomial approximation');
    legend;
    grid on;
end

% === Helper function: polyfit_qr_vpa ===
function c_vpa = polyfit_qr_vpa(x, y, M)
    N = length(x);
    A = vpa(zeros(N, M+1));
    for j = 0:M
        A(:, j+1) = x.^j;
    end
    [Q, R] = qr(A, 0);  % QR decomposition
    c_vpa = R \ (Q.' * y);
end

% === Helper function: polyval_vpa ===
function y = polyval_vpa(coefficients, x)
    n = length(coefficients);
    y = vpa(zeros(size(x)));
    for i = 1:n
        y = y .* x + coefficients(i);
    end
end
