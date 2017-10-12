function out=imlinxy(x,y,p);
%
% out=imlinxy(x,y,p);
%
% Maps 'p' into a range of 0-255 for
% grayscale image display.
% It maps the higest value in 'p' to 255 and
% the lowest to 0.  It maps in between values linearly.
% Displays image in xy mode and shows x,y indices on the axes.
%
% x     (optional) indices of the x axis pixels
% y     (optional) indices of the y axis pixels
% p     Input image array in xy format where p(1,1) corresponds
%       to the lower left portion of the scene.
%
% Dr. Russell Hardie
% University of Dayton
% 3/1/02

if nargin < 3
    p=x;
    [sy,sx]=size(p);
    x=[0:sx-1];
    y=[0:sy-1];
end

% make double if it is not
p=double(p);

% map into 0-255 range
z=p-min(p(:));
z=z*255/max(z(:));

out=z;

% image(x,y,z);
% colormap(gray(256));
% axis('image');
% axis xy