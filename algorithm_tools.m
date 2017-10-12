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
      % container wrapper
      function obj = ConvolveImages(obj, idx1, idx2)
        i1 = obj.GetModel().GetImageData(idx1);
        i2 = obj.GetModel().GetImageData(idx2);
        cr = conv2(double(i1),double(i2),'same'); % TBD make this proper
        obj.SetResult(cr);
      end        
      function obj = FilterImage(obj, idx, nhood)
        i1 = obj.GetModel().GetImageData(idx);
        cr = medfilt2(double(i1), nhood); % TBD make this proper
        obj.SetResult(cr);
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