classdef algorithm_tools < handle
   properties
        % tbd we can put parent in here so we dont have to pass it
        DataModel = struct
        Result
   end
   methods
      
      % constructor for the algorithm tools class
      function obj = algorithm_tools(dm)
            % all initializations, calls to base class, etc. here,
            obj.SetModel(dm);
      end
      % conv2 wrapper
      function obj = ConvolveImages(obj, idx1, idx2)
        i1 = obj.GetModel().GetImageData(idx1);
        i2 = obj.GetModel().GetImageData(idx2);
        [sx1,sy1]=size(i1);
        [sx2,sy2]=size(i2);
        pad = min([sx1,sy1,sx2,sy2]);
        xp=softpad(i1,pad,pad,pad,pad); 
        cr = conv2(double(xp),double(i2),'valid'); % TBD make this proper
        obj.SetResult(cr(pad+1:end-pad,pad+1:end-pad));
      end        
      
      function obj = DiskFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        h=fspecial('disk',params(1));
        pad=max(params(1));
        xp=softpad(i1,pad,pad,pad,pad); 
        cr=conv2(double(xp), h, 'valid');
        obj.SetResult(cr(pad+1:end-pad,pad+1:end-pad));
      end
      
      function obj = AverageFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        h = fspecial('average',[params(1), params(2)]);
        pad=max(params(1:2));
        xp=softpad(i1,pad,pad,pad,pad); 
        cr = conv2(double(xp),h,'valid');
        obj.SetResult(cr(pad+1:end-pad,pad+1:end-pad));
      end
      
      function obj = MotionFilter(obj, idx, params)
          i1 = obj.GetModel().GetImageData(idx);
          h = fspecial('motion', params(1), params(2));
          pad=max(params(1:2));
          xp=softpad(i1,pad,pad,pad,pad); 
          cr = conv2(double(xp), double(h),'valid');
          obj.SetResult(cr(pad+1:end-pad,pad+1:end-pad));
      end
      
      function obj = SobelFilter(obj, idx, params)
          i1 = obj.GetModel().GetImageData(idx);
          h=fspecial('sobel');
          cr=conv2(double(i1), h,'valid');
          obj.SetResult(cr);    
      end
      
      function obj = LaplacianFilter(obj, idx, params)
          i1 = obj.GetModel().GetImageData(idx);
          h=fspecial('laplacian',params(1));
          cr=conv2((i1),(h),'valid');
          obj.SetResult(cr);  
      end
      
      function obj = GaussianFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        hx = fspecial('gaussian',[1,params(1)],params(3)) ;
        hy = fspecial('gaussian',[params(2),1],params(3)) ;
        hx2=repmat(hx,[params(2),1]); 
        hy2=repmat(hy,[1,params(1)]);
        h=hx2.*hy2;
        pad=max(params(1:2));
        xp=softpad(i1,pad,pad,pad,pad);
        cr=conv2(double(xp), h, 'valid'); 
        obj.SetResult(cr(pad+1:end-pad,pad+1:end-pad));  
      end
      
      function obj = LogFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        h=fspecial('log',[params(1) params(2)],params(3));
        pad=max(params(1:2));
        xp=softpad(i1,pad,pad,pad,pad);
        cr=conv2(double(xp), h, 'valid');
        obj.SetResult(cr(pad+1:end-pad,pad+1:end-pad)); 
      end
      
      function obj = PrewittFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        h=fspecial('prewitt');
        cr=conv2(double(i1), h, 'valid');
        obj.SetResult(cr); 
      end
      
      function obj = UnsharpFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        h=fspecial('unsharp',params(1));
        cr=conv2(double(i1), h, 'valid');
        obj.SetResult(cr); 
      end
      
      % Low pass filters
      
      function obj = LPFIdeal(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);
        D(D==0)=eps; % prevent divide by zero
        H = (D <= D0);
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);          
      end
      
      function obj = LPFGaussian(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        X=fft2(x);
        [N,M]=size(x);
        u = ( [1:M] - (fix(M/2)+1) )/M; 
        v = ( [1:N] - (fix(N/2)+1) )/N;
        [U,V]=meshgrid(u,v);
        D=U.^2+V.^2;
        D0 = params(1);  % cycles/sample
        H = exp( -D/(2*D0^2));
        H2=ifftshift(H);
        Y=H2.*X;
        y=ifft2(Y);
        cr=y;
        obj.SetResult(cr); 
      end
      
      function obj = LPFButterworth(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        X=fft2(x);
        [N,M]=size(x);
        u = ( [1:M] - (fix(M/2)+1) )/M; 
        v = ( [1:N] - (fix(N/2)+1) )/N;
        [U,V]=meshgrid(u,v);
        n=params(2);
        D=sqrt(U.^2+V.^2);
        D0 = params(1);  % cycles/sample
        H=1./(1+((D./D0).^(2*n)));
        H2=ifftshift(H);
        Y=H2.*X;
        y=ifft2(Y);
        cr=y;
        obj.SetResult(cr); 
      end
      % High pass filters
      
      function obj = HPFIdeal(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);
        D(D==0)=eps; % prevent divide by zero
        H = (D > D0);
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);          
      end
      
      function obj = HPFGaussian(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);
        D(D==0)=eps; % prevent divide by zero
        H=1-exp(-(D.^2./(2*D0.^2)));
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);           
      end
      
      function obj = HPFButterworth(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1);
        n=params(2);
        D=sqrt(F1.^2+F2.^2);
        D(D==0)=eps; % prevent divide by zero
        H=1./(1+(D0./D).^(2*n));
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr); 
      end
      
      % Band pass filters
      
      function obj = BandpassIdeal(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = params(2); % width of band
        h1 = (D >= (D0 - (W/2)));
        h2 = (D <= (D0 + W/2));        
        H = h1 .* h2;
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);          
      end
      
      function obj = BandpassGaussian(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = params(2); % width of band
        dw = D*W;
        dw(dw==0)=eps;
        numer = D.^2.-D0.^2;
        numer(numer==0)=eps;
        H = 1-(1-(exp(-(numer./dw).^2)));
%         figure,imshow(H)
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);          
      end
      
      function obj = BandpassButterworth(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = params(2); % width of band
        n = params(3);
        dw = D*W;
        dw(dw==0)=eps;
        denom = D.^2.-D0.^2;
        denom(denom==0)=eps;
        H = 1 - (1 ./ (1 + (dw./denom).^(2*n)) );
%         im(H)
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);          
      end
      
      % bandreject filters
      function obj = BandrejectIdeal(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = params(2); % width of band
        h1 = (D >= (D0 - (W/2)));
        h2 = (D <= (D0 + W/2));        
        H = 1 - (h1 .* h2);
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);          
      end
      
      function obj = BandrejectGaussian(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = params(2); % width of band
        dw = D*W;
        dw(dw==0)=eps;
        numer = D.^2.-D0.^2;
        numer(numer==0)=eps;
        H = (1-(exp(-(numer./dw).^2)));
%         figure,imshow(H)
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);          
      end
      
      function obj = BandrejectButterworth(obj, idx, params)
        x = obj.GetModel().GetImageData(idx);
        pad = 25; 
        x=padarray(x,[pad,pad],'symmetric','both' );
        X=fft2(x);
        [N,M]=size(x); 
        f1 = ( [1:M] - (floor(M/2)+1) )/M;
        f2 = ( [1:N] - (floor(N/2)+1) )/N;
        [F1,F2]=meshgrid(f1,f2); 
        D0=params(1); %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = params(2); % width of band
        n = params(3);
        dw = D*W;
        dw(dw==0)=eps;
        denom = D.^2.-D0.^2;
        denom(denom==0)=eps;
        H = (1 ./ (1 + (dw./denom).^(2*n)) );
        H2=ifftshift(H); 
        Y=H2.*X;
        y=ifft2(Y);
        cr = y(pad+1:end-pad,pad+1:end-pad);
        obj.SetResult(cr);          
      end
      
      function obj = NotchFilterInit(obj,idx)
        x = obj.GetModel().GetImageData(idx);
        obj.SetResult(x);
      end
      
      function obj = MagnitudeImage(obj, idx)
        in = obj.GetModel().GetImageData(idx);
        X=fftshift(fft2(in));
        [sy,sx]=size(in);
        w1=linspace(-pi,pi,sx);
        w2=linspace(-pi,pi,sy);
        offset=1;   % tbd change to parameter
        mag=imlinxy(w1,w2,log(abs(X)+offset));
        obj.SetResult(mag);        
      end
      
      function obj = PhaseImage(obj, idx)
        in = obj.GetModel().GetImageData(idx);
        X=fftshift(fft2(in));
        [sy,sx]=size(in);
        w1=linspace(-pi,pi,sx);
        w2=linspace(-pi,pi,sy);
        phase=imlinxy(w1,w2,angle(X));
        obj.SetResult(phase);
      end
      
      
      % shape generator
      function obj = Sinusoid(obj, params)
        s_img = mysinusoid(250, 250, params(1), params(2));        
        obj.SetResult((s_img));
      end
      
      function obj = SingleCircle(obj, params)
        s_img = mycirc(250, 250, params(1)).*255;        
        obj.SetResult((s_img));
      end
      
      function obj = SingleRectangle(obj, params)
        s_img = myrect(250, 250, params(1), params(2)).*255;        
        obj.SetResult((s_img));
      end
      
      function obj = MultipleCircles(obj, params)
        c_grid = mycomb(1000, 1000, params(2), params(3)).*255;
        s_img = mycirc(params(1)*2, params(1)*2, params(1)).*255;        
        c_res = conv2(c_grid, s_img, 'valid');
        obj.SetResult((c_res));
      end
      
      function obj = MultipleRectangles(obj, params)
        c_grid = mycomb(1000, 1000, params(3), params(4));
        bigger_dim = max(params(1:2));
        s_img = myrect(bigger_dim*2, bigger_dim*2, params(1), params(2));        
        c_res = conv2(c_grid, s_img, 'valid');
        obj.SetResult((c_res));
      end
      
      function obj = SingleStripe(obj, params)
        if((params(1) == 90) || (params(1) == 270))
            s_img = ~(mysinusoid(250, 250, 1, 0)>.25).*255;
        else
            s_img = (mysinusoid(250,250, 0, 1)>.25).*255;
        end
        obj.SetResult((s_img));
      end
      
      function obj = MultipleStripes(obj, params)
        if((params(2) == 90) || (params(2) == 270))
            s_img = ~(mysinusoid(250, 250, params(1), 0)>.25).*255;
        else
            s_img = (mysinusoid(250,250, 0, params(1))>.25).*255;
        end
        obj.SetResult((s_img));
      end
      
      % gets the model
      function r = GetModel(obj)
          r = obj.DataModel;
      end
      % gets the result of convolution
      function r = GetResult(obj)
          r = obj.Result;
      end
      % sets the model
      function obj = SetModel(obj, m)
          obj.DataModel = m;
      end
      % sets the result
      function obj = SetResult(obj, r)
          obj.Result = r;
      end
   end
end