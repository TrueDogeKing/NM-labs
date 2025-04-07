function plot_circles(a, b, circles)
    % 1) Ustawienie wykresu i jego osi
    figure;
    hold on;
    axis equal;
    axis([0 a 0 b]);

    % 2) Rysowanie wszystkich okręgów w pętli
    for i = 1:size(circles, 1)
        x = circles(i, 1);
        y = circles(i, 2);
        r = circles(i, 3);
        plot_circle(r, x, y);  % Wywołanie funkcji rysującej pojedynczy okrąg
        
        % pause(0.1);  % (opcjonalnie) Pozwala obserwować proces dodawania kolejnych okręgów
    end

    saveas(gcf, 'zadanie1.png');

    hold off;
end
