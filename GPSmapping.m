% Script for mapping indoor measurements of NB IoT to GPS coordinates
% Finger print:
%   Takes a GPS coordinate, corresponding to (0,0) in indoor measurements
%   Takes a dataset of distances in x,y coordinates
%
%   Maps each coordinate in dataset to a gps location

function GPS = GPSmapping(indoorpositions, cali_P1, cali_P2)
    close all;
    
    %Earth radius from wiki
    eRadius = 6371008.8; %in meters
    %Length between 1 decimal degree of latitudes
    latLen = 111320; %in meters
    
    %read gps callibration point 1 
    %latRx1 = 55.782080;
    %lonRx1 = 12.518670;
		latRx1 = cali_P1(1);
		lonRx1 = cali_P1(2);
    %read gps callibration point 2 (for angle)
    %latRx2 = 55.782061;
    %lonRx2 = 12.518785;
		latRx2 = cali_P2(1);
		lonRx2 = cali_P2(2);
			
    %Rx equipment start position (0,0) best estimate
    %databar 343 (room 009) south east corner
    %lat 55.782153, lon 12.518290
    %Hallway at stairs east end of 343 north west corner:
    %lat 55.782064, lon 12.518691
    
    latRx =55.782064; %latRx1; %55.782153; % 
    lonRx =12.518691; %lonRx1; %12.518290; % 
    
    %read gps coordinate of Tx equipment
    latTx = 55.78436582959851;
    lonTx = 12.522821925170433;

    %Distance in meters:
    %Between calibration point 1 and TX
    [distHarv1, DistPyth1] = lldistkm([latRx1 lonRx1],[latTx lonTx]);
    %Between calibration point 2 and TX
    [distHarv2, DistPyth2] = lldistkm([latRx2 lonRx2],[latTx lonTx]);
    %Between the 2 calibration points
    [distHarv3, DistPyth3] = lldistkm([latRx1 lonRx1],[latRx2 lonRx2]);
    %compute angle
    b= (latRx2 -latRx1)*latLen;
    theta =  asin(b/distHarv3);


    %Assume latRx and lonRx corresponds to (0,0) in dataset

    %load(dataname,'data','metaData','timeStamp');
    data = indoorpositions/100; % Convert to m
    
    
    %Flip some axis. Flipping depends on orientation. For north west flip
    %Y, for south east flip X.
    data(2,:) = -1*data(2,:);

    %Rotate to match building
    G = data;
    G(1,:) = data(1,:)*cos(theta)-data(2,:)*sin(theta);
    G(2,:) = data(1,:)*sin(theta)+data(2,:)*cos(theta);

    %compute gps coordinate matrix.
    GPS = G;
    GPS(1,:) = latRx + 180/pi * G(2,:)/eRadius;
    GPS(2,:) = lonRx + 180/pi * (G(1,:)/eRadius) /cos(pi/180 * latRx);
    
    %Plot for sanity check
    %figure('name', '2D data');
    %plot(data(1,:),data(2,:));
    
    %figure('name', 'GPS coordinates');
    %plot(GPS(2,:), GPS(1,:));
    
    %Save as .csv file
    %DataTemp = rot90(GPS,3);
    %Data=DataTemp;
    %Data(:,1) = DataTemp(:,2);
    %Data(:,2) = DataTemp(:,1);
    
    %Create a folder
    %foldername = 'CSV_KML_data';
    %if ~exist(foldername,'dir')
    %    mkdir(foldername);
    %end
    
    %dlmwrite([foldername '/' dataname(1:end-4) '.csv'], Data,  'precision', 18);
    
    %Save as .kml file for import in Google Earth or similar
    %simple_kml_writer([foldername '/' dataname(1:end-4)],Data);
    
    
    %load power measurements
    %P = postprocess(dataname,[dataname(1:end-4) '.txt']);
    %plot power
    %figure('name', 'Recieved power');
    %scatter(data(1,:),data(2,:),[],P,'filled');
    %colorbar;
    
    
end






