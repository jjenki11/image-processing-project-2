classdef controller < handle
   properties
        img_icon = [250 250]; 
        DataModel = struct
        View
        Result
   end
   methods      
      % constructor for the algorithm tools class
      function obj = controller(vw)
        obj.SetModel(model_factory());
        obj.SetView(vw);            
      end
  %     select image from file
      function obj = SelectFile(obj, parent, txt, idx, i_update)
         p = obj.GetView().FileBrowser(parent,[0.1 0.37 0.4 0.2],[]);
        if exist(p, 'file') == 2
            set(txt,'String',p);
            img = imread(p); sz = size(img);
            if(numel(sz)>2) 
                img = rgb2gray(img); 
            end
            obj.GenerateImageIcon(idx, img, i_update);
        else
            disp('Please select a valid file');
        end
      end
      % reset the image at the index  provided with content
      function obj = Reset(obj, img, content)
        obj.GetView().UpdateImage(img, content);
      end
  %     save image to file
      function obj = SaveImage(obj, idx, p)
        xx = obj.GetModel().GetImageData(idx);
        maxv = max(xx(:));
        mapped_array = uint8((double(xx) ./ maxv) .* 255);
        colormap(gray(255));
        obj.GetView().FileSaver(p, [0.1, 0.37, 0.4, 0.2], mapped_array);        
      end
  %     convolution
      function obj = DoConvolution(obj, slot)
        convolution = algorithm_tools(obj.GetModel());        
        convolution.ConvolveImages(1,2);        
        obj.GenerateImageIcon(3, convolution.GetResult(), slot);
      end
  %     sinusoids
      function obj = DoSinusoid(obj, params, dest, sz, idx)          
        sin_shape= algorithm_tools(obj.GetModel());
        sin_shape.Sinusoid(params, sz);
        obj.GenerateImageIcon(idx, sin_shape.GetResult(), dest);          
      end
  %     circles
      function obj = DoSingleCircle(obj, params, dest, sz, idx)          
        circ_shape= algorithm_tools(obj.GetModel());
        circ_shape.SingleCircle(params, sz);
        obj.GenerateImageIcon(idx, circ_shape.GetResult(), dest);          
      end
      function obj = DoMultipleCircles(obj, params, dest, sz,idx)          
        circ_shape= algorithm_tools(obj.GetModel());
        circ_shape.MultipleCircles(params,sz);
        obj.GenerateImageIcon(idx, circ_shape.GetResult(), dest);          
      end
  %     rectangles
      function obj = DoSingleRectangle(obj, params, dest, sz, idx)          
        rect_shape= algorithm_tools(obj.GetModel());
        rect_shape.SingleRectangle(params, sz);
        obj.GenerateImageIcon(idx, rect_shape.GetResult(), dest);          
      end
      function obj = DoMultipleRectangles(obj, params, dest, sz,idx)          
        rect_shape= algorithm_tools(obj.GetModel());
        rect_shape.MultipleRectangles(params,sz);
        obj.GenerateImageIcon(idx, rect_shape.GetResult(), dest);          
      end
  %     stripes
      function obj = DoSingleStripe(obj, params, dest, sz,idx) 
        stripe_shape= algorithm_tools(obj.GetModel());
        stripe_shape.SingleStripe(params,sz);
        obj.GenerateImageIcon(idx, stripe_shape.GetResult(), dest);     
      end      
      function obj = DoMultipleStripes(obj, params, dest, sz,idx) 
        stripe_shape= algorithm_tools(obj.GetModel());
        stripe_shape.MultipleStripes(params,sz);
        obj.GenerateImageIcon(idx, stripe_shape.GetResult(), dest);     
      end
      
      function obj = DoDisplayFilter(obj,fType,params,dest,variety,dest2)
        
      end
          
      function obj = DoFiltering(obj, fType, params, dest, variety,dest2,fimg)
        % we check the filter type to choose correct controller call 
        switch(fType)            
            case 'average'
                [r,f] = obj.DoAverageFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'disk'
                [r,f] = obj.DoDiskFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'gaussian'
                [r,f] = obj.DoGaussianFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'laplacian'
                [r,f] = obj.DoLaplacianFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'log'
                [r,f] = obj.DoLogFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'motion'
                [r,f] = obj.DoMotionFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'sobel'
                [r,f] = obj.DoSobelFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'prewitt'
                [r,f] = obj.DoPrewittFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'unsharp'
                [r,f] = obj.DoUnsharpFilter(params); 
                obj.GenerateImageIcon(5,r, dest);
                obj.GenerateImageIcon(8,f, fimg);
            case 'lowpass'
                switch(variety)
                    case 'ideal'
                        [r,f] = obj.DoLowpassIdealFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);                      
                    case 'gaussian'
                        [r,f] = obj.DoLowpassGaussianFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);       
                    case 'butterworth'
                        [r,f] = obj.DoLowpassButterworthFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);       
                    otherwise
                        disp('bad filter type')
                end       
            case 'highpass'
                switch(variety)
                    case 'ideal'
                        [r,f] = obj.DoHighpassIdealFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);                             
                    case 'gaussian'
                        [r,f] = obj.DoHighpassGaussianFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);      
                    case 'butterworth'
                        [r,f] = obj.DoHighpassButterworthFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);      
                    otherwise
                        disp('bad filter type')
                end
            case 'bandpass'
                switch(variety)
                    case 'ideal'
                        [r,f] = obj.DoBandpassIdealFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);                           
                    case 'gaussian'
                        [r,f] = obj.DoBandpassGaussianFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);  
                    case 'butterworth';
                        [r,f] = obj.DoBandpassButterworthFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);  
                    otherwise
                        disp('bad filter type')
                end       
            case 'bandreject'
                switch(variety)
                    case 'ideal'
                        [r,f] = obj.DoBandrejectIdealFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);                     
                    case 'gaussian'
                        [r,f] = obj.DoBandrejectGaussianFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);  
                    case 'butterworth'
                        [r,f] = obj.DoBandrejectButterworthFilter(params); 
                        obj.GenerateImageIcon(5,r, dest);
                        obj.GenerateImageIcon(8,f, fimg);  
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
                midu = (fix(M/2)+1); midv = (fix(N/2)+1);
                X2 = X;  button = 0;
                % filter half width and height
                half_width = 7;  half_height = 7;
                H = ones( N, M );                
                disp('Left Mouse to select notch frequency, right to exit')
                while button~=3
                    f2 = figure(888);
                    im(abs(fftshift(X2)), 0, 0, 3 );
                    title('Image Magnitude Spectrum');
                    [x0,y0,button] = ginput(1);
                    x0 = round(x0);  y0 = round(y0);
                    %make sure the selected points are at least 
                    % at a distance > .5(h,w) of the filter
                    x0( x0 < half_width+2 ) = half_width + 2;
                    x0( x0 > M - half_width ) = M - half_width;
                    y0( y0 < half_height+2 ) = half_height + 2;
                    y0( y0 > N - half_height ) = N - half_height;
                    % starting and end point of the notch filter in x and y
                    stx = x0-half_width;  sty = y0-half_height;
                    edx = x0+half_width;  edy = y0+half_height;
                    % start/end point of notch filter conjugate pt in (x,y)
                    stx2 = 2*midu - edx;  edx2 = 2*midu - stx;
                    sty2 = 2*midv - edy;  edy2 = 2*midv - sty;
                    % apply the notch filter
                    H(sty:edy,stx:edx) = 0;  H(sty2:edy2,stx2:edx2) = 0;
                    X2 = X2.*ifftshift(H);   x2 = ifft2(X2);  
                    obj.GenerateImageIcon(5, x2, dest);
                end
                obj.GenerateImageIcon(5, x2, dest);
                close(f2);
            otherwise
                disp('Invalid filter type' );
        end        
      end
      
       function [r,f] = DoAverageFilter(obj, params)      
        avg_filter = algorithm_tools(obj.GetModel());     
        avg_filter.AverageFilter(4,params);        
        r = avg_filter.GetResult();       
        f = avg_filter.GetFilter();
       end
      
       function [r,f] = DoDiskFilter(obj, params)      
        disk_filter = algorithm_tools(obj.GetModel());     
        disk_filter.DiskFilter(4,params);        
        r = disk_filter.GetResult();     
        f = disk_filter.GetFilter();
       end
       
       function [r,f] = DoMotionFilter(obj, params)      
        motion_filter = algorithm_tools(obj.GetModel());     
        motion_filter.MotionFilter(4,params);        
        r = motion_filter.GetResult();      
        f = motion_filter.GetFilter();
       end
       
       function [r,f] = DoLaplacianFilter(obj, params)      
        laplacian_filter = algorithm_tools(obj.GetModel());     
        laplacian_filter.LaplacianFilter(4,params);        
        r = laplacian_filter.GetResult();     
        f = laplacian_filter.GetFilter();
       end
       
       function [r,f] = DoSobelFilter(obj, params)      
        sobel_filter = algorithm_tools(obj.GetModel());     
        sobel_filter.SobelFilter(4,params);        
        r = sobel_filter.GetResult();  
        f = sobel_filter.GetFilter();
       end
       
       function [r,f] = DoGaussianFilter(obj, params)      
        gaussian_filter = algorithm_tools(obj.GetModel());     
        gaussian_filter.GaussianFilter(4,params);        
        r = gaussian_filter.GetResult();   
        f = gaussian_filter.GetFilter();
       end
       
       function [r,f] = DoLogFilter(obj, params)      
        log_filter = algorithm_tools(obj.GetModel());     
        log_filter.LogFilter(4,params);        
        r = log_filter.GetResult(); 
        f = log_filter.GetFilter();
       end
       
       function [r,f] = DoPrewittFilter(obj, params)      
        prewitt_filter = algorithm_tools(obj.GetModel());     
        prewitt_filter.PrewittFilter(4,params);        
        r = prewitt_filter.GetResult();      
        f = prewitt_filter.GetFilter();
       end
       
       function [r,f] = DoUnsharpFilter(obj, params)      
        unsharp_filter = algorithm_tools(obj.GetModel());     
        unsharp_filter.UnsharpFilter(4,params);        
        r = unsharp_filter.GetResult();          
        f = unsharp_filter.GetFilter();
       end       
   %    high pass filters       
       function [r,f] = DoHighpassIdealFilter(obj, params)
        hpideal_filter = algorithm_tools(obj.GetModel());
        hpideal_filter.HPFIdeal(4, params);
        r = hpideal_filter.GetResult();
        f = hpideal_filter.GetFilter();
       end
       function [r,f] = DoHighpassGaussianFilter(obj, params)
        hpgauss_filter = algorithm_tools(obj.GetModel());
        hpgauss_filter.HPFGaussian(4, params);
        r = hpgauss_filter.GetResult();
        f = hpgauss_filter.GetFilter();
       end       
       function [r,f] = DoHighpassButterworthFilter(obj, params)
        hpbutter_filter = algorithm_tools(obj.GetModel());
        hpbutter_filter.HPFButterworth(4, params);
        r = hpbutter_filter.GetResult();
        f = hpbutter_filter.GetFilter();
       end       
  %    low pass filters       
       function [r,f] = DoLowpassIdealFilter(obj, params)
        lpideal_filter = algorithm_tools(obj.GetModel());
        lpideal_filter.LPFIdeal(4, params);
        r = lpideal_filter.GetResult();
        f = lpideal_filter.GetFilter();
       end
       function [r,f] = DoLowpassGaussianFilter(obj, params)
        lpgauss_filter = algorithm_tools(obj.GetModel());
        lpgauss_filter.LPFGaussian(4, params);
        r = lpgauss_filter.GetResult();
        f = lpgauss_filter.GetFilter();
       end       
       function [r,f] = DoLowpassButterworthFilter(obj, params)
        lpbutter_filter = algorithm_tools(obj.GetModel());
        lpbutter_filter.LPFButterworth(4, params);
        r = lpbutter_filter.GetResult();
        f = lpbutter_filter.GetFilter();
       end
   %    bandpass filters
       function [r,f] = DoBandpassIdealFilter(obj, params)
        bpideal_filter = algorithm_tools(obj.GetModel());
        bpideal_filter.BandpassIdeal(4, params);
        r = bpideal_filter.GetResult();
        f = bpideal_filter.GetFilter();
       end       
       function [r,f] = DoBandpassGaussianFilter(obj, params)
        bpgaussian_filter = algorithm_tools(obj.GetModel());
        bpgaussian_filter.BandpassGaussian(4, params);
        r = bpgaussian_filter.GetResult();
        f = bpgaussian_filter.GetFilter();
       end       
       function [r,f] = DoBandpassButterworthFilter(obj, params)
        bpbutter_filter = algorithm_tools(obj.GetModel());
        bpbutter_filter.BandpassButterworth(4, params);
        r = bpbutter_filter.GetResult();
        f = bpbutter_filter.GetFilter();
       end       
   %    bandreject filters
       function [r,f] = DoBandrejectIdealFilter(obj, params)
        brideal_filter = algorithm_tools(obj.GetModel());
        brideal_filter.BandrejectIdeal(4, params);
        r = brideal_filter.GetResult();
        f = brideal_filter.GetFilter();
       end       
       function [r,f] = DoBandrejectGaussianFilter(obj, params)
        brgauss_filter = algorithm_tools(obj.GetModel());
        brgauss_filter.BandrejectGaussian(4, params);
        r = brgauss_filter.GetResult();
        f = brgauss_filter.GetFilter();
       end       
       function [r,f] = DoBandrejectButterworthFilter(obj, params)
        brbutter_filter = algorithm_tools(obj.GetModel());
        brbutter_filter.BandrejectButterworth(4, params);
        r = brbutter_filter.GetResult();
        f = brbutter_filter.GetFilter();
       end
   %    notch filter
       function [r] = DoNotchFilterInit(obj, idx)
        nr_filter = algorithm_tools(obj.GetModel());
        nr_filter.NotchFilterInit(idx);
        r = nr_filter.GetResult();
       end
   %    Sinusoid
       function [r] = GenerateSinusoid(obj, idx, params, dest)
        sin_shape = algorithm_tools(obj.GetModel());
        sin_shape.Sinusoid(params);
        r = sin_shape.GetResult();           
       end
   %    magnitude and phase for drawing spectrum
       function r = DoMagnitudeImage(obj, idx)
        spect_mag = algorithm_tools(obj.GetModel());     
        spect_mag.MagnitudeImage(idx);        
        r = spect_mag.GetResult();        
       end;       
       function r = DoPhaseImage(obj, idx)
        spect_phase = algorithm_tools(obj.GetModel());     
        spect_phase.PhaseImage(idx); 
        r = spect_phase.GetResult();
       end
   %    creates an image from data at a specified index  
       function obj = GenerateImageIcon(obj, idx, data, dest)
        obj.GetModel().CreateImage(idx, data,imresize(data,obj.img_icon));
        obj.GetView().UpdateImage(dest, obj.GetModel().GetImageIcon(idx),1); 
       end
  %     set the data model
       function obj = SetModel(obj,m)
        obj.DataModel = m;
       end
  %     set the view
       function obj = SetView(obj,v)
        obj.View = v;
       end
  %     get the model
       function r = GetModel(obj)
        r = obj.DataModel;
       end
  %     get the view
       function r = GetView(obj)
        r = obj.View;
       end
   end
end