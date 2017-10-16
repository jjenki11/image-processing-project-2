% test rect

function r = test_rect(im_w, im_h, A, B)
    r = zeros(im_w,im_h);
    x0 = round(im_w/2);
    y0 = round(im_h/2);
    for x=0:im_w-1
        for y=0:im_h-1

            if(  (abs(x-x0) <= A/2) && (abs(y-y0) <= B/2)  )
                r(x,y) = 1;
            end
        end
    end
end
