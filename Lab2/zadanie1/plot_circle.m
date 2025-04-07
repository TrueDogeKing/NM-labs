function plot_circle(r, x, y)
    theta = linspace(0, 2*pi, 100);
    X = r*cos(theta) + x;
    Y = r*sin(theta) + y;
    plot(X, Y, 'k-') % 'k-' means black line
end