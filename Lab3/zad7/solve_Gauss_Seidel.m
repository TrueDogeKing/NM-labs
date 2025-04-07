function [x, r_norm] = solve_Gauss_Seidel(A, b)
    % Rozwiązanie układu A*x = b metodą Gaussa-Seidela
    N = length(b);
    U = triu(A, 1);
    T = A - U;

    % Inicjalizacja
    x = ones(N, 1);
    max_iter = 500;
    tol = 1e-12;
    r_norm = norm(A*x - b);

    % Iteracje Gaussa-Seidela
    for k = 1:max_iter
        x_new = T \ (b - U * x);
        r_norm = norm(A*x_new - b);
        
        if r_norm < tol
            break;
        end
        x = x_new;
    end

    fprintf('Metoda Gaussa-Seidela: Iteracje = %d, Norma residuum = %.4e\n', k, r_norm);
end
