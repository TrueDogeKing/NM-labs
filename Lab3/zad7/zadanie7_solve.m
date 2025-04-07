% Wczytanie macierzy A i wektora b
load('filtr_dielektryczny.mat', 'A', 'b');

% Wyznaczenie rozwiązań trzema metodami
[x_direct, r_norm_direct] = solve_direct(A, b);
[x_Jacobi, r_norm_Jacobi] = solve_Jacobi(A, b);
[x_GS, r_norm_GS] = solve_Gauss_Seidel(A, b);

% Zapis wyników do pliku
save('zadanie7_solve.mat', 'r_norm_direct', 'r_norm_Jacobi', 'r_norm_GS');
