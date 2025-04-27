function [node_counts, exact_runge, exact_sine, V, interpolated_runge, interpolated_sine] =...
    plot_runge_sine_interpolations()

% Generuje dwa wykresy przedstawiające interpolacje funkcji Rungego oraz
% funkcji sinusoidalnej.

    % Lista liczby węzłów interpolacyjnych do przetestowania
    node_counts = [3, 5, 9, 13]; % naprawione: różne liczby, min. jedna > 12

    % Definicja funkcji Rungego
    runge_function = @(x) 1 ./ (1 + 25 * x.^2);
    % Definicja funkcji sinusoidalnej
    sine_function = @(x) sin(2 * pi * x);

    % Gęsta siatka punktów do testowania interpolacji
    x_fine = linspace(-1, 1, 1000);

    % Wartości funkcji wzorcowych
    exact_runge = runge_function(x_fine);
    exact_sine = sine_function(x_fine);

    % Przygotowanie miejsca na wyniki
    V = cell(1, length(node_counts));
    interpolated_runge = cell(1, length(node_counts));
    interpolated_sine = cell(1, length(node_counts));

    % Ustawienia kolorów do wykresów
    colors = ['r', 'g', 'b', 'm'];

    % Wykres dla funkcji Rungego
    subplot(2,1,1);
    plot(x_fine, exact_runge, 'k--', 'LineWidth', 2, 'DisplayName', 'Wartości wzorcowe');
    hold on;

    % Wykres dla funkcji sinusoidalnej
    subplot(2,1,2);
    plot(x_fine, exact_sine, 'k--', 'LineWidth', 2, 'DisplayName', 'Wartości wzorcowe');
    hold on;

    for i = 1:length(node_counts)
        N = node_counts(i);
        % Węzły interpolacji
        x_nodes = linspace(-1, 1, N)';

        % Wyznaczenie macierzy Vandermonde'a
        V{i} = get_vandermonde_matrix(x_nodes);

        % Funkcja Rungego
        y_runge = runge_function(x_nodes);
        coefficients_runge = V{i} \ y_runge; % rozwiązanie układu
        coefficients_runge = coefficients_runge(end:-1:1); % odwrócenie kolejności
        interpolated_runge{i} = polyval(coefficients_runge, x_fine);

        % Funkcja sinusoidalna
        y_sine = sine_function(x_nodes);
        coefficients_sine = V{i} \ y_sine; % rozwiązanie układu
        coefficients_sine = coefficients_sine(end:-1:1); % odwrócenie kolejności
        interpolated_sine{i} = polyval(coefficients_sine, x_fine);

        % Dodawanie interpolacji do wykresu
        subplot(2,1,1);
        plot(x_fine, interpolated_runge{i}, colors(i), 'LineWidth', 1.5, 'DisplayName', sprintf('Interpolacja %d węzłów', N));

        subplot(2,1,2);
        plot(x_fine, interpolated_sine{i}, colors(i), 'LineWidth', 1.5, 'DisplayName', sprintf('Interpolacja %d węzłów', N));
    end

    % Opisy wykresów i legenda
    subplot(2,1,1)
    title('Interpolacja funkcji Rungego');
    xlabel('x');
    ylabel('Wartość funkcji');
    legend('Location', 'eastoutside');
    grid on;

    subplot(2,1,2)
    title('Interpolacja funkcji sinusoidalnej');
    xlabel('x');
    ylabel('Wartość funkcji');
    legend('Location', 'eastoutside');
    grid on;

    % Opcjonalne: ustawienia rozmiaru okna wykresu
    set(gcf, 'Position', [100 100 1000 800]);

    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie1.png');
end

function V = get_vandermonde_matrix(x)
    % Buduje macierz Vandermonde’a na podstawie wektora węzłów interpolacji x.
    N = length(x);
    V = zeros(N);
    for j = 1:N
        V(:, j) = x.^(j-1); % potęgi rosnące: x^0, x^1, ..., x^(N-1)
    end
end

