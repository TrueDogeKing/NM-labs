function [ft_5, integral_1000, Nt, integration_error] = simpson_rule_accuracy_evaluation()

    %% Parameters and Initialization
    reference_value = 0.0473612919396179; % Reference value of the integral
    a = 0;                                % Lower integration limit
    b = 5;                                % Upper integration limit
    Nt = 5:50:10^4;                       % Array of N values to test
    integration_error = zeros(1, length(Nt)); % Preallocate error array
    
    %% Error Calculation for Different N values
    for i = 1:length(Nt)
        integration_result = simpson_integral(@gaussian_func, a, b, Nt(i));
        integration_error(i) = abs(integration_result - reference_value);
    end
    
    %% Specific Evaluations
    ft_5 = gaussian_func(5);                % Function value at t=5
    integral_1000 = simpson_integral(@gaussian_func, a, b, 1000); % Integral with N=1000
    
    %% Display and Plotting
    disp(['Integral with N=1000: ', num2str(integral_1000)]);
    
    loglog(Nt, integration_error);
    xlabel('Number of intervals (N)');
    ylabel('Integration error');
    title('Accuracy of Simpson''s Rule');
    grid on;
    
    saveas(gcf, 'simpson_rule_accuracy.png');
end

function integral_result = simpson_integral(f, a, b, N)
    % Simpson's rule implementation for numerical integration
    % Inputs:
    %   f - function handle to integrate
    %   a - lower limit
    %   b - upper limit
    %   N - number of intervals (must be even)
    
    dx = (b-a)/N;
    integral_result = 0;
    
    for i = 1:N
        x_left = a + (i-1) * dx;
        x_right = a + i * dx;
        x_mid = (x_left + x_right)/2;
        
        integral_result = integral_result + f(x_left) + 4*f(x_mid) + f(x_right);
    end
    
    integral_result = integral_result * dx / 6;
end

function y = gaussian_func(t)
    % Gaussian probability density function
    % Parameters:
    sigma = 3;   % Standard deviation
    mu = 10;     % Mean
    
    y = 1/(sigma*sqrt(2*pi)) * exp((-(t-mu).^2)/(2*sigma^2));
end