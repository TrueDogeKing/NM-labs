function [A,b,M,w,x,r_norm,iteration_count] = solve_Jacobi()

    % Definicja rozmiaru macierzy N w zakresie 5000 - 8000
    N = 5000;
    
    % Generowanie macierzy A i wektora b
    [A, b] = generate_matrix(N);
    
    % Wyodrębnienie macierzy diagonalnej, trójkątnej dolnej i trójkątnej górnej
    D = diag(diag(A));
    L = tril(A, -1);
    U = triu(A, 1);
    
    % Obliczenie macierzy M i wektora w zgodnie z metodą Jacobiego
    D_inv = diag(1 ./ diag(D)); % Odwrócenie macierzy diagonalnej (D^(-1))
    M = -D_inv * (L + U);
    w = D_inv * b;
    
    % Inicjalizacja wektora x i norm residuum
    x = ones(N, 1);
    iteration_count = 0;
    r_norm = norm(A * x - b);
    
    % Iteracyjny proces rozwiązania metodą Jacobiego
    while (r_norm(end) > 1e-12 && iteration_count < 1000)
        x = M * x + w;
        iteration_count = iteration_count + 1;
        r_norm = [r_norm, norm(A * x - b)];
    end
    
    % Wykres normy residuum
    figure;
    semilogy(0:iteration_count, r_norm, 'b-o');
    xlabel('Iteracja');
    ylabel('Norma residuum');
    title('Zbieżność metody Jacobiego');
    grid on;
    saveas(gcf, 'zadanie3.png');
end
