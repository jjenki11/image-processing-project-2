classdef ui_components
   properties
        % tbd we can put parent in here so we dont have to pass it
   end
   methods
       
      function obj = ui_components()
            % all initializations, calls to base class, etc. here,
      end
      % container wrapper
      function r = Container(obj, c, n, p)
         r = figure('Color', c,...
                    'Name',  n,...
                    'DockControl', 'off',...
                    'Units', 'Pixels',...
                    'Position', p);
      end
      function r = ImageWindow(obj, p, pos, img)
          r = axes('Parent', p,...
                     'Units', 'Normalized',...
                     'Position', pos);
          imagesc(img); colormap gray
          axis off
          axis image
      end
      % plot wrapper
      function r = Plot(obj, p, pos)
          r = axes('Parent', p, 'Units', 'normalized', 'Position', pos);  
      end
      
      function UpdatePlot(obj,p,xdata,ydata,xlbl,ylbl,ttl,xlim,ylim)
          plot(p, xdata, ydata);
          xlabel(p, xlbl);
          ylabel(p, ylbl);
          title(p, ttl);
          set(p,'xlim', xlim, 'ylim', ylim);
      end
      
      function UpdateImage(obj, p, img)
%           matlabImage = img;
%             cla
          imh = imhandles(p); %gets your image handle if you dont know it
          set(imh,'CData',img);
          imshow(img); %colormap gray
          axis off
          axis image
%           imshow(img); colormap gray
      end
      
      function r = FileBrowser(obj, p, pos, tbox)
         [filename, pathname] = ...
            uigetfile({'*.m';'*.slx';'*.mat';'*.*'},'File Selector');
            r = strcat(pathname,filename);
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