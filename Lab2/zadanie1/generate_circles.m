function [circles, a, b, r_max] = generate_circles(n_max)
    % 1) Losowanie wymiarów prostokąta
    a = randi([150, 250]);  % Długość prostokąta wzdłuż osi x
    b = randi([50, 100]);   % Długość prostokąta wzdłuż osi y

    % 2) Losowanie maksymalnego promienia okręgu
    r_max = randi([20, 50]);  % Maksymalny promień okręgu

    % 3) Inicjalizacja macierzy circles
    circles = zeros(n_max, 3);  % [X, Y, R]

    % 4) Pętla generująca kolejne okręgi
    for i = 1:n_max
        while true
            collides = false;  % Flaga kolizji
            
            % 5) Losowanie promienia i współrzędnych środka
            r = r_max * rand();  % Promień (0, r_max]
            x = a * rand();      % X w zakresie (0, a)
            y = b * rand();      % Y w zakresie (0, b)

            % 6) Sprawdzenie kolizji i relacji z innymi okręgami
            for j = 1:i-1
                xj = circles(j, 1);
                yj = circles(j, 2);
                rj = circles(j, 3);

                distance = sqrt((x - xj)^2 + (y - yj)^2);

                % Warunek przecinania się okręgów
                if distance <= r + rj
                    collides = true;
                    break;
                end

                % Warunek całkowitego zawarcia innego okręgu w nowym
                if distance + rj <= r
                    collides = true;
                    break;
                end

                % Warunek całkowitego zawarcia nowego okręgu w istniejącym
                if distance + r <= rj
                    collides = true;
                    break;
                end
            end

            % 7) Sprawdzenie, czy okrąg mieści się w prostokącie
            if (x - r < 0) || (x + r > a) || (y - r < 0) || (y + r > b)
                collides = true;
            end

            % 8) Jeśli brak kolizji i spełnione warunki, zapisujemy okrąg
            if ~collides
                circles(i, :) = [x, y, r];
                break;
            end
        end
    end
end
