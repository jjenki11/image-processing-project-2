%% Sinusoids - specifiy frequencies u0 and v0 and amplitude
clear, clc, close all
t = linspace(0,10,200);
A0 = 100; % amplitude
u0 = 100; % frequency in Hz
func1 = A0*sin(2*pi*u0*t);
v0 = 200; % frequency in Hz
func2 = A0*cos(2*pi*v0*t);
func = [func1; func2];
plot(t,func)
% Magnitude and Phase plots
[magn, phas]= imspecxy(double(func));
im(magn); title('Magnitude')
im(phas); title ('Phase')

%% Single Circle - specify distance from origin and radius
clear, clc, close all
% Initialize an image to hold one single big circle.
bigCircleRadius = 250;    % big circle radius - define this parameter
bigImageWidth = bigCircleRadius*2;
bigImageHeight =  bigCircleRadius*2;
bigCircleImage = zeros(bigImageHeight, bigImageWidth);
[x, y] = meshgrid(1:bigImageWidth, 1:bigImageHeight);
bigCircleImage((x - bigImageWidth/2).^2 + (y - bigImageHeight/2).^2 <= bigCircleRadius.^2) = 1
imshow(bigCircleImage, []);
% Magnitude and Phase plots
[magn phas] = imspecxy(double(bigCircleImage));
im(magn); title('Magnitude')
im(phas); title ('Phase')
%% Single Rectangle - specify distance from origin, length and width
clear, clc, close all
I = zeros(256);
x_min = 10;
x_max = 120;
y_min = 10;
y_max = 40;
x = [x_min, x_max]; % first number sets distance from top left corner in x-direction; second number sets x_max
y = [y_min, y_max]; % first number sets distance from top left corner in y-direction; second number sets y_max
I = drawrectangle(I, x, y);
imshow(I);
func = double(I);
% Magnitude and Phase plots
[magn phas] = imspecxy(double(func));
im(magn); title('Magnitude')
im(phas); title ('Phase')
%% Mulitple CIrcles - number of circles, spacing and radius of each
clear, clc, close all

%%
func = 
[magn phas] = imspecxy(double(func));
im(magn); title('Magnitude')
im(phas); title ('Phase')
%% Mulitple Rectangles - number of rectangles, spacing and length and width
clear, clc, close all
img = zeros(256);
x_min = 10;
x_max = 200;
y_min = 10;
y_max = 30;
x = [x_min, x_max]; % first number sets distance from top left corner in x-direction; second number sets x_max
y = [y_min, y_max]; % first number sets distance from top left corner in y-direction; second number sets y_max
spacing_y = 10; % sets spacing between rectangles in y-direction
yy = y_max+spacing_y; % sets spacing while avoiding overlap between rectangles;
spacing = [yy yy];
n = 7; % number of rectangles
for i=1:n 
    y(1, :) = y(1, :) + spacing;
    img = drawrectangle(img, x, y(1, :));
end
imshow(img);
% Magnitude and Phase plots
func = double(img);
[magn phas] = imspecxy(double(func));
im(magn); title('Magnitude')
im(phas); title ('Phase')
%% Single Stripe - size of stripes and spacing of stripes
clear, clc, close all

func = ;
[magn phas] = imspecxy(double(func));
im(magn); title('Magnitude')
im(phas); title ('Phase')
%% Multiple Stripes - specify spacing from each other, number of stripes, and size of stripes
clear, clc, close all

func = 
[magn phas] = imspecxy(double(func));
im(magn); title('Magnitude')
im(phas); title ('Phase')