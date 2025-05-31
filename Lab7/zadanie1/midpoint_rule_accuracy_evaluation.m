function [ft_5, integral_1000, Nt, integration_error] = midpoint_rule_accuracy_evaluation()

    reference_value = 0.0473612919396179;

    % Wartość funkcji dla t = 5
    ft_5 = failure_density_function(5);

    % Obliczenie przybliżonej całki dla 1000 przedziałów
    N = 1000;
    x = linspace(0, 5, N+1);
    integral_1000 = midpoint_rule(x);

    % Wektory dla błędów i liczby przedziałów
    Nt = 5:50:10^4;
    integration_error = zeros(size(Nt));

    for i = 1:length(Nt)
        N_i = Nt(i);
        x_i = linspace(0, 5, N_i+1);
        approx = midpoint_rule(x_i);
        integration_error(i) = abs(approx - reference_value);
    end

    % Wykres w skali log-log
    figure;
    loglog(Nt, integration_error, 'b-o', 'LineWidth', 1.5);
    grid on;
    xlabel('Liczba podprzedziałów');
    ylabel('Błąd całkowania');
    title('Zależność błędu od liczby podprzedziałów (metoda prostokątów)');
    saveas(gcf, 'zadanie1.png');
end

function integral_approximation = midpoint_rule(x)
    n = length(x) - 1;
    h = (x(end) - x(1)) / n;
    midpoints = (x(1:end-1) + x(2:end)) / 2;
    f_values = failure_density_function(midpoints);
    integral_approximation = h * sum(f_values);
end

function ft = failure_density_function(t)
    sigma = 3;
    mu = 10;
    ft = 1/(sigma*sqrt(2*pi)) * exp((-(t-mu).^2)/(2*sigma^2));
end