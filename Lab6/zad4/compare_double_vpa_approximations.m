function [dates, y, M, x_fine, c, ya, c_vpa, yv] = compare_double_vpa_approximations()
 

    digits(120); % ustawienie precyzji vpa

    % Stopień wielomianu
    M = 90;

    % Wczytanie danych (przykład: kraj = Poland, źródło = Wind)
    load energy_2025
    dates = energy_2025.Poland.Wind.Dates;
    y = energy_2025.Poland.Wind.EnergyProduction;

    N = numel(y);
    if N < 100
        error('Zbiór danych powinien zawierać co najmniej 100 elementów.');
    end

    % Siatka rzadka
    x_vpa = linspace(vpa(0), vpa(1), N)';
    x = double(x_vpa);

    % Siatka gęsta
    nodes = 4;
    x_fine_vpa = linspace(vpa(0), vpa(1), (N - 1) * nodes + 1)';
    x_fine = double(x_fine_vpa);

    % --- Aproksymacja w double ---
    c = polyfit_qr(x, y, M);
    c = c(end:-1:1); % dla polyval
    ya = polyval(c, x_fine);  % aproksymacja double

    % --- Aproksymacja w vpa ---
    y_vpa = vpa(y);
    c_vpa = polyfit_qr_vpa(x_vpa, y_vpa, M);
    c_vpa = c_vpa(end:-1:1);
    yv = double(polyval_vpa(c_vpa, x_fine_vpa));  % konwersja na double do wykresu

    % --- Wykresy ---
    ymax = max(y) * 2;
    ymin = -0.25 * ymax;

    figure;

    % Wykres 1: aproksymacja double
    subplot(3, 1, 1);
    plot(x_fine, ya, 'b', x, y, 'ro');
    title('Aproksymacja w precyzji double');
    legend('aproksymacja', 'dane', 'Location', 'best');
    xlabel('x'); ylabel('y');
    ax = axis; ax(3) = ymin; ax(4) = ymax; axis(ax);

    % Wykres 2: aproksymacja vpa
    subplot(3, 1, 2);
    plot(x_fine, yv, 'g', x, y, 'ro');
    title('Aproksymacja w precyzji vpa');
    legend('aproksymacja', 'dane', 'Location', 'best');
    xlabel('x'); ylabel('y');
    ax = axis; ax(3) = ymin; ax(4) = ymax; axis(ax);

    % Wykres 3: zakres wartości współczynników
    subplot(3, 1, 3);
    plot_c_range(c, c_vpa);

end


function c = polyfit_qr(x, y, M)
    N = numel(x);
    A = zeros(N, M + 1);
    for j = 0:M
        A(:, j + 1) = x.^j;
    end
    [Q, R] = qr(A, 0);  % QR bez uzupełnienia
    c = R \ (Q' * y);   % Rozwiązanie układu QR
end


function c_vpa = polyfit_qr_vpa(x, y, M)
    N = numel(x);
    A = vpa(zeros(N, M + 1));
    for j = 0:M
        A(:, j + 1) = x.^j;
    end
    [Q, R] = qr(A);  % QR dla zmiennych vpa
    c_vpa = R \ (Q' * y);
end


function y = polyval_vpa(coefficients, x)
% Oblicza wartość wielomianu w punktach x dla współczynników coefficients.
% Obliczenia wykonywane są na zmiennych vpa.
% coefficients – wektor współczynników wielomianu w kolejności od najwyższej potęgi
% x – wektor argumentów (vpa)
% y – wektor wartości wielomianu (vpa)

    n = length(coefficients);
    y = vpa(zeros(size(x)));  % inicjalizacja wyniku jako vpa

    for i = 1:n
        y = y .* x + coefficients(i);  % schemat Hornera
    end
end

function plot_c_range(c, c_vpa)
    c1log = sort(log10(abs(c)+1e-50)); % 1e-50: zabezpieczenie przez c(i)=0
    c2log = sort(log10(abs(c_vpa)+1e-50));

    plot(c1log,'kx-'); hold on
    plot(c2log,'bo-')
    hold off

    title('Zakres wartości współczynników c: double vs. vpa')
    xlabel('Indeks po sortowaniu według |c|')
    ylabel('$$\log_{10}\left(10^{-50} + |c|\right)$$', 'Interpreter', 'latex')

    legend('precyzja double', 'precyzja vpa', 'Location', 'eastoutside' );
end