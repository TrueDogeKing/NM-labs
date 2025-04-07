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