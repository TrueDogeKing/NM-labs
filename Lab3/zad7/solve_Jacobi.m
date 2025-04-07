function [x, r_norm] = solve_Jacobi(A, b)
    % Rozwiązanie układu A*x = b metodą Jacobiego
    N = length(b);
    D = diag(diag(A));
    L = tril(A, -1);
    U = triu(A, 1);
    D_inv = diag(1 ./ diag(D));
    M = -D_inv * (L + U);
    w = D_inv * b;

    % Inicjalizacja
    x = ones(N, 1);
    max_iter = 500;
    tol = 1e-12;
    r_norm = norm(A*x - b);
    
    % Iteracje Jacobiego
    for k = 1:max_iter
        x_new = M * x + w;
        r_norm = norm(A*x_new - b);
        
        if r_norm < tol
            break;
        end
        x = x_new;
    end

    fprintf('Metoda Jacobiego: Iteracje = %d, Norma residuum = %.4e\n', k, r_norm);
end
