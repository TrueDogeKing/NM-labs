function [A,b,x,vec_time_direct] = benchmark_solve_direct(vN)
    % Inicjalizacja zmiennych
    num_problems = length(vN);
    A = cell(1, num_problems);
    b = cell(1, num_problems);
    x = cell(1, num_problems);
    vec_time_direct = zeros(1, num_problems);  % Zmienna na czasy obliczeń
    
    % Pętla po różnych rozmiarach macierzy
    for i = 1:num_problems
        % Generowanie macierzy A i wektora b dla rozmiaru vN(i)
        [A{i}, b{i}] = generate_matrix(vN(i));
        
        % Mierzenie czasu rozwiązania układu równań metodą LU
        tic;  % Rozpoczęcie pomiaru czasu
        x{i} = A{i} \ b{i};  % Rozwiązanie układu równań (metoda LU w tle)
        vec_time_direct(i) = toc;  % Zakończenie pomiaru czasu
    end
    
    figure;
    plot(vN, vec_time_direct, '-o', 'LineWidth', 2);
    xlabel('Rozmiar macierzy (N)');
    ylabel('Czas obliczeń (s)');
    title('Zależność czasu obliczeń od rozmiaru macierzy metodą LU');
    grid on;
    
    % Zapisanie wykresu do pliku PNG
    saveas(gcf, 'zadanie2.png');
end