%% Project 2 GUI driver


%%
function project2_gui_final()
 
%% Construct object oriented classes to manage back-end
% This is our ui wrapper class
    view = ui_components();    
% This is our model factory class
    model = model_factory();   
    
%% define some ui parameters
    
%   ui normalized position key    
%    _____________________
%   |0,1               1,1|
%   |                     |
%   |                     |
%   |                     |
%   |0,0               1,0|
%    _____________________    

    win_size = [800 800];
    win_pos  = [100  50];
    img_icon = [250 250];    
    img_offset = 0.001;
    img_size = 0.45;   
    panel_color = [0.9255 0.9137 0.8471];

%% Construct the main window (frame)
    window = view.Frame(panel_color,'Project 2',[win_pos win_size]);   
    
%% Construct a tab group.  TBD lets find the 'deprecated' issue w.r.t. tabs
    tgroup = uitabgroup('Parent', window);
    tab0 = uitab('Parent', tgroup, 'Title', 'Home');
    tab1 = uitab('Parent', tgroup, 'Title', 'Convolution');
    tab2 = uitab('Parent', tgroup, 'Title', 'Draw Spectrum');
    tab3 = uitab('Parent', tgroup, 'Title', 'Filtering');
    tab4 = uitab('Parent', tgroup, 'Title', 'About');       
    
%% Construct the Home area
    home_panel = view.Container(tab0,panel_color,'Home - Project 2',10,[.05,.05,.9,.9]);    
    home_img1 = view.ImageWindow(home_panel, [0.075,0.07, .85, .85], zeros(600,800));
    home_message = view.Label(home_panel,  'TBD - Future home screen for the Project 2 GUI', 10, [0.12,.93, .76, .045]);
    view.UpdateImage(home_img1, imread('CUA_logo.jpg'));
    
%% Construct the convolution area
    img1_panel = view.Container(tab1,panel_color,'Image 1',10,[img_offset,1-(img_size+img_offset),img_size,img_size]);    
    conv_img1 = view.ImageWindow(img1_panel, [0.075,0.07, .85, .85], zeros(img_icon));
    img1_path = view.Edit(img1_panel, 8, [0.125,0, .60, .07]);
    img1_btn  = view.Button(img1_panel, 'load', 8, [.725, 0, .15, .07], @file1CB);    
    img2_panel = view.Container(tab1,panel_color,'Image 2',10,[img_offset,1-2*(img_size+img_offset),img_size,img_size]);
    conv_img2 = view.ImageWindow(img2_panel, [0.075,0.07, .85, .85], zeros(img_icon));
    img2_path = view.Edit(img2_panel, 8, [0.125,0, .60, .07]);
    img2_btn  = view.Button(img2_panel, 'load', 8, [.725, 0, .15, .07], @file2CB);    
    img3_panel = view.Container(tab1,panel_color,'Result',10,[1-img_size,.35,img_size,img_size]);
    conv_img3 = view.ImageWindow(img3_panel, [0.075,0.07, .85, .85], zeros(img_icon));
    img3_save_btn = view.Button(img3_panel, 'Save', 8, [0.125, 0, .19, .07], @saveImage);
    img3_reset_btn  = view.Button(img3_panel, 'reset', 8, [.725, 0, .19, .07], @resetImage);    
    conv_button = view.Button(tab1,'convolve',8,[.47,.5,.07,.05],@convCB);    
    
%% Construct the Spectrum Drawing area
    spectrum_panel = view.Container(tab2,panel_color,'Draw Spectrum',10,[.1,.1,.8,.8]);    
    spectrum_message = view.Label(spectrum_panel, 'TBD - Future home of the Draw Spectrum area (with many bells and whistles)', 10, [0.15,0.5, .76, .07]);
               
%% Construct the Filtering area
    img4_panel = view.Container(tab3,panel_color,'Image 1',10,[img_offset,.25,img_size,img_size]);    
    filt_img4 = view.ImageWindow(img4_panel, [0.075,0.07, .85, .85], zeros(img_icon));
    img4_path = view.Edit(img4_panel, 8, [0.125,0, .60, .07]);
    img4_btn  = view.Button(img4_panel, 'load', 8, [.725, 0, .15, .07], @file4CB);    
    img5_panel = view.Container(tab3,panel_color,'Result',10,[1-img_size,.25,img_size,img_size]);
    filt_img5 = view.ImageWindow(img5_panel, [0.075,0.07, .85, .85], zeros(img_icon));
    img5_save_btn = view.Button(img5_panel, 'Save', 8, [0.125, 0, .19, .07], @saveFilteredImage);    
    filt_button = view.Button(tab3,'filter',8,[.47,.5,.07,.05],@filtCB);
    
