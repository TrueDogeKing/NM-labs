function [ft_5, yrmax, Nt, xr, yr, integration_error] = monte_carlo_accuracy_evaluation()
 
    reference_value = 0.0473612919396179; % wartość referencyjna całki
    
    ft_5 = failure_density_function(5);
    xmax = 5;
    
    % Szukamy maksymalnej wartości funkcji na [0, xmax] (potrzebne do ymax)
    % Możemy użyć gęstego siatkowania:
    x_dense = linspace(0, xmax, 10000);
    y_dense = failure_density_function(x_dense);
    yrmax = max(y_dense);
    
    Nt = 5:50:10^4;  % liczba punktów Monte Carlo
    xr = cell(1, length(Nt));
    yr = cell(1, length(Nt));
    integration_error = zeros(1, length(Nt));
    
    for i = 1:length(Nt)
        N = Nt(i);
        [integral_approx, x_points, y_points] = monte_carlo_integral(N, xmax, yrmax);
        integration_error(i) = abs(integral_approx - reference_value);
        xr{i} = x_points;
        yr{i} = y_points;
    end
    
    % Rysowanie wykresu błędu (można też zapisać go w skrypcie zewnętrznym)
    figure;
    loglog(Nt, integration_error, '-o');
    xlabel('Liczba losowań (N)');
    ylabel('Błąd całkowania');
    title('Błąd metody Monte Carlo w funkcji liczby losowań');
    grid on;
    saveas(gcf, 'zadanie4.png');
end

function [integral_approximation, x, y] = monte_carlo_integral(N, xmax, ymax)
    % Losujemy N punktów x i y
    x = xmax * rand(1, N);
    y = ymax * rand(1, N);
    
    % Obliczamy wartości funkcji w punktach x
    f_values = failure_density_function(x);
    
    % Liczymy ile punktów y jest poniżej f(x)
    points_under_curve = sum(y <= f_values);
    
    % Obliczamy przybliżenie całki
    integral_approximation = xmax * ymax * (points_under_curve / N);
end
function ft = failure_density_function(t)
    sigma = 3;
    mu = 10;
    ft = (1/(sigma * sqrt(2 * pi))) * exp(-((t - mu).^2) / (2 * sigma^2));
end

