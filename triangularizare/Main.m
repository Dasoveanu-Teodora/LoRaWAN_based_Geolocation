clear;
clc;
%% Calculate ECEF Coordinates Using Geodetic Coordinates

%geodetic coordinates of the end device
%used to calculate dostnaces between end dev and gateways
%these distances are used only to create the algorithm
% for the final project it will be used the distances measured with RSSI


RSSI_0 = -25.4828;
d_0 = 1;


doc = 'G:\My Drive\Date_Lora.csv';
sol = 'G:\My Drive\Solution.csv';
table_data = readtable(doc,"Format","auto"); % load data into a table


[masuratori, fields] = size(table_data);
index = [];

if(table_data.NoGateways(:) ~= 3) 
   disp("Invalid constelation")
else
   disp(" Valid constelation")
end

wgs84 = wgs84Ellipsoid('meter');



k = 1;
i = 1;
while (k <= masuratori)
  if(table_data.NoGateways(k) == 3)
    
    Result = zeros(1,3);
    p(i,1).lat = table_data.latitude0(k);
    p(i,1).long = table_data.longitude0(k);
    p(i,1).altitude = table_data.altitude0(k);
    p(i,1).RSSI = table_data.rssi0(k);
    p(i,1).SNR = table_data.snr0(k);
    p(i,1).path_loss = distr_path_loss( p(i,1).SNR);
    [p(i,1).x, p(i,1).y,p(i,1).z] = geodetic2ecef(wgs84, p(i,1).lat,p(i,1).long, p(i,1).altitude)
    
    
    p(i,1).distance = RSSI2Distance( p(i,1).RSSI,RSSI_0, p(i,1).path_loss,d_0)
    
  
    p(i,2).lat = table_data.latitude1(k);
    p(i,2).long = table_data.longitude1(k);
    p(i,2).altitude = table_data.altitude1(k);
    p(i,2).RSSI = table_data.rssi1(k);
    p(i,2).SNR = table_data.snr1(k);
    p(i,2).path_loss = distr_path_loss( p(i,2).SNR);
    [p(i,2).x, p(i,2).y,p(i,2).z] = geodetic2ecef(wgs84, p(i,2).lat,p(i,2).long, p(i,2).altitude)
    
    
    p(i,2).distance = RSSI2Distance( p(i,2).RSSI,RSSI_0, p(i,2).path_loss,d_0)
    
    p(i,3).lat = table_data.latitude2(k);
    p(i,3).long =  table_data.longitude2(k);
    p(i,3).altitude = table_data.altitude2(k);
    p(i,3).RSSI = table_data.rssi2(k);
    p(i,3).SNR = table_data.snr2(k);
    p(i,3).path_loss = distr_path_loss( p(i,3).SNR);
    [p(i,3).x, p(i,3).y,p(i,3).z] = geodetic2ecef(wgs84, p(i,3).lat,p(i,3).long, p(i,3).altitude)
    
    
    p(i,3).distance = RSSI2Distance( p(i,3).RSSI,RSSI_0, p(i,3).path_loss,d_0)
    
    x0 = (p(i,1).x + p(i,2).x + p(i,3).x) / 3;
    y0 = (p(i,1).y + p(i,2).y + p(i,3).y) / 3;
    z0 = (p(i,1).z + p(i,2).z + p(i,3).z) / 3;
    
    Guess = [x0,y0,z0];

   
   
    A = [p(i,1).x , p(i,2).x , p(i,3).x]
    B = [p(i,1).y , p(i,2).y , p(i,3).y]
    C = [p(i,1).z , p(i,2).z , p(i,3).z]
    
    D_RSSI =  [p(i,1).distance , p(i,2).distance , p(i,3).distance];
    
    [~,LA] = size(A);
    
    [Result,F,J] = MVNewtonsInputs(Guess,A,B,C,D_RSSI,LA);
    % h is ellipsoidal height
    [loc(i).lat,loc(i).lon,loc(i).alt] = ecef2geodetic(wgs84,Result(1),Result(2),Result(3))
    
    % N The geoid models the average sea level of the Earth
    N = geoidheight(loc(i).lat,loc(i).lon,'egm2008')
    
   
    loc(i).alt = N;
    sol_data(i,:) = table_data(k,:);
    

    i = i + 1;
  end

  k = k + 1 ;
end  

sol_data.sol_Lat = zeros(i-1,1);
sol_data.sol_Long = zeros(i-1,1);
sol_data.sol_Alt = zeros(i-1,1);

for j = 1 : (i-1)
  sol_data.sol_Lat(j) = loc(j).lat;
  sol_data.sol_Long(j) = loc(j).lon;
  sol_data.sol_Alt(j) = loc(j).alt;
end  
%writetable(table_data,doc)
writetable(sol_data,sol)
