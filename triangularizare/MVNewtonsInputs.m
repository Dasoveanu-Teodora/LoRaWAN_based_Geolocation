%This function is the multivariable Newtons and Gauss-Newtons methods for 
%solving the GPS equations.

%The inputs for the function are 
  %A, B, and C are the coordinates of the satellites
  %Guess is the first guess
  %t is the given time error
  %LA is the amount of satellites (equal to the length of the vector A)

function [Result,F,J]=MVNewtonsInputs(Guess,A,B,C,D,LA)

%Guess is transposed so it will work in the function in Newton's Method
Guess0 = Guess;



%F is the function of the satellites positions in vector form.
%J is the Jacobian of F

%FCreator and DCreator are functions that create the vectors/matrices for F and
%J. They take the satellite coordinates, the distances, the amount of 
%satellites and the current guess as inputs. These functions exist so non linear
%systems of any amount of satellites can be created easily.

F=FCreator(Guess0,LA,A,B,C,D);
J=JCreator(Guess0,LA,A,B,C);

%Error and iteration are values that are used in Newton's method
%Error is preset to 1 so the method will iterate
%Iterations is set to 1 to count how many iterations it takes to get to the
%error tolerance
%error=1;
Iterations=1;
max_iter = 50;
tol = 1e-2;

%This while loop is Newton's/Gauss Newton method for more than 1 dimension
%It iterates through the Newtons/Gauss Newton method 20 times
while Iterations < max_iter
    %V is the solution to the Jacobian and the function at the first
    %current guess
  % display("iteration");
   % display(Iterations);
%     F=FCreator(Guess0,LA,A,B,C,D)
%     J=JCreator(Guess0,LA,A,B,C)
    dG = (J\(-F))';

    %The next guess is the previous guess added to V
    Guess = (Guess0 + dG);
    
    F = FCreator(Guess,LA,A,B,C,D);
    J = JCreator(Guess,LA,A,B,C);
    
    %This is the backward error, the distance between F evaluated at the
    %current guess and zero. This is the error the loop is controlled by
   
    %display("norm");
    %norm(Guess)
%     if(norm(Guess) < tol)
%       Result = Guess;
%       display("Solution found");
%       break;
%     end  
    Guess0 = Guess;
    %Iterations increases the iterations counter
    Iterations = Iterations+1;
end
%display("Maximum iterations exceeded.");
%error;
%Iterations
%This outputs the values for x, y, z
Result = Guess;