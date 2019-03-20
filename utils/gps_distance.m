function [distance] = gps_distance(pos1,pos2)
% Returns distance in meters

% approximate radius of earth in km
R = 6373.0;
lat1 = deg2rad(pos1(1));
lon1 = deg2rad(pos1(2));

lat2 = deg2rad(pos2(1));
lon2 = deg2rad(pos2(2));

dlon = lon2 - lon1;
dlat = lat2 - lat1;

a = sin(dlat / 2)^2 + cos(lat1) * cos(lat2) * sin(dlon / 2)^2;
c = 2 * atan2(sqrt(a), sqrt(1 - a));
distance = R*c*1000;
end
