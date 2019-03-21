%% Map GPS coordinates to indoor distance

addpath utils
addpath openstreetmap\
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

%% Visualization of end mapping
% Read building positions
S = shaperead('buildings_osm_clipped_with_height_v4.shp');
geoshow(S)

utmstruct = defaultm('utm'); 
utmstruct.zone = '32N';  
utmstruct.geoid = wgs84Ellipsoid;
utmstruct = defaultm(utmstruct);
[x,y] = mfwdtran(utmstruct,GPS(1,:),GPS(2,:));

geoshow(S)
hold on
plot(x,y,'o')

%% Indoor distance mapping
% Determine closet entry point. This is assumed to be the outer most point,
% thus everything from here on out is indoor.
% A width margin can be added here to account for wall width and elevation
% TODO: entrypoint should be a point in 3D space
% TODO: save results in .mat file

for iGPS = 1:length(GPS)
	distances(iGPS) = gps_distance(BS_location, GPS(:,iGPS));
end

% Find closets point
[minDistance, idxminDistance] = min(distances);

% Plot
figure
plot(x,y,'bo')
hold on
plot(x(idxminDistance),y(idxminDistance),'ro')


% Find distance from points to entry point
for iIndoor = 1:length(GPS)
	indoorDistances(iIndoor) = gps_distance(GPS(:,idxminDistance), GPS(:,iIndoor));
end

% Plot of raw measurements
figure
plot(indoorDistances,Power,'o')
xlabel('Indoor distance [m]')
ylabel('RSSI [dBm]')

% Raw measurements are not super pretty. 
% Bin the measurements and calculate the mean 
[B,Bedge,idx] = histcounts(indoorDistances, 15);
V = accumarray(idx(:),Power,[],@mean);
figure
plot(indoorDistances,Power,'o')
hold on
plot(Bedge(1:end-1), V,'-o','LineWidth', 2)
xlabel('Indoor distance')
ylabel('Power [dBm] \mu')
legend('Raw measurements','Binned mean')
grid
