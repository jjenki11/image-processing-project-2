close all;

W = 256; H = 128;  nChannel = 3;
Xx = [0:W-1];
Yy = [0:H-1];

u = 1/256;
v = 0;
phase = v;

[X,Y] = meshgrid(Xx,Yy);
phaseRGB = 2*pi*phase;
freqRGB = u;
angleRGB = 2*pi*(v);
figure,
imshow( (sin(2*pi*freqRGB.*((X.*cos(angleRGB )+ Y.*sin(angleRGB)))+v) +1)/2);



fs = 1/150;   %//FOR RED CHANNEL
W = 256;
H = 256; 

img1 = zeros(256, 256);
img2 = zeros(256, 256);

for m = 0 : H-1 
    for n = 0 : W-1
        img1(m + 1, n + 1) = -sin(2*pi*fs*m) - cos(2*pi*fs*n);
        img2(m + 1, n + 1) = sin(2*pi*fs*m) - cos(2*pi*fs*n);
    end
end


x=linspace(-pi, pi, 100);
sf=2; % spatial freq in cycles per image
vf=2;
sinewave=sin(x*sf); 
coswave =cos(x*vf);
onematrix=ones(size(sinewave));
sinewave2D=(onematrix'*coswave);

figure,imshow(sinewave2D);

xx = (sinewave2D)/255;

imspecxy(xx);


u0 = 0;
v0 = 2;

W = 256;
H = 256; 
u = u0/W;
v = v0/H;
img1 = zeros(W, H);
for m = 0 : H-1 
    for n = 0 : W-1
        img1(m + 1, n + 1) = (1/2 * ( (exp(i*2*pi*(u*(m+1) + v*(n+1))) + (exp(-i*2*pi*(u*(m+1) + v*(n+1))))    ) ));%cos(2*pi*(1/u*(m+1) + 1/v*(n+1)));
    end
end
figure,imagesc(~(img1>.5)); colormap gray;

imspecxy(img1)















