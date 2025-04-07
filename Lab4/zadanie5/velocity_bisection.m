function [xvec,xdif,xsolution,ysolution,iterations] = velocity_bisection()

% velocity_bisection - Znajduje czas, w którym rakieta osiąga prędkość 700 m/s metodą bisekcji.
% xvec - Wektor z kolejnymi przybliżeniami miejsca zerowego
% xdif - Wektor różnic kolejnych przybliżeń
% xsolution - Obliczone miejsce zerowe (czas)
% ysolution - Wartość funkcji velocity_difference w xsolution
% iterations - Liczba iteracji wykonana do znalezienia rozwiązania

    % Ustalanie zakresu poszukiwań i parametrów bisekcji
    a = 1;  % Lewa granica przedziału
    b = 40; % Prawa granica przedziału
    ytolerance = 1e-12; % Tolerancja dla wartości funkcji
    max_iterations = 1000; % Maksymalna liczba iteracji
    
    % Obliczenie wartości funkcji na końcach przedziału
    fa = velocity_difference(a);
    fb = velocity_difference(b);
    
    % Sprawdzenie warunku zmiany znaku funkcji w przedziale [a, b]
    if fa * fb > 0
        error('Funkcja nie zmienia znaku w podanym przedziale [a, b]. Wybierz inny przedział.');
    end
    
    % Inicjalizacja zmiennych
    xvec = [];
    xdif = [];
    
    for ii = 1:max_iterations
        % Obliczenie środka przedziału
        c = (a + b) / 2;
        xvec(ii, 1) = c;
        fc = velocity_difference(c);
        
        % Sprawdzenie kryterium stopu
        if abs(fc) < ytolerance
            xsolution = c;
            ysolution = fc;
            iterations = ii;
            xdif(ii-1, 1) = abs(xvec(ii) - xvec(ii-1));
            break;
        end
        
        % Wybór nowego przedziału zgodnie z metodą bisekcji
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
    
    % Rysowanie wykresów
    figure;
    
    % Wykres kolejnych przybliżeń miejsca zerowego
    subplot(2,1,1);
    plot(xvec, 'o-');
    xlabel('Iteracja');
    ylabel('Przybliżenie czasu');
    title('Metoda bisekcji - Przybliżenia czasu');

    % Wykres logarytmiczny różnic między przybliżeniami
    subplot(2,1,2);
    semilogy(xdif, 'o-');
    xlabel('Iteracja');
    ylabel('Różnica kolejnych przybliżeń');
    title('Metoda bisekcji - Zbieżność');

    saveas(gcf, 'velocity_bisection.png');

end

% ----------------------------------------------------------------------------
% Definicja funkcji velocity_difference
    function velocity_delta = velocity_difference(t)

    % t - czas od startu rakiety [s]
    % velocity_delta - różnica prędkości rakiety względem wartości odniesienia (700 m/s)

    % Parametry rakiety i Księżyca
    g = 1.622;       % Przyspieszenie grawitacyjne na Księżycu [m/s^2]
    u = 2000;     % Prędkość wyrzucania gazów [m/s]
    m_0 = 150000;   % Masa początkowa rakiety [kg]
    q = 2700;       % Tempo spalania paliwa [kg/s]
    M = 700; % Wartość odniesienia prędkości [m/s]

    % Sprawdzenie poprawności czasu
    if t <= 0
        error('Czas musi być większy od zera.');
    end

    % Obliczenie prędkości rakiety zgodnie z równaniem (3)
    v_t = u * log(m_0 / (m_0 - q * t)) - g * t;

    % Różnica względem wartości odniesienia (równanie 4)
    velocity_delta = v_t - M;
end
