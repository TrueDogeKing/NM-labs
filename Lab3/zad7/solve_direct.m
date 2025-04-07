function [x, r_norm] = solve_direct(A, b)
    % Rozwiązanie układu równań A*x = b metodą bezpośrednią
    tic;
    x = A \ b;  % Bezpośrednie rozwiązanie układu równań
    t_direct = toc;
    
    % Norma residuum
    r_norm = norm(A*x - b);
    
    fprintf('Metoda bezpośrednia: Czas = %.4f s, Norma residuum = %.4e\n', t_direct, r_norm);
end
