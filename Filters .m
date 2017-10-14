%% Disk Filter %%
% clc;clear all
x=double(imread('cameraman.tif'));
h=fspecial('disk',10);
%mesh(h)
%im(x) %%without padding
y=conv2(x, h, 'same'); 
im(y)
y2=imfilter(x,h);
im(y2) %with padding
xp=padarray(x, [10,10], 'symmetric', 'both' ); 
yp=conv2(xp, h, 'valid');
im(yp) 

%% Motion Filter %%%
originalRGB = imread('cameraman.tif'); 
% imshow(originalRGB);
h = fspecial('motion', 50, 45);
filteredRGB = imfilter(originalRGB, h); 
figure
% imshow(filteredRGB);

%% sobel Filter %%
% clc;clear all
x=double(imread('cameraman.tif'));
h=fspecial('sobel');
mesh(h)
im(x) 
y=conv2(x, h, 'same'); 
%im(y)
y2=imfilter(x,h);
%im(y2) 
xp=padarray(x, [10,10], 'symmetric', 'both' ); 
yp=conv2(xp, h, 'valid');
%im(yp) 

%% Laplacian Filter %%
%%clc;clear all
x=double(imread('cameraman.tif'));
h=fspecial('laplacian',0.5);% size is mhxnh=21x21 
%mesh(h)
%im(x) 
y=conv2(x, h, 'same'); 
%im(y)
y2=imfilter(x,h);
%im(y2) 
xp=padarray(x, [10,10], 'symmetric', 'both' ); 
yp=conv2(xp, h, 'valid');
%im(yp) 

%% Average Filter %%
%%clc;clear all
x=double(imread('cameraman.tif'));
h=fspecial('average',[3 3]);
%mesh(h)
%im(x) 
y=conv2(x, h, 'same'); 
%im(y)
y2=imfilter(x,h);
%im(y2) 
xp=padarray(x, [10,10], 'symmetric', 'both' ); 
yp=conv2(xp, h, 'valid');
%im(yp) 

%% Gaussian Filter %%
clc;clear all
x=double(imread('cameraman.tif')); 
hx = fspecial('gaussian',[1,9],3) ;
hy = fspecial('gaussian',[9,1],3) ;
hx2=repmat(hx,[9,1]); 
hy2=repmat(hy,[1,9]);
h=hx2.*hy2;
%mesh(h)
hgauss=fspecial('gaussian',[9,9],3); 
%im(x) 
y=conv2(x, h, 'same'); 
%im(y)
y2=imfilter(x,h); 
%im(y2) %with padding
xp=padarray(x, [10,10], 'symmetric', 'both' );
yp=conv2(xp, h, 'valid'); 
%im(yp)

%% Log Filter %%
%%clc;clear all
x=double(imread('cameraman.tif'));
h=fspecial('log',[3 3],0.5);
%mesh(h)
%im(x) 
y=conv2(x, h, 'same'); 
%im(y)
y2=imfilter(x,h);
%im(y2) 
xp=padarray(x, [10,10], 'symmetric', 'both' ); 
yp=conv2(xp, h, 'valid');
%im(yp) 

%% Prewitt Filter %%
%%clc;clear all
x=double(imread('cameraman.tif'));
h=fspecial('prewitt');
%mesh(h)
%im(x) 
y=conv2(x, h, 'same'); 
%im(y)
y2=imfilter(x,h);
%im(y2) 
xp=padarray(x, [10,10], 'symmetric', 'both' ); 
yp=conv2(xp, h, 'valid');
%im(yp) 

%% Unsharp Filter %%
%%clc;clear all
x=double(imread('cameraman.tif'));
h=fspecial('unsharp',0.3);
%mesh(h)
%im(x) 
y=conv2(x, h, 'same'); 
%im(y)
y2=imfilter(x,h);
%im(y2) 
xp=padarray(x, [10,10], 'symmetric', 'both' ); 
yp=conv2(xp, h, 'valid');
%im(yp) 

