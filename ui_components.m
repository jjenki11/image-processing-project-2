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
          imagesc(img); colormap gray;
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
      function UpdateImage(obj, p, img)
          imh = imhandles(p); %gets your image handle if you dont know it
          set(imh,'CData',img);
          colormap gray;
          axis off
          axis image
      end
      
      % Opens a browser to find a file in your file system
      function r = FileBrowser(obj, p, pos, tbox)
         [filename, pathname] = ...
            uigetfile({'*.jpg';'*.png';'*.bmp';},'Image Selector');
            r = strcat(pathname,filename);
      end
      
      % Opens a browser to save a file in your file system
      function r = FileSaver(obj, p, pos, img)
         [file,path] = uiputfile('*.*','Save convolved image file');
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
      function r = DropDown(obj, p, list, pos)
          r = uicontrol('Parent', p, 'Style', 'popup', 'String', list,...
                        'Units','normalized','Position', pos);
      end
      
   end
end