function out=imstdxy(x,y,p)
    %
    % imstdxy(x,y,p)
    %
    %	The imaging function that can be used for any sort
    %	of imaging of arrays.  The input array is scaled and shifted
    %   to provide a mean at 128 and 2 standard deviations
    %   within the 0-255 range.  It is displayed as an 8 bit image.
    %
    %   Displays image in xy mode and shows x,y indices on the axes.
    %
    % x     (optional) indices of the x axis pixels
    % y     (optional) indices of the y axis pixels
    % p     Input image array in 'xy' format where p(1,1) corresponds
    %       to the lower left portion of the scene.
    %


    if nargin < 3
        p=x;
        [sy,sx]=size(p);
        x=[0:sx-1];
        y=[0:sy-1];
    end

    pmn=mean(p(:));
    pstd=std(p(:));
    p2=(p-pmn)/pstd;
    z=p2*64+128;

    out=z;

    % image(x,y,z);
    % colormap(gray(256));
    % axis('image');
    % axis xy
end
