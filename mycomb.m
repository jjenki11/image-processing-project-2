
function r = mycomb(shp, im_w, im_h, A, B)    
    rm = repmat(shp,A,B);
    r = imresize(rm,[im_w,im_h]);
end
