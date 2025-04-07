function [A,b,L,U,P,y,x,r_norm,t_factorization,t_substitution,t_direct] = ...
        solve_direct()
% A, b - macierz i wektor z równania macierzowego A * x = b
% L - macierz trójkątna dolna pochodząca z wywołania [L,U,P] = lu(A);
% U - macierz trójkątna górna
% P - macierz permutacji
% y - wektor pomocniczy y=L\(P*b)
% x - wektor rozwiązania
% r_norm - norma residuum: norm(A*x-b)
% t_factorization - czas faktoryzacji macierzy A (czas działania funkcji lu)
% t_substitution - czas wyznaczenia rozwiązań równań z macierzami trójkątnymi L i U
% t_direct - czas wyznaczenia rozwiąznia równania macierzowego metodą LU

N = randi([5000, 9000]);  
[A, b] = generate_matrix(N);
    
    % Pomiar czasu faktoryzacji LU
    tic;
    [L, U, P] = lu(A);  % Faktoryzacja LU z permutacją
    t_factorization = toc;
    
    % Pomiar czasu podstawień
    tic;
    y = L \ (P * b);  % Podstawienie w przód
    x = U \ y;        % Podstawienie wstecz
    t_substitution = toc;
    
    % Obliczenie całkowitego czasu rozwiązania układu równań metodą LU
    t_direct = t_factorization + t_substitution;
    
    % Obliczenie normy residuum
    r_norm = norm(A*x - b);
    
    % Wykres czasu obliczeń
    figure;
    bar([t_direct, t_factorization, t_substitution]);
    set(gca, 'XTickLabel', {'Całkowity', 'Faktoryzacja', 'Podstawienia'});
    xlabel('Etap obliczeń');  % Dodano opis osi X
    ylabel('Czas [s]');
    title('Czas obliczeń metodą LU');
    
    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie1.png');

end
