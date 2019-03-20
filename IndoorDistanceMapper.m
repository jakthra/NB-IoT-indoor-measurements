%% Map GPS coordinates to indoor distance

addpath utils

% Get position of TX

BS_location = [55.784681, 12.523466];

% Get data of measurements
addpath '343 staircase'
indoor_positions_file_name = '343_staircase_1186.mat';
power_measurements_file_name = '343_staircase_1186.txt';
gpscoordiantes_file_name = '343_staircase_1186.csv';


power_measurements_raw = readtable(power_measurements_file_name);
position_data = load(indoor_positions_file_name);
GPS = GPSmapping(position_data.data, [55.782080, 12.518670], [55.782061, 12.518785]);
Power = postprocess(position_data.data, position_data.timeStamp, power_measurements_raw);


figure('name', 'GPS coordinates');
plot(GPS(2,:), GPS(1,:));
hold on
plot(BS_location(2), BS_location(1),'o')

% Draw approximate wall endpoints

% Find closest point to TX
%gps_distance(BS_location, [])

% Get depth of inner wall to outer wall

% compute, for each position, a distance to the entry point