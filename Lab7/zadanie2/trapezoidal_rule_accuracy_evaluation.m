function [ft_5, integral_1000, Nt, integration_error] = trapezoidal_rule_accuracy_evaluation()
 

    reference_value = 0.0473612919396179; % wzorcowa wartość całki

    % Wartość funkcji gęstości dla t = 5
    ft_5 = failure_density_function(5);

    % Obliczenie całki metodą trapezów dla 1000 podprzedziałów
    N = 1000;
    x = linspace(0, 5, N+1);
    integral_1000 = trapezoidal_rule(x);

    % Wektory podprzedziałów i błędów
    Nt = 5:50:10^4;
    integration_error = zeros(size(Nt));

    % Pętla po różnych liczbach podprzedziałów
    for i = 1:length(Nt)
        N_i = Nt(i);
        x_i = linspace(0, 5, N_i+1);
        approx = trapezoidal_rule(x_i);
        integration_error(i) = abs(approx - reference_value);
    end

    % Rysowanie wykresu błędu w skali log-log
    figure;
    loglog(Nt, integration_error, 'r-o', 'LineWidth', 1.5);
    grid on;
    xlabel('Liczba podprzedziałów');
    ylabel('Błąd całkowania');
    title('Dokładność metody trapezów');
    saveas(gcf, 'zadanie2.png');
end

function integral_approximation = trapezoidal_rule(x)
    % Oblicza przybliżoną wartość całki metodą trapezów dla podanego wektora x
    n = length(x) - 1;
    h = (x(end) - x(1)) / n;
    f_values = failure_density_function(x);
    integral_approximation = (h/2) * sum(f_values(1:end-1) + f_values(2:end));
end

function ft = failure_density_function(t)
    sigma = 3;
    mu = 10;
    ft = 1/(sigma*sqrt(2*pi)) * exp((-(t - mu).^2) / (2 * sigma^2));
end
