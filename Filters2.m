%%
%%HPF (Gaussian )%%
x=double(imread('cameraman.tif'));
pad = 25; 
x=padarray(x,[pad,pad],'symmetric','both' );
X=fft2(x);
[N,M]=size(x); 
f1 = ( [1:M] - (floor(M/2)+1) )/M;
f2 = ( [1:N] - (floor(N/2)+1) )/N;
[F1,F2]=meshgrid(f1,f2); 
D0=.1;
%n=2;
D=sqrt(F1.^2+F2.^2);
D(D==0)=eps; % prevent divide by zero
%H=1./(1+(D0./D).^(2*n));
H=1-exp(-(D.^2./(2*D0.^2)));
figure; mesh(f1,f2,H);
xlabel('f1 cycles/sample');
ylabel('f2 cycles/sample');
title('H(f1,f2)')
H2=ifftshift(H); 
Y=H2.*X;
y=ifft2(Y);
im( x(pad+1:end-pad,pad+1:end-pad) );
title('Input');
im( y(pad+1:end-pad,pad+1:end-pad) );
title('Output') 
%%
%%HPF (Butterworth )%%
x=double(imread('cameraman.tif'));
pad = 25; 
x=padarray(x,[pad,pad],'symmetric','both' );
X=fft2(x);
[N,M]=size(x); 
f1 = ( [1:M] - (floor(M/2)+1) )/M;
f2 = ( [1:N] - (floor(N/2)+1) )/N;
[F1,F2]=meshgrid(f1,f2); 
D0=.2;
n=2;
D=sqrt(F1.^2+F2.^2);
D(D==0)=eps; % prevent divide by zero
H=1./(1+(D0./D).^(2*n));
figure; mesh(f1,f2,H);
xlabel('f1 cycles/sample');
ylabel('f2 cycles/sample');
title('H(f1,f2)')
H2=ifftshift(H); 
Y=H2.*X;
y=ifft2(Y);
im( x(pad+1:end-pad,pad+1:end-pad) );
title('Input');
im( y(pad+1:end-pad,pad+1:end-pad) );
title('Output') 

%%
%%Notch Filter%%
clc
clear all
x = imread('car.png');
x=rgb2gray(x);
imshow(x)
% imspec(x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X=fft2(double(x));

[N,M]=size(x);
midu = (fix(M/2)+1);
midv = (fix(N/2)+1);

X2 = X;
button = 0;
% filter half width and height
half_width = 7;
half_height = 7;

H = ones( N, M );
figure(1)
im(x,0)
title('Input Image');
clc
disp('Left Mouse to selected notch frequency, right to exit')

while button~=3
    figure(2)
    im(abs(fftshift(X2)), 0, 0, 3 );
    title('Image Magnitude Spectrum');
    [x0,y0,button] = ginput(1);
    x0 = round(x0);
    y0 = round(y0);
    %make sure the selected points are at least 
    % at a distance more than half the width and height of the filter 
    x0( x0 < half_width+2 ) = half_width + 2;
    x0( x0 > M - half_width ) = M - half_width;
    y0( y0 < half_height+2 ) = half_height + 2;
    y0( y0 > N - half_height ) = N - half_height;
    % starting and end point of the notch filter in x and y
    stx = x0-half_width;
    edx = x0+half_width;
    sty = y0-half_height;
    edy = y0+half_height;
    % starting and end point of the notch filter conjugate point in x and y
    stx2 = 2*midu - edx;
    edx2 = 2*midu - stx;
    sty2 = 2*midv - edy;
    edy2 = 2*midv - sty;
    % apply the notch filter
    H(sty:edy,stx:edx) = 0;
    H(sty2:edy2,stx2:edx2) = 0;
   
    X2 = X2.*ifftshift(H);
    x2 = ifft2(X2);  
    figure(3)
    fh=im(x2,0);
    title('Output Image');
    pause(1)
    clf(fh)
end
%% LowPass Filter( Gussian)
clc
clear all
close all
x=double(imread('cameraman.tif'));
X=fft2(x);
[N,M]=size(x);
 
u = ( [1:M] - (fix(M/2)+1) )/M; 
v = ( [1:N] - (fix(N/2)+1) )/N;
[U,V]=meshgrid(u,v);
 

D=U.^2+V.^2;
D0 = .1;  % cycles/sample
H = exp( -D/(2*D0^2));

  
figure; mesh(u,v,H);xlabel('u cycles/sample'); 
ylabel('v cycles/sample'); title('H(u,v)')
 
H2=ifftshift(H);
figure
mesh(U,V,H2)
Y=H2.*X;
y=ifft2(Y);
im(x); title('Input'); im(y); title('Output')
%% LowPass Filter(Butterworth )
clc
clear all
close all
x=double(imread('cameraman.tif'));
X=fft2(x);
[N,M]=size(x);
 
u = ( [1:M] - (fix(M/2)+1) )/M; 
v = ( [1:N] - (fix(N/2)+1) )/N;
[U,V]=meshgrid(u,v);
 
n=2;
D=sqrt(U.^2+V.^2);
D0 = .1;  % cycles/sample
%H = exp( -D/(2*freq_gauss_std^2));
H=1./(1+(D./D0).^(2*n));
  
figure; mesh(u,v,H);xlabel('u cycles/sample'); 
ylabel('v cycles/sample'); title('H(u,v)')
 
H2=ifftshift(H);
figure
mesh(U,V,H2)
Y=H2.*X;
y=ifft2(Y);
im(x); title('Input'); im(y); title('Output')