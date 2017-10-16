classdef ui_components
   properties
        % tbd we can put parent in here so we dont have to pass it
   end
   methods
       
      function obj = ui_components()
            % all initializations, calls to base class, etc. here,
      end
      % frame wrapper
      function r = Frame(obj, c,n,p)
          r = figure('Color', c,...
                    'Name',  n,...
                    'DockControl', 'off',...
                    'Units', 'Pixels',...
                    'Resize','off',...
                    'Position', p);
      end
      
      % container wrapper
      function r = Container(obj, p, c, t, fs, pos)
         r = uipanel('Parent', p, 'Title', t, 'BackgroundColor',c,...
             'FontSize', fs, 'Units', 'normalized', 'Position', pos);
      end
        
      % image wrapper
      function r = ImageWindow(obj, p, pos, img)
          r = axes('Parent', p,...
                     'Units', 'normalized',...
                     'Position', pos);
          [sy,sx,sz]=size(img);
          x=[1:sx];y=[1:sy];
          image(x,y,img); %xolormap gray;
          axis off
          axis image          
      end
      
      % plot wrapper
      function r = Plot(obj, p, pos)
          r = axes('Parent', p, 'Units', 'normalized', 'Position', pos);  
      end
      
      % Updates a plot object by its handle
      function UpdatePlot(obj,p,xdata,ydata,xlbl,ylbl,ttl,xlim,ylim)
          plot(p, xdata, ydata);
          xlabel(p, xlbl);
          ylabel(p, ylbl);
          title(p, ttl);
          set(p,'xlim', xlim, 'ylim', ylim);
      end
      
      % Updates an image on the GUI by it's handle object
      function UpdateImage(obj, p, in,binary_flag)
          
in = double(in);

% Get size info
[ sy, sx, sz ] = size( in );

% Is the logical (binary) pixel data?
if islogical(in) || (min(in(:))==0 && max(in(:))==1)
    binary_flag = 1;
else
    binary_flag = 0;
end

% Set up the default axes
% if nargin < 6 || isempty(x) || isempty(y)
    x=[1:sx]; % default
    y=[1:sy]; % default
% end

nstd=3;

% number of pixels to use for statistics (mean and std)
max_num = min( [ 10000, sy*sx ] );

if binary_flag == 1

    % Treat by scaling 0 -> 0 and 1->255

    out = in(:,:,1)*255;
    gain = 255;
    bias = 0;
%     image(x,y,out);
%     colormap(gray(256));
%     axis('image');

else

    % Treat by mapping nstd standard deviations
    % of input range into display range

    if nargin < 4 
        nstd = 2; % default
    end

    if sz == 3 % color data

        R = in(:,:,1);
        G = in(:,:,2);
        B = in(:,:,3);



            USE = round( linspace(1,sy*sx,max_num ) );
            
            mR = mean(R(USE));
            mG = mean(G(USE));
            mB = mean(B(USE));

            sR = std(R(USE));
            sG = std(G(USE));
            sB = std(B(USE));

        

        gain(1) = 128/(sR*nstd);
        gain(2) = 128/(sG*nstd);
        gain(3) = 128/(sB*nstd);

        bias(1) = 128-(mR*128)/(sR*nstd);
        bias(2) = 128-(mG*128)/(sG*nstd);
        bias(3) = 128-(mB*128)/(sB*nstd);

        R = in(:,:,1)*gain(1)+bias(1);
        G = in(:,:,2)*gain(2)+bias(2);
        B = in(:,:,3)*gain(3)+bias(3);

        out(:,:,1)=uint8(clip(round(R),0,255));
        out(:,:,2)=uint8(clip(round(G),0,255));
        out(:,:,3)=uint8(clip(round(B),0,255));

%         image(x,y,out);
%         axis('image');

    else % assume grayscale (use first band only)

        in = in(:,:,1);



            USE = round( linspace(1,sy*sx,max_num ) );
            
            inmn=mean(in(USE));
            instd=std(in(USE));


        gain = 128/(instd*nstd);
        bias = 128-(inmn*128)/(instd*nstd);
        out=in*gain+bias;
%         image(x,y,out);
%         colormap(gray(256));
%         axis('image');

    end
    
        set(imhandles(p),'CData',out);
        colormap(gray(256));
        axis('image');
%         axis off
%           axis image
    end
  end
      
      % Opens a browser to find a file in your file system
      function r = FileBrowser(obj, p, pos, tbox)
         [filename, pathname] = ...
            uigetfile({'*.*';'*.tif';'*.jpg';'*.png';'*.bmp';},'Load file...');
            r = strcat(pathname,filename);
      end
      
      % Opens a browser to save a file in your file system
      function r = FileSaver(obj, p, pos, img)
         [file,path] = uiputfile('*.*','Save file to disk...');
         r = strcat(path, file);
         imwrite(img, r);
      end
      
      % slider wrapper
      function r = Slider(obj, p, pos, range, val, cb)
          r = uicontrol('Parent', p, 'Style', 'slider', 'Units', 'normalized',...
                        'Position', pos,'Min', range(1), 'Max', range(2),...
                        'Value', val,'Callback', cb);
      end
      % edit wrapper
      function r = Edit(obj, p, fs, pos)
          r = uicontrol('Parent', p, 'Style', 'edit', 'FontSize', fs,...
                        'Units', 'normalized','Position', pos);          
      end
      % label wrapper
      function r = Label(obj, p, str, fs, pos)
          r = uicontrol('Parent', p, 'Style', 'text', 'String', str,...
                        'FontSize', fs, 'Units', 'normalized', ...
                        'Position', pos);          
      end
      % button wrapper
      function r = Button(obj, p, str, fs, pos, cb)
          r = uicontrol('Parent', p, 'Style', 'pushbutton', 'String', str,...
                        'FontSize', fs, 'Units', 'normalized', ...
                        'Position', pos, 'Callback', cb);
      end
      % dropdown wrapper
      function r = DropDown(obj, p, list, pos, cb)
          r = uicontrol('Parent', p, 'Style', 'popup', 'String', list,...
                        'Units','normalized','Position', pos, 'Callback', cb);
      end      
      % value initializer
      function InitializeValues(obj, vArray)
         n=max(size(vArray));
         for i=1:n
            set(vArray(i), 'String', 0); 
         end         
      end
      % display widgets
      function ShowWidgets(obj, vArray)
         n=max(size(vArray));
         for i=1:n
            set(vArray(i), 'Visible', 'on'); 
         end         
      end
      % hide widgets
      function HideWidgets(obj, vArray)
         n=max(size(vArray));
         for i=1:n
            set(vArray(i), 'Visible', 'off'); 
         end         
      end
      
   end
end