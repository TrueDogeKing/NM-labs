function [A,b,x,vec_loop_times,vec_iteration_count] =...
        benchmark_solve_Jacobi(vN)
% Liczba różnych rozmiarów macierzy
    num_sizes = length(vN);
    vec_loop_times = zeros(1, num_sizes);
    vec_iteration_count = zeros(1, num_sizes);
    A = cell(1, num_sizes); % Inicjalizacja tablicy komórkowej dla macierzy A
    b = cell(1, num_sizes); % Inicjalizacja tablicy komórkowej dla wektorów b
    x = cell(1, num_sizes); % Inicjalizacja tablicy komórkowej dla wektorów x
    
    for i = 1:num_sizes
        N = vN(i);
        
        % Generowanie macierzy A i wektora b
        [A{i}, b{i}] = generate_matrix(N);
        
        % Wyodrębnienie macierzy diagonalnej, trójkątnej dolnej i górnej
        D = diag(diag(A{i}));
        L = tril(A{i}, -1);
        U = triu(A{i}, 1);
        
        % Obliczenie macierzy M i wektora w
        D_inv = diag(1 ./ diag(D));
        M = -D_inv * (L + U);
        w = D_inv * b{i};
        
        % Inicjalizacja wektora x
        x{i} = ones(N, 1);
        iteration_count = 0;
        r_norm = norm(A{i} * x{i} - b{i});
        
        % Pomiar czasu iteracyjnej metody Jacobiego
        tic;
        while (r_norm > 1e-12 && iteration_count < 1000)
            x{i} = M * x{i} + w;
            iteration_count = iteration_count + 1;
            r_norm = norm(A{i} * x{i} - b{i});
        end
        vec_loop_times(i) = toc;
        vec_iteration_count(i) = iteration_count;
    end
    
    % Wykresy wyników
    figure;
    
    % Górny wykres: czas obliczeń
    subplot(2,1,1);
    plot(vN, vec_loop_times, 'r-o');
    xlabel('Rozmiar macierzy N');
    ylabel('Czas obliczeń (s)');
    title('Czas obliczeń metody Jacobiego');
    grid on;
    
    % Dolny wykres: liczba iteracji
    subplot(2,1,2);
    plot(vN, vec_iteration_count, 'b-o');
    xlabel('Rozmiar macierzy N');
    ylabel('Liczba iteracji');
    title('Liczba iteracji wymaganych do rozwiązania');
    grid on;
    
    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie4.png');
end
