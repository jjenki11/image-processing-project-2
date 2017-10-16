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
      
      function obj = DoSinusoid(obj, params, dest)          
%          s_img = obj.GenerateSinusoid(6, params);
        sin_shape= algorithm_tools(obj.GetModel());
               sin_shape.Sinusoid(params);
               x=sin_shape.GetResult();
         obj.GenerateImageIcon(6, x, dest);          
      end
      
      function obj = DoSingleCircle(obj, params, dest)          
        circ_shape= algorithm_tools(obj.GetModel());
        circ_shape.SingleCircle(params);
        x=circ_shape.GetResult();
        obj.GenerateImageIcon(6, x, dest);          
      end
      
      function obj = DoSingleRectangle(obj, params, dest)          
        rect_shape= algorithm_tools(obj.GetModel());
        rect_shape.SingleRectangle(params);
        x=rect_shape.GetResult();
        obj.GenerateImageIcon(6, x, dest);          
      end
      
      function obj = DoMultipleCircles(obj, params, dest)          
        circ_shape= algorithm_tools(obj.GetModel());
        circ_shape.MultipleCircles(params);
        x=circ_shape.GetResult();
        obj.GenerateImageIcon(6, x, dest);          
      end
      
      function obj = DoMultipleRectangles(obj, params, dest)          
        rect_shape= algorithm_tools(obj.GetModel());
        rect_shape.MultipleRectangles(params);
        x=rect_shape.GetResult();
        obj.GenerateImageIcon(6, x, dest);          
      end
      
      function obj = DoSingleStripe(obj, params, dest) 
        stripe_shape= algorithm_tools(obj.GetModel());
        stripe_shape.SingleStripe(params);
        x=stripe_shape.GetResult();
        obj.GenerateImageIcon(6, x, dest);     
      end
      
      function obj = DoMultipleStripes(obj, params, dest) 
        stripe_shape= algorithm_tools(obj.GetModel());
        stripe_shape.MultipleStripes(params);
        x=stripe_shape.GetResult();
        obj.GenerateImageIcon(6, x, dest);     
      end
      
      function obj = DoFiltering(obj, fType, params, dest, variety,dest2)
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
                switch(variety)
                    case 'ideal'
                        x = obj.DoLowpassIdealFilter(params);
                        obj.GenerateImageIcon(5, x, dest);                        
                    case 'gaussian'
                        x = obj.DoLowpassGaussianFilter(params);
                        obj.GenerateImageIcon(5, x, dest);
                    case 'butterworth'
                        x = obj.DoLowpassButterworthFilter(params);
                        obj.GenerateImageIcon(5, x, dest);
                    otherwise
                        disp('bad filter type')
                end       
            case 'highpass'
                switch(variety)
                    case 'ideal'
                        x = obj.DoHighpassIdealFilter(params);
                        obj.GenerateImageIcon(5, x, dest);                        
                    case 'gaussian'
                        x = obj.DoHighpassGaussianFilter(params);
                        obj.GenerateImageIcon(5, x, dest);
                    case 'butterworth'
                        disp('i am doing the right hpbutterworth call...')
                        x = obj.DoHighpassButterworthFilter(params);
                        obj.GenerateImageIcon(5, x, dest);
                    otherwise
                        disp('bad filter type')
                end       

            case 'bandpass'
                switch(variety)
                    case 'ideal'
                        x = obj.DoBandpassIdealFilter(params);
                        obj.GenerateImageIcon(5, x, dest);                        
                    case 'gaussian'
                        x = obj.DoBandpassGaussianFilter(params);
                        obj.GenerateImageIcon(5, x, dest);
                    case 'butterworth'
                        x = obj.DoBandpassButterworth(params);
                        obj.GenerateImageIcon(5, x, dest);
                    otherwise
                        disp('bad filter type')
                end       
            case 'bandreject'
                switch(variety)
                    case 'ideal'
                        x = obj.DoBandrejectIdealFilter(params);
                        obj.GenerateImageIcon(5, x, dest);                        
                    case 'gaussian'
                        x = obj.DoBandrejectGaussianFilter(params);
                        obj.GenerateImageIcon(5, x, dest);
                    case 'butterworth'
                        x = obj.DoBandrejectButterworthFilter(params);
                        obj.GenerateImageIcon(5, x, dest);
                    otherwise
                        disp('bad filter type')
                end   
                
            case 'notch reject'
            % kept this in here since we want to observe this window as a 
            % literal controller
                button=0;
                xi = obj.DoNotchFilterInit(4);
                X=fft2(double(xi));
                [N,M]=size(xi);
                midu = (fix(M/2)+1);
                midv = (fix(N/2)+1);
                X2 = X;
                button = 0;
                % filter half width and height
                half_width = 7;
                half_height = 7;
                H = ones( N, M );                
                disp('Left Mouse to selected notch frequency, right to exit')
                while button~=3
                    f2 = figure(888);
                    im(abs(fftshift(X2)), 0, 0, 3 );
                    title('Image Magnitude Spectrum');
                    [x0,y0,button] = ginput(1);
                    x0 = round(x0);
                    y0 = round(y0);
                    %make sure the selected points are at least 
                    % at a distance more than half the width and height of the filter 
                    x0( x0 < half_width+2 ) = half_width + 2;
                    x0( x0 > M - half_width ) = M - half_width;
                    y0( y0 < half_height+2 ) = half_height + 2;
                    y0( y0 > N - half_height ) = N - half_height;
                    % starting and end point of the notch filter in x and y
                    stx = x0-half_width;
                    edx = x0+half_width;
                    sty = y0-half_height;
                    edy = y0+half_height;
                    % starting and end point of the notch filter conjugate point in x and y
                    stx2 = 2*midu - edx;
                    edx2 = 2*midu - stx;
                    sty2 = 2*midv - edy;
                    edy2 = 2*midv - sty;
                    % apply the notch filter
                    H(sty:edy,stx:edx) = 0;
                    H(sty2:edy2,stx2:edx2) = 0;
                    X2 = X2.*ifftshift(H);
                    x2 = ifft2(X2);  
                    obj.GenerateImageIcon(5, x2, dest);
                end
                obj.GenerateImageIcon(5, x2, dest);
                close(f2);
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
       
       %    high pass filters       
       function r = DoHighpassIdealFilter(obj, params)
        hpideal_filter = algorithm_tools(obj.GetModel());
        hpideal_filter.HPFIdeal(4, params);
        r = hpideal_filter.GetResult();
       end
       function r = DoHighpassGaussianFilter(obj, params)
        hpgauss_filter = algorithm_tools(obj.GetModel());
        hpgauss_filter.HPFGaussian(4, params);
        r = hpgauss_filter.GetResult();
       end       
       function r = DoHighpassButterworthFilter(obj, params)
        hpbutter_filter = algorithm_tools(obj.GetModel());
        hpbutter_filter.HPFButterworth(4, params);
        r = hpbutter_filter.GetResult();
       end
       
      %    low pass filters       
       function r = DoLowpassIdealFilter(obj, params)
        lpideal_filter = algorithm_tools(obj.GetModel());
        lpideal_filter.LPFIdeal(4, params);
        r = lpideal_filter.GetResult();
       end
       function r = DoLowpassGaussianFilter(obj, params)
        lpgauss_filter = algorithm_tools(obj.GetModel());
        lpgauss_filter.LPFGaussian(4, params);
        r = lpgauss_filter.GetResult();
       end       
       function r = DoLowpassButterworthFilter(obj, params)
        lpbutter_filter = algorithm_tools(obj.GetModel());
        lpbutter_filter.LPFButterworth(4, params);
        r = lpbutter_filter.GetResult();
       end
       
       function r = DoBandpassIdealFilter(obj, params)
        bpideal_filter = algorithm_tools(obj.GetModel());
        bpideal_filter.BandpassIdeal(4, params);
        r = bpideal_filter.GetResult();
       end
       
       function r = DoBandpassGaussianFilter(obj, params)
        bpbutter_filter = algorithm_tools(obj.GetModel());
        bpbutter_filter.BandpassGaussian(4, params);
        r = bpbutter_filter.GetResult();
       end
       
       function r = DoBandpassButterworth(obj, params)
        bpbutter_filter = algorithm_tools(obj.GetModel());
        bpbutter_filter.BandpassButterworth(4, params);
        r = bpbutter_filter.GetResult();
       end
       
       
       function r = DoBandrejectIdealFilter(obj, params)
        brideal_filter = algorithm_tools(obj.GetModel());
        brideal_filter.BandrejectIdeal(4, params);
        r = brideal_filter.GetResult();
       end
       
       function r = DoBandrejectGaussianFilter(obj, params)
        brgauss_filter = algorithm_tools(obj.GetModel());
        brgauss_filter.BandrejectGaussian(4, params);
        r = brgauss_filter.GetResult();
       end
       
       function r = DoBandrejectButterworthFilter(obj, params)
        brbutter_filter = algorithm_tools(obj.GetModel());
        brbutter_filter.BandrejectButterworth(4, params);
        r = brbutter_filter.GetResult();
       end
       
       function r = DoNotchFilterInit(obj, idx)
           nr_filter = algorithm_tools(obj.GetModel());
           nr_filter.NotchFilterInit(idx);
           r = nr_filter.GetResult();
       end
       
       
       function r = GenerateSinusoid(obj, idx, params, dest)
        sin_shape = algorithm_tools(obj.GetModel());
        sin_shape.Sinusoid(params);
        r = sin_shape.GetResult();           
       end
       
       
       
      function obj = GenerateImageIcon(obj, idx, data, dest)
        obj.GetModel().CreateImage(idx, data, imresize(data,obj.img_icon));
        obj.GetView().UpdateImage(dest, obj.GetModel().GetImageIcon(idx),1); 
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