%% Construct the About area
    about_panel = view.Container(tab4,panel_color,'About this software',10,[.1,.1,.8,.8]);    
    about_message = view.Label(about_panel, 'TBD - Future home of the about area (description of the project)!', 10, [0.2,0.5, .60, .07]);
    
%% Define the callbacks for buttons etc.  
%   TBD - create controller class which will house all callbacks 
%   for every aspect of the UI

    % Callback function for "browser" button (image 1)
    function file1CB(hObj, event)
        p = view.FileBrowser(tab1,[0.1 0.37 0.4 0.2],[]);
        set(img1_path,'String',p);
        img = imread(p); sz = size(img);
        if(numel(sz)>2) 
            img = rgb2gray(img); 
        end
        model.CreateImage(1, img, imresize(img,img_icon));        
        view.UpdateImage(conv_img1, model.GetImageIcon(1));
    end

    % Callback function for "browser" button (image 2)
    function file2CB(hObj, event)
        p = view.FileBrowser(tab1,[0.1 0.37 0.4 0.2],[]);
        set(img2_path,'String',p);
        img = imread(p); sz = size(img);
        if(numel(sz)>2) 
            img = rgb2gray(img); 
        end        
        model.CreateImage(2, img, imresize(img,img_icon));        
        view.UpdateImage(conv_img2, model.GetImageIcon(2));
    end

    % resets the convolved image result to a blank image
    function resetImage(hObj, event)
        view.UpdateImage(conv_img3, zeros(img_icon));
    end

    % opens a file dialog for the user to save the convolution result
    function saveImage(hObj, event)
        xx = model.GetImageData(3);
        maxv = max(xx(:));
        mapped_array = uint8((double(xx) ./ maxv) .* 255);
        colormap(gray(255));
        view.FileSaver(tab1, [0.1, 0.37, 0.4, 0.2], mapped_array);
        disp('File saved!');
    end    

    % Callback function for "Convolve" button
    function convCB(hObj, event)
        % This is the convolution wrapper class
        convolution = algorithm_tools(model);        
        convolution.ConvolveImages(1,2);        
        x = convolution.GetResult();        
        model.CreateImage(3, x, imresize(x,img_icon));
        view.UpdateImage(conv_img3, model.GetImageIcon(3));
    end  
    
    % Callback function for "browser" button (image 1)
    function file4CB(hObj, event)
        p = view.FileBrowser(tab3,[0.1 0.37 0.4 0.2],[]);
        set(img4_path,'String',p);
        img = imread(p); sz = size(img);
        if(numel(sz)>2) 
            img = rgb2gray(img); 
        end
        model.CreateImage(4, img, imresize(img,img_icon));        
        view.UpdateImage(filt_img4, model.GetImageIcon(4));
    end

    % opens a file dialog for the user to save the filter result
    function saveFilteredImage(hObj, event)
        xx = model.GetImageData(5);
        maxv = max(xx(:));
        mapped_array = uint8((double(xx) ./ maxv) .* 255);
        colormap(gray(255));
        view.FileSaver(tab3, [0.1, 0.37, 0.4, 0.2], mapped_array);
        disp('File saved!');
    end

    % Callback function for "filter" button
    function filtCB(hObj, event)
        % This is the convolution wrapper class
        med_filter = algorithm_tools(model);     
        nhood_rows = 25 ;
        nhood_cols = 25 ;
        med_filter.FilterImage(4,[nhood_rows, nhood_cols]);        
        x = med_filter.GetResult();        
        model.CreateImage(5, x, imresize(x,img_icon));
        view.UpdateImage(filt_img5, model.GetImageIcon(5));
    end 
     
    % A dropdown test
    %test_dd = view.DropDown(tab1,{'a', 'b', 'c', 'd'}, [0.62 0.02 0.16 0.08], @sawCallback);
        
    
 
end