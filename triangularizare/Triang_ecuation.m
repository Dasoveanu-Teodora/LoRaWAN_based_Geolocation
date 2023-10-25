
% convert the geodetic coordinates (latitude, longitude, altitude)
% to Earth-Centered Earth-Fixed (ECEF) coordinates 
% dist is in metters
 % WGS84 ellipsoid parameters
a = 6378137.0 ;            %WGS84 ellipsoid semi-major axis
f = 1/298.257223563;       % WGS84 ellipsoid flattening
b = a * (1 - f);           %WGS84 ellipsoid semi-minor axis
e = sqrt(1 - b^2/a^2) ;     %eccentricity of the earth


p(1).lat = 44.43505;
p(1).long = 26.027;
p(1).altitude = 145;
p(1).N = a / sqrt(1 - e^2 * (sin(p(1).lat)^2));
p(1).teta = deg2rad(p(1).lat);
p(1).fi  =  deg2rad(p(1).long);
%%aceasta distnata trebuie sa fie calculata pe baza rssi ului 
p(1).x  =  (p(1).N + p(1).altitude ) * sin(p(1).fi)*cos(p(1).teta);
p(1).y  =  (p(1).N + p(1).altitude ) * cos(p(1).fi)*cos(p(1).teta);
p(1).z  =  (p(1).N * (1 - e^2) + p(1).altitude ) * sin(p(1).teta);
dist1 = 211.2436672; 

p(2).lat = 44.43491935;
p(2).long = 26.04574353;
p(2).altitude = 129;
p(2).N = a / (1 - e^2 * (sin(p(2).lat)^2))^0.5;
p(2).teta = deg2rad(p(2).lat);
p(2).fi  =  deg2rad(p(2).long);
%%aceasta distnata trebuie sa fie calculata pe baza rssi ului 
p(2).x  = (p(2).N + p(2).altitude ) * sin(p(2).fi)*cos(p(2).teta);
p(2).y  = (p(2).N + p(2).altitude )* cos(p(2).fi)*cos(p(2).teta);
p(2).z  = (p(2).N * (1 - e^2) + p(2).altitude ) * sin(p(2).teta);
dist2 = 1292.617666; 

p(3).lat = 44.43503229;
p(3).long = 26.0477525;
p(3).altitude = 110;
p(3).N = a / (1 - e^2 * (sin(p(3).lat)^2))^0.5;
p(3).teta = deg2rad(p(3).lat);
p(3).fi  =  deg2rad(p(3).long);
%%aceasta distnata trebuie sa fie calculata pe baza rssi ului 
p(3).x  =  (p(3).N + p(3).altitude ) * sin(p(3).fi)*cos(p(3).teta);
p(3).y  =  (p(3).N + p(3).altitude ) * cos(p(3).fi)*cos(p(3).teta);
p(3).z  =  (p(3).N * (1 - e^2) + p(3).altitude ) * sin(p(3).teta);
dist3 = 1451.107122; 


p(4).lat = 44.41496509;
p(4).long = 26.02938205;
p(4).altitude = 99;
p(4).N = a / (1 - e^2 * (sin(p(4).lat)^2))^0.5;
p(4).teta = deg2rad(p(4).lat);
p(4).fi  =  deg2rad(p(4).long);
%%aceasta distnata trebuie sa fie calculata pe baza rssi ului 
p(4).x  =  (p(4).N + p(4).altitude ) * sin(p(4).fi)*cos(p(4).teta);
p(4).y  =  (p(4).N + p(4).altitude ) * cos(p(4).fi)*cos(p(4).teta);
p(4).z  =  (p(4).N * (1 - e^2) + p(4).altitude ) * sin(p(4).teta);
dist4 = 2305.635681; 
% 
% x0 = (p(1).x + p(2).x + p(3).x) / 3;
% y0 = (p(1).y + p(2).y + p(3).y) / 3;
% z0 = (p(1).z + p(2).z + p(3).z) / 3;


x0 = (p(1).x + p(2).x + p(3).x + p(4).x) / 4;
y0 = (p(1).y + p(2).y + p(3).y + p(4).y) / 4;
z0 = (p(1).z + p(2).z + p(3).z + p(4).z) / 4;

Guess = [x0,y0,z0]
% A = [p(1).x , p(2).x , p(3).x]
% B = [p(1).y , p(2).y , p(3).y]
% C = [p(1).z , p(2).z , p(3).z]
% D = [dist1 , dist2 , dist3];
A = [p(1).x , p(2).x , p(3).x, p(4).x]
B = [p(1).y , p(2).y , p(3).y, p(4).y]
C = [p(1).z , p(2).z , p(3).z, p(4).z]
D = [dist1 , dist2 , dist3,dist4];
[~,LA] = size(A)

[Result,F,J] = MVNewtonsInputs(Guess,A,B,C,D,LA)

% long = atan2(Result(2),Result(1))
% long = rad2deg(long)
% alt = sqrt(Result(1)^2 + Result(2)^2 + Result(3)^2)
% p = sqrt(Result(1)^2 + Result(2)^2 )
% lat = atan2(p,Result(3))
% lat = rad2deg(lat)


p = sqrt(Result(1)^2 + Result(2)^2 )
theta = atan2(Result(3) * a, p * b)

latitude = atan2(Result(3) + e^2 * b * (sin(theta)^3), p - e^2 * a * (cos(theta)^3))

N = a / (1 - e^2 * (sin(latitude)^2))^0.5

longitude = atan2(Result(2), Result(1))
longitude = rad2deg(longitude)
altitude = p / cos(latitude) - N

latitude = rad2deg(latitude)