function bearing = compute_bearing(pointA, pointB)

    lat1 = deg2rad(pointA(1));
    lat2 = deg2rad(pointB(1));

    diffLong = deg2rad(pointB(2) - pointA(2));

    x = sin(diffLong) * cos(lat2);
    y = cos(lat1) * sin(lat2) - (sin(lat1) * cos(lat2) * cos(diffLong));

    initial_bearing = atan2(x, y);
    initial_bearing = rad2deg(initial_bearing);
    bearing = (initial_bearing + 360); % 360

end