function [rand_counts, counts_mean, circles, a, b, r_max] = generate_circles(n_max)

    % Ustalanie wymiarów prostokąta i maksymalnego promienia
    a = randi([150, 250]);  % długość prostokąta w osi x
    b = randi([50, 100]);   % długość prostokąta w osi y
    r_max = randi([20, 50]); % maksymalny promień okręgu

    % Inicjalizacja macierzy
    circles = zeros(n_max, 3); 
    rand_counts = zeros(1, n_max);  % Liczba losowań dla każdego okręgu
    counts_mean = zeros(1, n_max);  % Średnia liczba losowań
    
    % Pętla do losowania i sprawdzania kolizji
    for i = 1:n_max
        attempts = 0;  % Licznik prób
        while true
            attempts = attempts + 1;
            r = r_max * rand();
            x = a * rand();
            y = b * rand();

            % Sprawdzenie kolizji i zawierania
            collides = false;
            for j = 1:i-1
                dx = x - circles(j, 1);
                dy = y - circles(j, 2);
                dist = sqrt(dx^2 + dy^2);
                rj = circles(j, 3);

                % Warunek kolizji lub zawierania
                if dist <= r + rj || dist + r <= rj || dist + rj <= r
                    collides = true;
                    break;
                end
            end

            % Sprawdzenie, czy okrąg mieści się w prostokącie
            if x - r < 0 || x + r > a || y - r < 0 || y + r > b
                collides = true;
            end

            if ~collides
                circles(i, :) = [x, y, r];
                rand_counts(i) = attempts;
                counts_mean(i) = mean(rand_counts(1:i)); % Średnia liczba losowań
                break;
            end
        end
    end
% Rysowanie wykresów w jednym oknie za pomocą subplot


    % Wykres rand_counts
    figure(1); % Upewniamy się, że używane jest jedno okno
    clf; % Czyścimy okno przed generowaniem wykresu
    
    
    subplot(2,1,1); 
    plot(1:n_max, rand_counts, 'b-', 'LineWidth', 2);
    xlabel('Numer okręgu');
    ylabel('Liczba losowań');
    title('Liczba losowań dla każdego okręgu');
    grid on;

    % Wykres counts_mean
    subplot(2,1,2);
    plot(1:n_max, counts_mean, 'r-', 'LineWidth', 2);
    xlabel('Numer okręgu');
    ylabel('Średnia liczba losowań');
    title('Średnia liczba losowań dla kolejnych okręgów');
    grid on;

    % Zapis wykresu do pliku PNG
    saveas(gcf, 'zadanie3.png');
end