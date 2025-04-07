function [index_number, Edges, I, B, A, b, r] = page_rank()

    % Numer indeksu studenta
    index_number = 198157;

    % Obliczenie węzła A
    L = mod(index_number, 10); % Ostatnia cyfra indeksu
    A_node = 1 + mod(L, 7);

    % Definicja oryginalnej macierzy krawędzi
    Edges = [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7;
             4, 6, 3, 4, 5, 5, 6, 7, 5, 6, 4, 6, 4, 7, 6];

    % **Nowe linki do A_node** (więcej linków do A)
    new_incoming_links = [2, 3, 4, 5, 6, 7;  
                          A_node, A_node, A_node, A_node, A_node, A_node];

    % **Nowe linki wychodzące z A_node** (ograniczamy do 1-2 mocnych stron)
    new_outgoing_links = [A_node, A_node;
                          6, 7];

    % Aktualizacja macierzy krawędzi
    Edges = [Edges, new_incoming_links, new_outgoing_links];

    % Usunięcie duplikatów w macierzy krawędzi
    Edges = unique(Edges', 'rows')';

    % Liczba węzłów
    N = 7;

    % Tworzenie macierzy jednostkowej I
    I = speye(N);

    % Tworzenie macierzy sąsiedztwa B
    B = sparse(Edges(2,:), Edges(1,:), 1, N, N);

    % Macierz diagonalna D (suma po kolumnach B)
    d = sum(B, 1)';
    A = spdiags(1 ./ d, 0, N, N);

    % Współczynnik tłumienia
    d_factor = 0.85;

    % Macierz układu równań
    M = I - d_factor * (B * A);

     % **Poprawiona definicja b**
    b = ((1 - d_factor) / N) * ones(N, 1);

    % Rozwiązanie układu równań
    r = M \ b;

    % Generowanie wykresu
    figure(1); % Upewniamy się, że używane jest jedno okno
    clf; % Czyścimy okno przed generowaniem wykresu
    bar(r);
    title(['PageRank dla grafu (A = ', num2str(A_node), ')']);
    xlabel('Strona');
    ylabel('Wartość PageRank');

    % Zapisanie wykresu
    print('zadanie5.png', '-dpng');

    % Wyświetlenie wyników
    disp(['Maksymalny PageRank: ', num2str(max(r))]);
    disp(['PageRank dla A (', num2str(A_node), '): ', num2str(r(A_node))]);

end
