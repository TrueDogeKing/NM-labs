function main 
    n_max = 200;
    [circles, a, b, r_max] = generate_circles(n_max);
    plot_circles(a, b, circles);
end
