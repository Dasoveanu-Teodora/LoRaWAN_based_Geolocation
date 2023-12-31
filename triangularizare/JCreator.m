%This function creates the matrix D, the Jacobian of F, for the function of the 
%GPS satellite positions for the Multi Variable Newtons Method solver for the  
%GPS equations.

%The amount of rows in the vector depends on the amount of satellites

%The inputs for the function are 
  %A, B, and C are the coordinates of the satellites
  %G is the current guess
  %t is the given time error
  %LengthA is the amount of satellites (equal to the length of the vector A)

function ResultJ=JCreator(G,LengthA,A,B,C)

%The first row of the Jacobian will always be in the equation since there will
%always be at least 1 satellite.
J = [2*(G(1)-A(1)),2*(G(2)-B(1)),2*(G(3)-C(1))];

%This iteration adds the approiate row to the Jacobian.
for i = 2:LengthA
    J = [J; 2*(G(1)-A(i)) 2*(G(2)-B(i)) 2*(G(3)-C(i))];
end
ResultJ=J;