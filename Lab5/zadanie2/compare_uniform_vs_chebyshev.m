function [N, x_uniform, y_fine_uniform, x_chebyshev, y_fine_chebyshev] = ...
        compare_uniform_vs_chebyshev()

% Funkcja ilustruje porównanie działania interpolacji wielomianowej funkcji
% Rungego wyznaczonej dla a) węzłów rozmieszczonych równomiernie,
% b) węzłów Czebyszewa.
% N - liczba węzłów interpolacji wynosi z przedziału [12,20].
% Funkcja zwraca następujące wektory wierszowe:
% x_uniform - węzły interpolacji rozmieszczone równomiernie
% y_fine_uniform - interpolacja wielomianowa wyznaczona dla
%   równomiernie rozmieszczonych węzłów interpolacji
% x_chebyshev - węzły Czebyszewa
% y_fine_chebyshev - interpolacja wielomianowa wyznaczona dla węzłów Czebyszewa

    N = 16; % liczba węzłów interpolacji (można zmieniać między 12 a 20)

    % Gęsta siatka punktów do testowania interpolacji
    x_fine = linspace(-1, 1, 1000);

    % Funkcja Rungego
    runge_function = @(x) 1 ./ (1 + 25 * x.^2);
    y_fine_reference = runge_function(x_fine);

    % 1. Węzły równomiernie rozmieszczone
    x_uniform = linspace(-1, 1, N);
    y_uniform = runge_function(x_uniform);

    V_uniform = get_vandermonde_matrix(x_uniform);
    coeff_uniform = V_uniform \ y_uniform.'; % rozwiązanie układu równań liniowych
    coeff_uniform = coeff_uniform(end:-1:1); % dostosowanie do polyval
    y_fine_uniform = polyval(coeff_uniform, x_fine);

    % 2. Węzły Czebyszewa II rodzaju
    x_chebyshev = get_chebyshev_nodes(N);
    y_chebyshev = runge_function(x_chebyshev);

    V_chebyshev = get_vandermonde_matrix(x_chebyshev);
    coeff_chebyshev = V_chebyshev \ y_chebyshev.'; 
    coeff_chebyshev = coeff_chebyshev(end:-1:1);
    y_fine_chebyshev = polyval(coeff_chebyshev, x_fine);

    % 3. Wykresy
    figure;
    subplot(2,1,1);
    plot(x_fine, y_fine_reference, 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, y_fine_uniform, 'm', 'LineWidth', 1.5, 'DisplayName', ['Interpolacja N = ', num2str(N)]);
    plot(x_uniform, y_uniform, 'mo', 'MarkerFaceColor', 'm', 'DisplayName', ['Węzły interpolacji, N = ', num2str(N)]);
    hold off;
    legend show;
    legend('Location', 'eastoutside')
    xlabel('x');
    ylabel('y');
    title('Interpolacja funkcji Rungego - węzły równomierne');

    subplot(2,1,2);
    plot(x_fine, y_fine_reference, 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, y_fine_chebyshev, 'b', 'LineWidth', 1.5, 'DisplayName', ['Interpolacja N = ', num2str(N)]);
    plot(x_chebyshev, y_chebyshev, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', ['Węzły interpolacji, N = ', num2str(N)]);
    hold off;
    legend show;
    legend('Location', 'eastoutside')
    xlabel('x');
    ylabel('y');
    title('Interpolacja funkcji Rungego - węzły Czebyszewa II rodzaju');

    set(gcf, 'Position', [1000 500 2000 1500]);
    saveas(gcf, 'zadanie2.png');
end

function x = get_chebyshev_nodes(N)
% Węzły Czebyszewa drugiego rodzaju wyznaczone w przedziale [-1, 1]
    k = 0:N-1;
    x = cos(pi * k / (N-1));
end

function V = get_vandermonde_matrix(x)
% Buduje macierz Vandermonde’a na podstawie wektora węzłów interpolacji x
    N = length(x);
    V = zeros(N);
    for j = 1:N
        V(:, j) = x.^(j-1);
    end
end
