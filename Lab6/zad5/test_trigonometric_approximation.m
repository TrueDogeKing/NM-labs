function [dates, y, M, a, b, x_fine, ya, rmse_values] = test_trigonometric_approximation()

    % ... Twój kod test_trigonometric_approximation ...
    
    % Przykład poprawnego wywołania funkcji z dołączonymi pomocniczymi funkcjami poniżej
    M = 20; 
    load energy_2025

    C = 'Poland';  
    S = 'Solar';

    dates = energy_2025.(C).(S).Dates;
    y = energy_2025.(C).(S).EnergyProduction;

    N = numel(y);
    x = (0:N-1)';
    k_max = floor(N/2);

    Mx = 4; 
    x_fine = linspace(0,N-1,Mx*(N-1)+1)';

    [a, b] = calculate_ab_from_DFT(y);
    
    ya = trigonometric_approximation(x_fine, N, M, a, b);

    rmse_values = zeros(k_max,1);
    for k = 1:k_max
        ya4rmse = trigonometric_approximation(x, N, k, a, b);
        rmse_values(k) = sqrt(mean((y - ya4rmse).^2));
    end

    figure
    subplot(2,1,1)
    plot(1:k_max, rmse_values, 'b-', 'LineWidth', 2)
    title('RMSE aproksymacji trygonometrycznej vs liczba harmonicznych')
    xlabel('Liczba harmonicznych')
    ylabel('RMSE')

    subplot(2,1,2)
    plot(dates, y, 'k-', 'DisplayName', 'Dane oryginalne')
    hold on
    dates_fine = linspace(dates(1), dates(end), length(x_fine));
    plot(dates_fine, ya, 'r--', 'DisplayName', ['Aproksymacja M=' num2str(M)])
    hold off
    title(['Aproksymacja trygonometryczna danych - M = ' num2str(M)])
    xlabel('Data')
    ylabel('Produkcja energii')
    legend show
end


function ya = trigonometric_approximation(x_fine, N, M, a, b)
    if(N == 0)
        ya = [];
        return;
    end

    k_max = length(a) - 1;
    ya = zeros(length(x_fine), 1);

    ya = ya + a(1);  % składowa stała

    if(M > k_max)
        M = k_max;
    end

    for n = 1:M
        ya = ya + a(n+1)*cos(2*pi*n*x_fine/N) + b(n+1)*sin(2*pi*n*x_fine/N);
    end
end


function [a, b] = calculate_ab_from_DFT(x)
    if(length(x) == 0)
        a = [];
        b = [];
        return
    end
    N = length(x);
    Y = fft(x);
    k_max = floor(N/2);

    a = zeros(k_max+1, 1);
    b = zeros(k_max+1, 1);

    a(1) = real(Y(1)) / N;

    for n = 1:k_max
        idx = n + 1;
        is_nyquist = (mod(N, 2) == 0) && (n == N/2);
        if is_nyquist
            a(idx) = real(Y(n+1)) / N;
            b(idx) = 0;
        else
            a(idx) = 2 * real(Y(n+1)) / N;
            b(idx) = -2 * imag(Y(n+1)) / N;
        end
    end
end
