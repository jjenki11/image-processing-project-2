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
      function obj = MedianFilter(obj, idx, nhood)
        i1 = obj.GetModel().GetImageData(idx);
        cr = medfilt2(double(i1), nhood); % TBD make this proper
        obj.SetResult(cr);
      end
      
      function obj = AverageFilter(obj, idx, nhood)
        i1 = obj.GetModel().GetImageData(idx);
        cr = filter2(fspecial('average',nhood),i1);
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