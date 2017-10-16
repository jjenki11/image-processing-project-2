function r = mysinusoid(im_w, im_h, u0, v0)
    W = im_w;
    H = im_h; 
    u = u0/W;
    v = v0/H;
    r = zeros(W, H);
    for m = 0 : H-1 
        for n = 0 : W-1
            r(m + 1, n + 1) = (1/2 * ( (exp(i*2*pi*(u*(m+1) + v*(n+1))) + (exp(-i*2*pi*(u*(m+1) + v*(n+1))))    ) ));%cos(2*pi*(1/u*(m+1) + 1/v*(n+1)));
        end
    end
end