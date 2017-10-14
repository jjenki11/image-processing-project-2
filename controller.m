classdef controller < handle
   properties
        % tbd we can put parent in here so we dont have to pass it
        img_icon = [250 250]; 
        DataModel = struct
        View
        Result
   end
   methods
      
      % constructor for the algorithm tools class
      function obj = controller(dm, vw)
        % all initializations, calls to base class, etc. here,
        obj.SetModel(dm);
        obj.SetView(vw);            
      end
      
      function obj = SelectFile(obj, parent, txt, idx, i_update)
         p = obj.GetView().FileBrowser(parent,[0.1 0.37 0.4 0.2],[]);
        set(txt,'String',p);
        img = imread(p); sz = size(img);
        if(numel(sz)>2) 
            img = rgb2gray(img); 
        end
        obj.GenerateImageIcon(idx, img, i_update);
      end
      
      function obj = Reset(obj, img, content)
        obj.GetView().UpdateImage(img, content);
      end
      
      function obj = SaveImage(obj, idx, p)
        xx = obj.GetModel().GetImageData(idx);
        maxv = max(xx(:));
        mapped_array = uint8((double(xx) ./ maxv) .* 255);
        colormap(gray(255));
        obj.GetView().FileSaver(p, [0.1, 0.37, 0.4, 0.2], mapped_array);
        disp('File saved!'); 
      end
      
      function obj = DoConvolution(obj, slot)
        convolution = algorithm_tools(obj.GetModel());        
        convolution.ConvolveImages(1,2);        
        x = convolution.GetResult();        
        obj.GenerateImageIcon(3, x, slot);
      end
      
      function obj = DoFiltering(obj, fType, params, dest)
        % we check the filter type to choose correct controller call 
        switch(fType)            
            case 'average'
                x = obj.DoAverageFilter(params);
                obj.GenerateImageIcon(5, obj.DoAverageFilter(params), dest);
            case 'disk'
                x = obj.DoDiskFilter(params);
                obj.GenerateImageIcon(5, x, dest);
            case 'gaussian'
                x = obj.DoGaussianFilter(params);
                obj.GenerateImageIcon(5, x, dest);
            case 'laplacian'
                x = obj.DoLaplacianFilter(params);
                obj.GenerateImageIcon(5, x, dest);
            case 'log'
                x = obj.DoLogFilter(params);
                obj.GenerateImageIcon(5, x, dest);
            case 'motion'
                x = obj.DoMotionFilter(params);
                obj.GenerateImageIcon(5, x, dest);
            case 'sobel'
                x = obj.DoSobelFilter(params);
                obj.GenerateImageIcon(5, x, dest);
            case 'prewitt'
                x = obj.DoPrewittFilter(params);
                obj.GenerateImageIcon(5, x, dest);
            case 'unsharp'
                x = obj.DoUnsharpFilter(params);
                obj.GenerateImageIcon(5, x, dest);
                
            %   still need to implement the frequency filters!
            case 'lowpass'
                disp('TBD - implement lowpass filter')
            case 'highpass'
                disp('TBD - implement highpass filter')
            case 'bandpass'
                disp('TBD - implement bandpass filter')
            case 'bandreject'
                disp('TBD - implement bandreject filter')
            case 'notch reject'
                disp('TBD - implement notch reject filter')
            otherwise
                disp('Invalid filter type' );
        end        
      end
      
       function r = DoAverageFilter(obj, params)      
        avg_filter = algorithm_tools(obj.GetModel());     
        avg_filter.AverageFilter(4,params);        
        r = avg_filter.GetResult();          
       end
      
       function r = DoDiskFilter(obj, params)      
        disk_filter = algorithm_tools(obj.GetModel());     
        disk_filter.DiskFilter(4,params);        
        r = disk_filter.GetResult();          
       end
       
       function r = DoMotionFilter(obj, params)      
        motion_filter = algorithm_tools(obj.GetModel());     
        motion_filter.MotionFilter(4,params);        
        r = motion_filter.GetResult();          
       end
       
       function r = DoLaplacianFilter(obj, params)      
        laplacian_filter = algorithm_tools(obj.GetModel());     
        laplacian_filter.LaplacianFilter(4,params);        
        r = laplacian_filter.GetResult();          
       end
       
       function r = DoSobelFilter(obj, params)      
        sobel_filter = algorithm_tools(obj.GetModel());     
        sobel_filter.SobelFilter(4,params);        
        r = sobel_filter.GetResult();          
       end
       
       function r = DoGaussianFilter(obj, params)      
        gaussian_filter = algorithm_tools(obj.GetModel());     
        gaussian_filter.GaussianFilter(4,params);        
        r = gaussian_filter.GetResult();          
       end
       
       function r = DoLogFilter(obj, params)      
        log_filter = algorithm_tools(obj.GetModel());     
        log_filter.LogFilter(4,params);        
        r = log_filter.GetResult();          
       end
       
       function r = DoPrewittFilter(obj, params)      
        prewitt_filter = algorithm_tools(obj.GetModel());     
        prewitt_filter.PrewittFilter(4,params);        
        r = prewitt_filter.GetResult();          
       end
       
       function r = DoUnsharpFilter(obj, params)      
        unsharp_filter = algorithm_tools(obj.GetModel());     
        unsharp_filter.UnsharpFilter(4,params);        
        r = unsharp_filter.GetResult();          
       end
      
      function obj = GenerateImageIcon(obj, idx, data, dest)
        obj.GetModel().CreateImage(idx, data, imresize(data,obj.img_icon));
        obj.GetView().UpdateImage(dest, obj.GetModel().GetImageIcon(idx)); 
      end
      
      function obj = SetModel(obj,m)
          obj.DataModel = m;
      end
      
      function obj = SetView(obj,v)
          obj.View = v;
      end
      
      function r = GetModel(obj)
          r = obj.DataModel;
      end
      
      function r = GetView(obj)
          r = obj.View;
      end
   end
end