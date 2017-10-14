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
          xp=softpad(i1, params(1),params(1),params(1),params(1));
          cr=conv2(double(xp),(h),'valid');
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