classdef model_factory  < handle
   properties
        ImageIcon
        ImageData
        Images = struct
   end
   methods       
      % constructor for our 'image data model' 
      function obj = model_factory()
            % all initializations, calls to base class, etc. here,
      end
      % creates an image struct with given index, image and thumbnail
      function obj = CreateImage(obj, idx, data, icon)
        obj.SetImageData(idx, data);
        obj.SetImageIcon(idx, icon);
      end          
      % sets the actual image data
      function obj = SetImageData(obj, idx, d)
          obj.Images(idx).ImageData = d;
      end      
      % sets the thumbnail image
      function obj = SetImageIcon(obj, idx, ic)
          obj.Images(idx).ImageIcon = ic;
      end      
      % gets the actual image data
      function r = GetImageData(obj, idx)
          r = obj.Images(idx).ImageData;
      end
      % gets the thumbnail image
      function r = GetImageIcon(obj, idx)
          r = obj.Images(idx).ImageIcon;
      end
   end
end