function [dates, y, rmse_values, M, c, ya] = calculate_rmse()

% 1) Wyznacza pierwiastek błędu średniokwadratowego w zależności od stopnia
%    aproksymacji wielomianowej danych przedstawiających produkcję energii.
% 2) Wyznacza i przedstawia na wykresie aproksymację wielomianową wysokiego
%    stopnia danych przedstawiających produkcję energii.

    M = 90; % stopień wielomianu aproksymacyjnego (dla drugiego wykresu)

    load energy_2025

    % TODO: wybierz kraj i źródło energii
    dates = energy_2025.Poland.Coal.Dates;
    y = energy_2025.Poland.Coal.EnergyProduction;

    N = numel(y);
    degrees = 1:N-1;

    x = linspace(0,1,N)'; % znormalizowana dziedzina

    rmse_values = zeros(numel(degrees),1);

    % Oblicz RMSE dla każdego stopnia wielomianu
    for m = degrees
        coeffs = polyfit_qr(x, y, m);           % współczynniki
        coeffs = coeffs(end:-1:1);              % dostosuj do polyval
        y_fit = polyval(coeffs, x);             % wartości aproksymacji
        rmse = sqrt(mean((y - y_fit).^2));      % RMSE
        rmse_values(m) = rmse;
    end

    % Aproksymacja wielomianem stopnia M (dla wykresu)
    c = polyfit_qr(x, y, M);
    c = c(end:-1:1);
    ya = polyval(c, x);

    % Wykresy
    figure;
    
    % Górny wykres – RMSE
    subplot(2,1,1);
    plot(degrees, rmse_values, 'b.-');
    title('RMSE w zależności od stopnia wielomianu aproksymacyjnego');
    xlabel('Stopień wielomianu');
    ylabel('RMSE');
    grid on;

    % Dolny wykres – dane i aproksymacja
    subplot(2,1,2);
    plot(dates, y, 'k', 'DisplayName', 'Dane oryginalne'); hold on;
    plot(dates, ya, 'r--', 'DisplayName', sprintf('Aproksymacja (stopień %d)', M));
    title(sprintf('Aproksymacja produkcji energii (stopień %d)', M));
    xlabel('Data');
    ylabel('Produkcja energii [TWh]');
    legend('Location','best');
    grid on;

end

function c = polyfit_qr(x, y, M)
    % Wyznacza współczynniki wielomianu aproksymacyjnego stopnia M
    % z zastosowaniem rozkładu QR.
    
    N = numel(x);
    A = zeros(N, M+1);

    % Tworzenie macierzy Vandermonde
    for j = 0:M
        A(:,j+1) = x.^j;
    end

    % Rozkład QR
    [Q, R] = qr(A, 0); % ekonomiczny QR
    c = R \ (Q' * y);  % rozwiązanie układu
end
