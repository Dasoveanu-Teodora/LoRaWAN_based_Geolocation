# LoRaWAN_based_Geolocation
The goal of the project is to localise an end-device (LoRa node) using
geo positioning and the concept of trilateration.
Instead of using the NavStar satellites, LoRaWAN Gateways are used as
anchors. This allows for faster and more reliable localisation compared
to other systems. It’s also modular and it can be integrated with bigger
LoRa applications .
For solving the Trilateration I have implemented a Matlab code that
solves a system of three quadratic equations using multivariate
Newton’s method.
