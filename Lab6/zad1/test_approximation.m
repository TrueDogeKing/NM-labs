function [dates, y, M, c, ya] = test_approximation()
% Wyznacza aproksymację wielomianową danych przedstawiających produkcję energii.
% Dla kraju C oraz źródła energii S:
% dates - wektor energy_2025.C.S.Dates (daty pomiaru produkcji energii)
% y - wektor energy_2025.C.S.EnergyProduction (poziomy miesięcznych produkcji energii)
% M - stopień wielomianu aproksymacyjnego
% c - współczynniki wielomianu aproksymacyjnego: c = [c_M; ...; c_1; c_0]
% ya - wartości wielomianu aproksymacyjnego wyznaczone dla punktów danych

    load energy_2025

    % === WYBIERZ KRAJ I ŹRÓDŁO ENERGII ===
    dates = energy_2025.Poland.Coal.Dates;
    y = energy_2025.Poland.Coal.EnergyProduction;

    % Sprawdzenie liczby punktów danych
    if numel(y) < 100
        error('Wybrany zbiór danych musi zawierać co najmniej 100 elementów.');
    end

    M = 12; % Stopień wielomianu aproksymacyjnego
    N = numel(y); % Liczba danych
    x = linspace(0, 1, N)'; % Znormalizowana dziedzina aproksymowanych danych

    c = polyfit_qr(x, y, M); % Współczynniki wielomianu
    c = c(end:-1:1); % Odwrócenie do formatu zgodnego z polyval
    ya = polyval(c, x); % Wartości wielomianu w punktach danych

    % === WYKRES ===
    figure;
    plot(dates, y, 'bo-', 'DisplayName', 'Dane oryginalne');
    hold on;
    plot(dates, ya, 'r-', 'LineWidth', 2, 'DisplayName', 'Aproksymacja wielomianowa');
    title(sprintf('Aproksymacja wielomianowa stopnia %d produkcji energii', M));
    xlabel('Data');
    ylabel('Produkcja energii [TWh]');
    legend('Location', 'best');
    grid on;


end

function c = polyfit_qr(x, y, M)
% Wyznacza współczynniki wielomianu aproksymacyjnego stopnia M
% z zastosowaniem rozkładu QR.
% c - kolumnowy wektor współczynników: c = [c_0; ...; c_M]

    % Budowa macierzy A (macierz Vandermonde)
    N = numel(x);
    A = zeros(N, M + 1);
    for i = 0:M
        A(:, i + 1) = x.^i;
    end

    % Rozkład QR (zredukowany)
    [Q, R] = qr(A, 0);

    % Rozwiązanie równania R*c = Q'*y
    c = R \ (Q' * y);
end
