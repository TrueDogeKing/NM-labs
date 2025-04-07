function [circle_areas, circles, a, b, r_max] = generate_circles(n_max)
    % 1. Parametry prostokąta
    a = randi([150, 250]);
    b = randi([50, 100]);
    r_max = randi([20, 50]);
    
    % 2. Inicjalizacja
    circles = zeros(n_max, 3); % [x, y, r]
    circle_areas = zeros(n_max, 1); % Wektor wynikowy do skumulowanego stosunku pól

    area_rectangle = a * b; % Pole prostokąta

    % 3. Losowanie okręgów
    total_circle_area = 0; % Skumulowana suma pól

    for i = 1:n_max
        while true
            collides = false;

            r = r_max * rand();
            x = a * rand();
            y = b * rand();

            % Sprawdź kolizję z wcześniejszymi okręgami
            for j = 1:i-1
                xj = circles(j, 1);
                yj = circles(j, 2);
                rj = circles(j, 3);

                distance = sqrt((x - xj)^2 + (y - yj)^2);

                if distance <= r + rj || ...
                   distance + rj <= r || ...
                   distance + r <= rj
                    collides = true;
                    break;
                end
            end

            % Sprawdź czy okrąg mieści się w prostokącie
            if (x - r < 0) || (x + r > a) || (y - r < 0) || (y + r > b)
                collides = true;
            end

            % Jeśli nie ma kolizji, dodaj okrąg
            if ~collides
                circles(i, :) = [x, y, r];

                % Oblicz skumulowany stosunek pól
                area_circle = pi * r^2;
                total_circle_area = total_circle_area + area_circle;
                circle_areas(i) = 100 * (total_circle_area / area_rectangle);

                break;
            end
        end
    end

    % 4. Wizualizacja skumulowanego stosunku pól
    figure(1); % Upewniamy się, że używane jest jedno okno
    clf; % Czyścimy okno przed generowaniem wykresu
    plot(1:n_max, circle_areas, 'b-', 'LineWidth', 2);
    xlabel('Numer okręgu');
    ylabel('Skumulowany stosunek pól [%]');
    title('Skumulowany stosunek pól kół do pola prostokąta');
    grid on;

    % 5. Zapis wykresu do pliku PNG
    saveas(gcf, 'zadanie2.png');
end
