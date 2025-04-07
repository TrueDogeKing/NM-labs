function [A,b,x,vec_loop_times,vec_iteration_count] =...
        benchmark_solve_Gauss_Seidel(vN)
% Inicjalizacja tablic komórkowych
    A = cell(1, length(vN));
    b = cell(1, length(vN));
    x = cell(1, length(vN));
    vec_loop_times = zeros(1, length(vN));
    vec_iteration_count = zeros(1, length(vN));
    
    for i = 1:length(vN)
        N = vN(i);
        
        % Generowanie macierzy A i wektora b
        [A{i}, b{i}] = generate_matrix(N);
        
        % Wyodrębnienie macierzy diagonalnej, trójkątnej dolnej i górnej
        U = triu(A{i}, 1);
        T = A{i} - U;
        
        % Obliczenie wektora w zgodnie z metodą Gaussa-Seidla
        w = T \ b{i};
        
        % Inicjalizacja wektora x i norm residuum
        x{i} = ones(N, 1);
        iteration_count = 0;
        r_norm = norm(A{i} * x{i} - b{i});
        
        % Pomiar czasu iteracyjnego procesu rozwiązania metodą Gaussa-Seidla
        tic;
        while (r_norm > 1e-12 && iteration_count < 1000)
            x{i} = T \ (b{i} - U * x{i});
            iteration_count = iteration_count + 1;
            r_norm = norm(A{i} * x{i} - b{i});
        end
        vec_loop_times(i) = toc;
        vec_iteration_count(i) = iteration_count;
    end
    
    % Wykresy czasu obliczeń i liczby iteracji
    figure;
    subplot(2,1,1);
    plot(vN, vec_loop_times, 'b-o');
    xlabel('Rozmiar macierzy N');
    ylabel('Czas obliczeń (s)');
    title('Czas obliczeń metody Gaussa-Seidla');
    grid on;
    
    subplot(2,1,2);
    plot(vN, vec_iteration_count, 'r-o');
    xlabel('Rozmiar macierzy N');
    ylabel('Liczba iteracji');
    title('Liczba iteracji metody Gaussa-Seidla');
    grid on;
    
    saveas(gcf, 'zadanie6.png');
end