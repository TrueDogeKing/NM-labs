function [xvec,xdif,xsolution,ysolution,iterations] = impedance_bisection()


    % Wyznacza miejsce zerowe funkcji impedance_difference metodą bisekcji.
    
    % Parametry metody bisekcji
    a = 1; % Stała lewa granica przedziału
    b = 10; % Stała prawa granica przedziału
    ytolerance = 1e-12; % Tolerancja wartości funkcji
    max_iterations = 1000; % Maksymalna liczba iteracji
    
    % Sprawdzenie, czy funkcja zmienia znak w danym przedziale
    fa = impedance_difference(a);
    fb = impedance_difference(b);
    
    % Wstępne obliczenie środkowego punktu przedziału
    c = (a + b) / 2; % Środek przedziału
    xvec = c; % Pierwsze przybliżenie w wektorze xvec
    
    % Inicjalizacja zmiennych
    xdif = []; % Wektor różnic przybliżeń
    xsolution = NaN; % Ostateczne rozwiązanie
    ysolution = NaN; % Ostateczna wartość funkcji
    iterations = 0; % Liczba iteracji
    
    for ii = 1:max_iterations
        c = (a + b) / 2; % Nowy środek przedziału
        fc = impedance_difference(c); % Wartość funkcji w punkcie c
        
        % Dodanie do wektora przybliżeń
        xvec(ii, 1) = c;
        
        % Sprawdzenie warunku zakończenia (gdy funkcja osiąga tolerancję)
        if abs(fc) < ytolerance
            xsolution = c;
            ysolution = fc;
            iterations = ii;
            if ii > 1
                xdif(ii-1, 1) = abs(xvec(ii) - xvec(ii-1));
            end
            break;
        end
        
        % Aktualizacja przedziału
        if fa * fc < 0
            b = c;
            fb = fc;
        else
            a = c;
            fa = fc;
        end
        
        % Obliczenie różnicy między kolejnymi przybliżeniami
        if ii > 1
            xdif(ii-1, 1) = abs(xvec(ii) - xvec(ii-1));
        end
    end
    
    % Wykresy
    figure;
    subplot(2,1,1);
    plot(xvec, 'o-');
    xlabel('Iteracja');
    ylabel('Przybliżenie miejsca zerowego');
    title('Metoda bisekcji - przybliżenia');
    
    subplot(2,1,2);
    semilogy(xdif, 'o-');
    xlabel('Iteracja');
    ylabel('Różnica między kolejnymi przybliżeniami');
    title('Metoda bisekcji - zbieżność');
end

function impedance_delta = impedance_difference(f)
    % Wyznacza moduł impedancji równoległego obwodu rezonansowego RLC pomniejszoną o wartość M.
    % f - częstotliwość (Hz)
    
    % Parametry obwodu
    R = 525; % Rezystancja w omach
    L = 3; % Indukcyjność w henrach
    C = 7e-5; % Pojemność w faradach
    M = 75; % Wartość odniesienia impedancji
    
    % Sprawdzenie poprawności częstotliwości
    if f <= 0
        error('Częstotliwość musi być większa od zera.');
    end
    
    % Obliczenie mianownika wyrażenia na moduł impedancji
    omega = 2 * pi * f; % Pulsacja
    term1 = 1 / R^2;
    term2 = (omega * C - 1 / (omega * L))^2;
    denominator = sqrt(term1 + term2);
    
    % Obliczenie modułu impedancji
    Z_abs = 1 / denominator;
    
    % Różnica względem wartości odniesienia
    impedance_delta = Z_abs - M;
end
