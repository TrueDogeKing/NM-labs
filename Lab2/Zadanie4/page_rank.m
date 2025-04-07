function [Edges, I, B, A, b, r] = page_rank()
    % Definicja macierzy krawędzi (macierz gęsta)
    Edges = [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7;
             4, 6, 3, 4, 5, 5, 6, 7, 5, 6, 4, 6, 4, 7, 6];


    % Liczba stron (węzłów)
    N = max(Edges(:));

    % Macierz jednostkowa (rzadka)
    I = speye(N);

    % Macierz sąsiedztwa (rzadka) - B(i,j) = 1 jeśli j->i
    B = sparse(Edges(2,:), Edges(1,:), 1, N, N);

    % Wektor liczby odnośników wychodzących z każdej strony
    L = sum(B, 1);

    % Macierz diagonalna (rzadka)
    A = spdiags(1 ./ L', 0, N, N);

    % Współczynnik tłumienia
    d = 0.85;

    % Wektor prawych stron równania (macierz gęsta)
    b = ((1 - d) / N) * ones(N, 1);

    % Rozwiązanie układu równań (gęsta macierz wynikowa)
    r = (I - d * B * A) \ b;

    % Rysowanie wykresu
    figure(1); % Upewniamy się, że używane jest jedno okno
    clf; % Czyścimy okno przed generowaniem wykresu
    bar(r);
    title('Wartości PageRank');
    xlabel('Numer strony');
    ylabel('PageRank');

end
