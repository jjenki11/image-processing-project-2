
function r = mycirc(im_w, im_h, rd)
    r = zeros(im_w,im_h);
    x0 = round(im_w/2);
    y0 = round(im_h/2);    
    for x=0:im_w-1
        for y=0:im_h-1
            xx = abs(x-x0);
            yy = abs(y-y0);
            if(sqrt(xx.^2 + yy.^2) < rd)
                r(x,y) = 255;
            end
        end
    end
end
