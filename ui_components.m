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
      % plot wrapper
      function r = Plot(obj, p, pos, labels)
          r = axes('Parent', p, 'Units', 'normalized', 'Position', pos);  
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