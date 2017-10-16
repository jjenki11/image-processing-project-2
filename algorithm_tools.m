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
        cr = conv2(double(i1),double(i2),'same'); % TBD make this proper
        obj.SetResult(cr);
      end        
      
      function obj = DiskFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        h=fspecial('disk',params(1));
        xp=softpad(i1, params(1),params(1),params(1),params(1));
        cr=conv2(double(xp), h, 'valid');
        obj.SetResult(cr);
      end
      
      function obj = AverageFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        h = fspecial('average',[params(1), params(2)]);
        xp=softpad(i1, max(params),max(params),max(params),max(params)); 
        cr = conv2(double(xp),h,'valid');
        obj.SetResult(cr);
      end
      
      function obj = MotionFilter(obj, idx, params)
          i1 = obj.GetModel().GetImageData(idx);
          h = fspecial('motion', params(1), params(2));
          xp=softpad(i1, max(params(1:2)),max(params(1:2)),max(params(1:2)),max(params(1:2)));
          cr = conv2(double(xp), double(h),'valid');
          obj.SetResult(cr);
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
          xp=softpad(i1, 10,10,10,10);
          cr=conv2((xp),(h),'valid');
          obj.SetResult(cr);  
      end
      
      function obj = GaussianFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        hx = fspecial('gaussian',[1,params(1)],params(3)) ;
        hy = fspecial('gaussian',[params(2),1],params(3)) ;
        hx2=repmat(hx,[params(2),1]); 
        hy2=repmat(hy,[1,params(1)]);
        h=hx2.*hy2;
        xp=softpad(i1, max(params(1:2)),max(params(1:2)),max(params(1:2)),max(params(1:2)));
        cr=conv2(double(xp), h, 'valid'); 
        obj.SetResult(cr);  
      end
      
      function obj = LogFilter(obj, idx, params)
        i1 = obj.GetModel().GetImageData(idx);
        h=fspecial('log',[params(1) params(2)],params(3));
        xp=softpad(i1, max(params(1:2)),max(params(1:2)),max(params(1:2)),max(params(1:2)));
        cr=conv2(double(xp), h, 'valid');
        obj.SetResult(cr); 
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
        D0=.12; %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = .05; % width of band
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
        D0=.12; %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = .05; % width of band
        n = 5;
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
        D0=.12; %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = .05; % width of band
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
        D0=.12; %cutoff frequency
        D=sqrt(F1.^2+F2.^2);        
        D(D==0)=eps; % prevent divide by zero
        W = .05; % width of band
        n = 5;
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