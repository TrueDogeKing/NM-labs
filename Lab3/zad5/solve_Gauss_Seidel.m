function [A,b,U,T,w,x,r_norm,iteration_count] = solve_Gauss_Seidel()

   % Definicja rozmiaru macierzy N
    N = 5000;
    
    % Generowanie macierzy A i wektora b
    [A, b] = generate_matrix(N);
    
    % Wyodrębnienie macierzy diagonalnej, trójkątnej dolnej i górnej
    U = triu(A, 1);
    T = A - U; % Poprawna definicja T jako dolna trójkątna + diagonalna
    
    % Obliczenie wektora w zgodnie z metodą Gaussa-Seidla
    w = T \ b; % Obliczenie wektora w jako T^(-1) * b
    
    % Inicjalizacja wektora x i norm residuum
    x = ones(N, 1);
    iteration_count = 0;
    r_norm = norm(A * x - b);
    
    % Iteracyjny proces rozwiązania metodą Gaussa-Seidla
    tic;
    while (r_norm(end) > 1e-12 && iteration_count < 1000)
        x = T \ (b - U * x);
        iteration_count = iteration_count + 1;
        r_norm = [r_norm, norm(A * x - b)];
    end
    elapsed_time = toc;
    
    % Wykres normy residuum
    figure;
    semilogy(0:iteration_count, r_norm, 'b-o');
    xlabel('Iteracja');
    ylabel('Norma residuum');
    title('Zbieżność metody Gaussa-Seidla');
    grid on;
    saveas(gcf, 'zadanie5.png');
    
    fprintf('Czas wykonania: %.4f sekund\n', elapsed_time);
    fprintf('Liczba iteracji: %d\n', iteration_count);
end
