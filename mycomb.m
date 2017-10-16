
function r = mycomb(im_w, im_h, A, B)    
    comb_x = mysinusoid(im_w, im_h, A+1, 0);    
    comb_y = mysinusoid(im_w, im_h, 0, B+1);    
    cx = ~(comb_x < .9);    
    cy = ~(comb_y < .9);    
    r = (cx.*cy);
end
