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
            case 'median'
                x = obj.DoMedianFilter(params);
                obj.GenerateImageIcon(5, x, dest);
            case 'average'
                disp('TBD - implement average filter')
            case 'disk'
                disp('TBD - implement disk filter')
            case 'gaussian'
                disp('TBD - implement gaussian filter')
            case 'laplacian'
                disp('TBD - implement laplacian filter')
            case 'log'
                disp('TBD - implement log filter')
            case 'motion'
                disp('TBD - implement motion filter')
            case 'sobel'
                disp('TBD - implement sobel filter')
            case 'prewitt'
                disp('TBD - implement prewitt filter')
            case 'unsharp'
                disp('TBD - implement unsharp filter')
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
%         if(x)  end
      end
      
      function r = DoMedianFilter(obj, params)      
        med_filter = algorithm_tools(obj.GetModel());     
        med_filter.MedianFilter(4,[params(1), params(2)]);        
        r = med_filter.GetResult();          
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