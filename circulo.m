function [X2,Y2,Z2] = circulo(x,y,z,r)
X = x-r:x+r;
Y = y-r:y+r;
cuadrado = meshgrid(X,Y);
end