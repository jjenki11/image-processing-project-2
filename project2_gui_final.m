%% Project 2 GUI driver


%%
function project2_gui_final()
 
%% Construct object oriented classes to manage back-end

% This is our view (ui wrapper) class
    view = ui_components();    
% This is our model factory class
    model = model_factory();   
% This is our controller class
    ctrl = controller(model,view);
    
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
    
    spectrumImageTypes = {'Sinusoids', 'Single Circle', 'Single Rectangle',...
        'Multiple Circles', 'Multiple Rectangles', 'Single Stripes',...
        'Multiple Stripes', 'Image from File'};
    filterTypes = {'Frequency Response', 'Impulse Response', };
    frequencyResponseTypes  = {'lowpass', 'highpass','bandpass','bandreject','notch reject'};
    impulseResponseTypes= {'average', 'disk','gaussian','laplacian','log','motion','prewitt','sobel','unsharp'};

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
    home_message = view.Label(home_panel,  'Welcome home! This is our Project 2 GUI!', 10, [0.12,.93, .76, .045]);
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
    spectrum_panel = view.Container(tab2,panel_color,'Draw Spectrum',10,[.05,.05,.9,.9]);        
    spectrum_image_type_label = view.Label(spectrum_panel, 'Type: ', 10, [0.01, 0.91, 0.09, 0.05]);
    spectrum_imageDD = view.DropDown(spectrum_panel,spectrumImageTypes, [0.115, 0.91, 0.25, 0.05], @spectrumImageTypeDDCallback);
    % options pane
    spectrum_image_options_panel = view.Container(spectrum_panel,panel_color,'Options',10,[0.001,.62,.45,.25]);    
    spectrum_image_panel = view.Container(spectrum_panel,panel_color,'Image',10,[img_offset,.15,img_size,img_size]);   
    % image of shape
    spect_img = view.ImageWindow(spectrum_image_panel, [0.075,0.07, .85, .85], zeros(img_icon));
    spect_img_path = view.Edit(spectrum_image_panel, 8, [0.125,0, .60, .07]);
    spect_img_btn  = view.Button(spectrum_image_panel, 'load', 8, [.725, 0, .15, .07], @spectImageFileCB);       
    % magnitude image
    magnitude_image_panel = view.Container(spectrum_panel,panel_color,'Magnitude',10,[1-img_size,.50,img_size,img_size]);    
    magnitude_img = view.ImageWindow(magnitude_image_panel, [0.075,0.07, .85, .85], zeros(img_icon));     
    % phase image
    phase_image_panel = view.Container(spectrum_panel,panel_color,'Phase',10,[1-img_size,.05,img_size,img_size]);    
    phase_img = view.ImageWindow(phase_image_panel, [0.075,0.07, .85, .85], zeros(img_icon)); 
    draw_spect_button = view.Button(spectrum_panel,'draw spectrum',8,[.15,.05,.17,.05],@drawSpectrumCB);     
    
%% Construct the Filtering area
    img4_panel = view.Container(tab3,panel_color,'Image 1',10,[img_offset,.25,img_size,img_size]);    
    filt_img4 = view.ImageWindow(img4_panel, [0.075,0.07, .85, .85], zeros(img_icon));
    img4_path = view.Edit(img4_panel, 8, [0.125,0, .60, .07]);
    img4_btn  = view.Button(img4_panel, 'load', 8, [.725, 0, .15, .07], @file4CB);    
    img5_panel = view.Container(tab3,panel_color,'Result',10,[1-img_size,.25,img_size,img_size]);
    filt_img5 = view.ImageWindow(img5_panel, [0.075,0.07, .85, .85], zeros(img_icon));
    img5_save_btn = view.Button(img5_panel, 'Save', 8, [0.125, 0, .19, .07], @saveFilteredImage);        
    filter_select_panel = view.Container(tab3,panel_color,'Select', 10, [.001, .75, img_size,img_size/2]);
    ftechnique_label = view.Label(filter_select_panel, 'Technique:', 10, [0.001 0.71 0.25 0.15]);
    filterDD = view.DropDown(filter_select_panel,filterTypes, [0.27 0.71 0.5 0.15], @filterTypeDDCallback);
    ftype_label = view.Label(filter_select_panel, 'Type:', 10, [0.001 0.35 0.25 0.15]);
    impRespDD = view.DropDown(filter_select_panel,impulseResponseTypes, [0.27 0.02 0.5 0.5], @impulseTypeDDCallback);
    set(impRespDD,'Visible','off');
    freqRespDD= view.DropDown(filter_select_panel,frequencyResponseTypes, [0.27 0.02 0.5 0.5], @freqTypeDDCallback);
    filter_config_panel = view.Container(tab3,panel_color,'Setup', 10, [1-img_size, .75, img_size,img_size/2]);
    filter_size_label_x = view.Label(filter_config_panel, 'Size (x):', 10, [0.001 0.74 0.25 0.15]);
    filter_size_value_x = view.Edit(filter_config_panel, 8, [0.25 0.74 0.25 0.15]);
    filter_size_label_y = view.Label(filter_config_panel, 'Size (y):', 10, [0.001 0.58 0.25 0.15]);
    filter_size_value_y = view.Edit(filter_config_panel, 8, [0.25 0.58 0.25 0.15]);
    filter_sd_label = view.Label(filter_config_panel, 'Std Dev:', 10, [0.001 0.42 0.25 0.15]);
    filter_std_dev = view.Edit(filter_config_panel, 8, [0.25 0.42 0.25 0.15]);
    filt_button = view.Button(tab3,'filter',8,[.47,.5,.07,.05],@filtCB);
    
