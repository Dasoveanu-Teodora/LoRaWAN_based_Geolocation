%This function creates the vector F for the function of the GPS satellite
%positions for the Multi Variable Newtons Method solver for the GPS 
%equations.

%The amount of rows in the vector depends on the amount of satellites

%The inputs for the function are 
  % A, B, and C are the coordinates of the satellites
  % D is the distnace calculated with RSSI  
  % G is the current guess
  % LengthA is the amount of satellites (equal to the length of the vector A)

function ResultF=FCreator(G,LengthA,A,B,C,D)


%The first row of the vector F will always be in the equation since there will
%always be at least 1 satellite.
F=(G(1)-A(1))^2+(G(2)-B(1))^2+(G(3)-C(1))^2-D(1)^2;

%This iteration adds the approiate row to the vector F.
for i = 2:LengthA
    F = [F;(G(1)-A(i))^2+(G(2)-B(i))^2+(G(3)-C(i))^2 - D(i)^2];
end
ResultF=F;