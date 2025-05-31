function [x, y, z, zmin, lake_volume] = compute_lake_volume_monte_carlo()

    N = 1e6;
    N1 = 0;

    zmin = -60;

    x = 100*rand(1,N); % [m]
    y = 100*rand(1,N); % [m]
    z = zmin * rand(1,N); % [m]

    for i = 1:N
        x_i = x(i);
        y_i = y(i);
        z_i = z(i);
        depth = get_lake_depth(x_i, y_i);
        if z_i >= depth
            N1 = N1 + 1;
        end
    end
    cuboid_volume = 100 * 100 * abs(zmin);
    lake_volume = cuboid_volume * N1 / N;
    disp(lake_volume);
end