%% Construct the About area
    about_panel = view.Container(tab4,panel_color,'About this software',10,[.1,.1,.8,.8]);    
    about_message = view.Label(about_panel, 'TBD - Future home of the about area (description of the project)!', 10, [0.2,0.5, .60, .07]);    
    
    % initialize text boxes to 0
    view.InitializeValues([filter_size_value_x,filter_size_value_y,filter_std_dev]);
    
%% Define the callbacks for buttons etc.  
%   TBD - create controller class which will house all callbacks 
%   for every aspect of the UI

    % Callback function for "browser" button (image 1)
    function file1CB(hObj, event)
        ctrl.SelectFile(tab1, img1_path, 1, conv_img1);
    end

    % Callback function for "browser" button (image 2)
    function file2CB(hObj, event)
        ctrl.SelectFile(tab1, img2_path, 2, conv_img2);
    end

    % Callback function for "browser" button (image 1)
    function file4CB(hObj, event)
        ctrl.SelectFile(tab3, img4_path, 4, filt_img4);
    end

    function spectImageFileCB(hObj, event)
        ctrl.SelectFile(tab2, spect_img_path, 6, spect_img);
    end

    % resets the convolved image result to a blank image
    function resetImage(hObj, event)
        ctrl.Reset(conv_img3, zeros(img_icon));        
    end

    % opens a file dialog for the user to save the convolution result
    function saveImage(hObj, event)
        ctrl.SaveImage(3, tab1);
    end    

    % Callback function for "Convolve" button
    function convCB(hObj, event)
        ctrl.DoConvolution(conv_img3);
    end  

    % opens a file dialog for the user to save the filter result
    function saveFilteredImage(hObj, event)        
        ctrl.SaveImage(5, tab3);        
    end

    %   TBD - will get to this tomorrow, Friday the 13th!
    function drawSpectrumCB(hObj, event)
        %   Magnitude
        spect_mag = algorithm_tools(model);     
        spect_mag.MagnitudeImage(6);        
        x = spect_mag.GetResult();        
        model.CreateImage(7, x, imresize(x,img_icon));
        view.UpdateImage(magnitude_img, model.GetImageIcon(7));        
        %   Phase
        spect_phase = algorithm_tools(model);     
        spect_phase.PhaseImage(6);        
        x2 = spect_phase.GetResult();        
        model.CreateImage(8, x2, imresize(x2,img_icon));
        view.UpdateImage(phase_img, model.GetImageIcon(8));        
    end

    % Callback function for spectrum drawing image type dropdown
    function spectrumImageTypeDDCallback(hObj, event)
        txt = spectrumImageTypes{get(spectrum_imageDD, 'Value')};
        disp(txt)
    end
    
    % Callback function for filter dropdown
    function filterTypeDDCallback(hObj, event)
        txt = filterTypes{get(filterDD, 'Value')};
        disp(txt)
        if(strcmp(txt,'Impulse Response') == 0)
            set(freqRespDD,'Visible', 'on');
            set(impRespDD,'Visible', 'off');
            disp('Impulse response selected.')
        else
            set(freqRespDD,'Visible', 'off');
            set(impRespDD,'Visible', 'on');
            disp('Frequency response selected.')
        end        
    end

    % Callback function for impulse response dropdown
    function impulseTypeDDCallback(hObj,event)
        txt = impulseResponseTypes{get(impRespDD, 'Value')};
        disp(txt)
        switch(txt)            
            case 'average'
                view.HideWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
                view.ShowWidgets([filter_size_label_x,filter_size_value_x,...
                    filter_size_label_y, filter_size_value_y]);
            case 'disk'
                view.HideWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
                view.ShowWidgets([filter_size_label_x, filter_size_value_x]);            
            case 'gaussian'
                view.HideWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
                view.ShowWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
            case 'laplacian'
                view.HideWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
                view.ShowWidgets([filter_size_label_x, filter_size_value_x]);
            case 'log'
                view.HideWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
                view.ShowWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
            case 'motion'
                view.HideWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
                view.ShowWidgets([filter_size_label_x, filter_size_value_x,filter_size_value_y]);
            case 'sobel'
                view.HideWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
            case 'prewitt'
                view.HideWidgets([filter_size_value_x,filter_size_value_y,filter_std_dev,...
                    filter_size_label_x, filter_size_label_y, filter_sd_label]);
            case 'unsharp'
                view.HideWidgets([filter_size_label_x, filter_size_value_x,filter_size_value_y,filter_std_dev]);
                view.ShowWidgets([filter_size_label_x, filter_size_value_x]);
            otherwise
                disp('Invalid filter type' );
        end  
    end

    % Callback function for frequency response dropdown
    function freqTypeDDCallback(hObj, event)
        txt = frequencyResponseTypes{get(freqRespDD, 'Value')};
        disp(txt)
    end

    % Callback function for "filter" button
    function filtCB(hObj, event)        
        params = [double(str2double(get(filter_size_value_x,'String'))),...
            double(str2double(get(filter_size_value_y, 'String'))),...
            double(str2double(get(filter_std_dev, 'String')))];        
        if(strcmp(filterTypes{get(filterDD, 'Value')},'Impulse Response')==0)
            ctrl.DoFiltering(impulseResponseTypes{get(impRespDD,'Value')},...
                params, filt_img5);
        else
            ctrl.DoFiltering(frequencyResponseTypes{get(freqRespDD,'Value')},...
                params, filt_img5);
        end
    end 
     
end