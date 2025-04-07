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
