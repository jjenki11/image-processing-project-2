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
    frequencyVarietyTypes = {'ideal', 'gaussian', 'butterworth'};
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
    % options panels
    spectrum_image_panel = view.Container(spectrum_panel,panel_color,'Image',10,[img_offset,.15,img_size,img_size]); 
    spectrum_image_options_panel = view.Container(spectrum_panel,panel_color,'Options',10,[0.001,.62,.45,.25]);   
    
    % sinusoid opts
    spect_sin_label_u = view.Label(spectrum_image_options_panel, 'U Freq:', 10, [0.001 0.74 0.25 0.15]);
    spect_sin_value_u = view.Edit(spectrum_image_options_panel, 8, [0.25 0.74 0.25 0.15]);    
    spect_sin_label_v = view.Label(spectrum_image_options_panel, 'V Freq:', 10, [0.001 0.54 0.25 0.15]);
    spect_sin_value_v = view.Edit(spectrum_image_options_panel, 8, [0.25 0.54 0.25 0.15]);    
    
    all_spect_widgets= [];
    
    sinusoid_widgets = [spect_sin_label_u,spect_sin_value_u,spect_sin_label_v,spect_sin_value_v];
    all_spect_widgets=[all_spect_widgets; sinusoid_widgets];
    
    % single circle opts
    spect_one_circle_label_r = view.Label(spectrum_image_options_panel, 'Radius:', 10, [0.001 0.74 0.25 0.15]);
    spect_one_circle_value_r = view.Edit(spectrum_image_options_panel, 8, [0.25 0.74 0.25 0.15]);
    
    single_circle_widgets = [spect_one_circle_label_r,spect_one_circle_value_r];
    all_spect_widgets=[all_spect_widgets, single_circle_widgets];
    
    % single rectangle opts
    spect_one_rect_label_w = view.Label(spectrum_image_options_panel, 'Width:', 10, [0.001 0.74 0.25 0.15]);
    spect_one_rect_value_w = view.Edit(spectrum_image_options_panel, 8, [0.25 0.74 0.25 0.15]);
    
    spect_one_rect_label_h = view.Label(spectrum_image_options_panel, 'Height:', 10, [0.001 0.54 0.25 0.15]);
    spect_one_rect_value_h = view.Edit(spectrum_image_options_panel, 8, [0.25 0.54 0.25 0.15]);
    
    single_rectangle_widgets = [spect_one_rect_label_w,spect_one_rect_value_w,spect_one_rect_label_h,spect_one_rect_value_h];
    all_spect_widgets=[all_spect_widgets, single_rectangle_widgets];
    
    % multiple circles opts
    spect_multi_rect_label_w = view.Label(spectrum_image_options_panel, 'Width:', 10, [0.001 0.74 0.25 0.15]);
    spect_multi_rect_value_w = view.Edit(spectrum_image_options_panel, 8, [0.25 0.74 0.25 0.15]);
    
    spect_multi_rect_label_h = view.Label(spectrum_image_options_panel, 'Height:', 10, [0.001 0.54 0.25 0.15]);
    spect_multi_rect_value_h = view.Edit(spectrum_image_options_panel, 8, [0.25 0.54 0.25 0.15]);
    
    spect_multi_rect_label_x = view.Label(spectrum_image_options_panel, 'Period(x):', 10, [0.001 0.34 0.25 0.15]);
    spect_multi_rect_value_x = view.Edit(spectrum_image_options_panel, 8, [0.25 0.34 0.25 0.15]);
    
    spect_multi_rect_label_y = view.Label(spectrum_image_options_panel, 'Period(y):', 10, [0.001 0.14 0.25 0.15]);
    spect_multi_rect_value_y = view.Edit(spectrum_image_options_panel, 8, [0.25 0.14 0.25 0.15]);
    
    multiple_rectangles_widgets = [spect_multi_rect_label_w,spect_multi_rect_value_w,spect_multi_rect_label_h,spect_multi_rect_value_h,...
        spect_multi_rect_label_x,spect_multi_rect_value_x,spect_multi_rect_label_y,spect_multi_rect_value_y];
    all_spect_widgets=[all_spect_widgets, multiple_rectangles_widgets];
    
    % multiple circles opts
    spect_multi_circle_label_r = view.Label(spectrum_image_options_panel, 'Radius:', 10, [0.001 0.74 0.25 0.15]);
    spect_multi_circle_value_r = view.Edit(spectrum_image_options_panel, 8, [0.25 0.74 0.25 0.15]);
    
    spect_multi_circle_label_x = view.Label(spectrum_image_options_panel, 'Period(x):', 10, [0.001 0.54 0.25 0.15]);
    spect_multi_circle_value_x = view.Edit(spectrum_image_options_panel, 8, [0.25 0.54 0.25 0.15]);
    
    spect_multi_circle_label_y = view.Label(spectrum_image_options_panel, 'Period(y):', 10, [0.001 0.34 0.25 0.15]);
    spect_multi_circle_value_y = view.Edit(spectrum_image_options_panel, 8, [0.25 0.34 0.25 0.15]);
    
    multiple_circles_widgets = [spect_multi_circle_label_r,spect_multi_circle_value_r,spect_multi_circle_label_x,...
        spect_multi_circle_value_x,spect_multi_circle_label_y,spect_multi_circle_value_y];
    
    all_spect_widgets=[all_spect_widgets, multiple_circles_widgets];
    
    % single stripes opts
    single_stripe_label_dir = view.Label(spectrum_image_options_panel, 'Rotation:', 10, [0.001 0.74 0.25 0.15]);
    single_stripe_value_dir = view.Edit(spectrum_image_options_panel, 8, [0.25 0.74 0.25 0.15]);
    single_stripe_widgets = [single_stripe_label_dir,single_stripe_value_dir];
    
    all_spect_widgets=[all_spect_widgets, single_stripe_widgets];
    
    % multiple stripes opts
    multiple_stripe_label_num = view.Label(spectrum_image_options_panel, 'Number:', 10, [0.001 0.74 0.25 0.15]);
    multiple_stripe_value_num = view.Edit(spectrum_image_options_panel, 8, [0.25 0.74 0.25 0.15]);
    
    multiple_stripe_label_dir = view.Label(spectrum_image_options_panel, 'Rotation:', 10, [0.001 0.54 0.25 0.15]);
    multiple_stripe_value_dir = view.Edit(spectrum_image_options_panel, 8, [0.25 0.54 0.25 0.15]);
    
    multiple_stripes_widgets = [multiple_stripe_label_num,multiple_stripe_value_num,multiple_stripe_label_dir,multiple_stripe_value_dir];
    
    % image from file
    spect_img_path = view.Edit(spectrum_image_panel, 8, [0.125,0, .60, .07]);
    spect_img_btn  = view.Button(spectrum_image_panel, 'load', 8, [.725, 0, .15, .07], @spectImageFileCB);  
    
    img_from_file_widgets = [spect_img_path,spect_img_btn];    
    all_spect_widgets=[all_spect_widgets, img_from_file_widgets];
    
    all_spect_widgets=[all_spect_widgets, multiple_stripes_widgets];
    
    % generate shape
    generate_shape_button = view.Button(spectrum_image_options_panel,'generate shape',8,[1-.35,.25,.35,.25],@generateShapeCB);   
    shape_save_btn = view.Button(spectrum_image_panel, 'Save', 8, [0.125, 0, .19, .07], @saveShapeImage);
    % image of shape
    spect_img = view.ImageWindow(spectrum_image_panel, [0.075,0.07, .85, .85], zeros(img_icon));
     
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
    fvariety_label = view.Label(filter_select_panel, 'Variety:', 10, [0.001 0.1 0.25 0.15]);
    freqVarietyDD = view.DropDown(filter_select_panel,frequencyVarietyTypes, [0.27 0.02 0.5 0.25], @freqVarietyTypeDDCallback);
    
    set(impRespDD,'Visible','off');
    freqRespDD= view.DropDown(filter_select_panel,frequencyResponseTypes, [0.27 0.02 0.5 0.5], @freqTypeDDCallback);
    filter_config_panel = view.Container(tab3,panel_color,'Setup', 10, [1-img_size, .75, img_size,img_size/2]);
    filter_size_label_x = view.Label(filter_config_panel, 'Cutoff Freq:', 10, [0.001 0.74 0.25 0.15]);
    filter_size_value_x = view.Edit(filter_config_panel, 8, [0.25 0.74 0.25 0.15]);
    filter_size_label_y = view.Label(filter_config_panel, 'Order(n):', 10, [0.001 0.58 0.25 0.15]);
    filter_size_value_y = view.Edit(filter_config_panel, 8, [0.25 0.58 0.25 0.15]);
    filter_size_label_z = view.Label(filter_config_panel, 'Std Dev:', 10, [0.001 0.42 0.25 0.15]);
    filter_size_value_z = view.Edit(filter_config_panel, 8, [0.25 0.42 0.25 0.15]);
    filt_button = view.Button(tab3,'filter',8,[.47,.5,.07,.05],@filtCB);
    
    filter_x_widgets = [filter_size_label_x,filter_size_value_x];
    filter_y_widgets = [filter_size_label_y, filter_size_value_y];
    filter_z_widgets = [filter_size_label_z, filter_size_value_z];
    
    filter_option_widgets = [filter_x_widgets,filter_y_widgets,filter_z_widgets];
    
%% Construct the About area
    about_panel = view.Container(tab4,panel_color,'About this software',10,[.1,.1,.8,.8]);    
    about_message = view.Label(about_panel, 'TBD - Future home of the about area (description of the project)!', 10, [0.2,0.5, .60, .07]);    
    
    % initialize text boxes to 0
    f_values = [filter_size_value_x,filter_size_value_y,filter_size_value_z];
    view.InitializeValues(f_values);
%     view.InitializeValues(all_spect_widgets);
    view.HideWidgets(all_spect_widgets);
    view.HideWidgets(filter_option_widgets);
    
%% Define the callbacks for buttons etc.  

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

    function saveShapeImage(hObj, event)
        ctrl.SaveImage(6, tab2);
    end

    % Callback function for "Convolve" button
    function convCB(hObj, event)
        ctrl.DoConvolution(conv_img3);
    end  

    % opens a file dialog for the user to save the filter result
    function saveFilteredImage(hObj, event)        
        ctrl.SaveImage(5, tab3);        
    end

    function generateShapeCB(hObj, event)
        spect_shape = spectrumImageTypes{get(spectrum_imageDD, 'Value')};          
        switch(spect_shape)
            
            case 'Sinusoids'
                params = [double(str2double(get(spect_sin_value_u,'String'))),...
                    double(str2double(get(spect_sin_value_v, 'String'))),...
                ];
               ctrl.DoSinusoid(params, spect_img);
            case 'Single Circle'
                params = [double(str2double(get(spect_one_circle_value_r,'String')))];
                ctrl.DoSingleCircle(params, spect_img);
            case 'Single Rectangle'
                params = [double(str2double(get(spect_one_rect_value_w,'String'))),...
                          double(str2double(get(spect_one_rect_value_h,'String')))];
                ctrl.DoSingleRectangle(params, spect_img);                
            case 'Multiple Circles'
                params = [double(str2double(get(spect_multi_circle_value_r,'String'))),...
                          double(str2double(get(spect_multi_circle_value_x,'String'))),...
                          double(str2double(get(spect_multi_circle_value_y,'String')))];
                ctrl.DoMultipleCircles(params, spect_img);
            case 'Multiple Rectangles'
                params = [double(str2double(get(spect_multi_rect_value_w,'String'))),...
                          double(str2double(get(spect_multi_rect_value_h,'String'))),...
                          double(str2double(get(spect_multi_rect_value_x,'String'))),...
                          double(str2double(get(spect_multi_rect_value_y,'String')))];
                ctrl.DoMultipleRectangles(params, spect_img);                
            case 'Single Stripes'
                params = [double(str2double(get(single_stripe_value_dir,'String')))];
                ctrl.DoSingleStripe(params, spect_img);
            case 'Multiple Stripes'
                params = [double(str2double(get(multiple_stripe_value_num,'String'))),...
                    double(str2double(get(multiple_stripe_value_dir,'String')))];
                ctrl.DoMultipleStripes(params, spect_img);                
            case 'Image from File'
                
            otherwise
                disp('bad shape type.')
        end
        
%         
%         model.CreateImage(6, x, imresize(x,img_icon));
%         view.UpdateImage(spect_img, model.GetImageIcon(6));    
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
        view.HideWidgets(all_spect_widgets);
        
        switch(txt)
            
            case 'Sinusoids'
                view.ShowWidgets(sinusoid_widgets);
            case 'Single Circle'
                view.ShowWidgets(single_circle_widgets);
            case 'Single Rectangle'
                view.ShowWidgets(single_rectangle_widgets);
            case 'Multiple Circles'
                view.ShowWidgets(multiple_circles_widgets);
            case 'Multiple Rectangles'
                view.ShowWidgets(multiple_rectangles_widgets);
            case 'Single Stripes'
                view.ShowWidgets(single_stripe_widgets);
            case 'Multiple Stripes'
                view.ShowWidgets(multiple_stripes_widgets);
            case 'Image from File'
                view.ShowWidgets(img_from_file_widgets);
            otherwise
                disp('bad shape type.')
        end
    end
    
    % Callback function for filter dropdown
    function filterTypeDDCallback(hObj, event)
        txt = filterTypes{get(filterDD, 'Value')};
        disp(txt)
        xt = impulseResponseTypes{get(impRespDD, 'Value')};
        disp(txt)
        
        switch(txt)    
            
            case 'Impulse Response'
%                 set(filter_size_label_x, 'String', 'Size(x):');
%                 set(filter_size_label_x, 'String', 'Size(y):');
                set(freqRespDD,'Visible', 'off');
                set(freqVarietyDD, 'Visible', 'off');
                set(fvariety_label, 'Visible', 'off');
                set(impRespDD,'Visible', 'on');
                set(freqRespDD,'Visible', 'off');
                disp('Impulse response selected.')
            case 'Frequency Response'
%                 set(filter_size_label_x, 'String', 'Cutoff Freq:');
%                 set(filter_size_label_x, 'String', 'Order(n):');
                set(freqRespDD,'Visible', 'on');
                set(freqVarietyDD, 'Visible', 'on');
                set(fvariety_label, 'Visible', 'on');
                set(freqRespDD,'Visible', 'on');
                set(impRespDD,'Visible', 'off');
                disp('Frequency response selected.')
            otherwise
                disp('bad filter type')
        end     
    end

    function freqVarietyTypeDDCallback(hObj, event)
        txt = frequencyResponseTypes{get(freqRespDD, 'Value')};
        disp(txt)        
        view.HideWidgets(filter_option_widgets);
%         frequencyResponseTypes  = {'lowpass', 'highpass','bandpass','bandreject','notch reject'};
%         frequencyVarietyTypes = {'ideal', 'gaussian', 'butterworth'};
%         txt = frequencyResponseTypes{get(freqRespDD, 'Value')};        
        switch(txt)
            case 'lowpass'
                switch(frequencyVarietyTypes{get(freqVarietyDD, 'Value')})
                    case 'ideal'
                        view.ShowWidgets(filter_x_widgets);
                        set(filter_size_label_x,'String','Cutoff freq.');
                    case 'gaussian'
                        view.ShowWidgets(filter_x_widgets);            
                        set(filter_size_label_x,'String','Cycles/samp.');
                    case 'butterworth'
                        view.ShowWidgets([filter_x_widgets,filter_y_widgets]);
                        set(filter_size_label_x,'String','Cycles/samp.');
                        set(filter_size_label_y,'String','Order(n)');
                    otherwise
                        disp('bad response type')
                end
            case 'highpass'
                switch(frequencyVarietyTypes{get(freqVarietyDD, 'Value')})
                    case 'ideal'
                        view.ShowWidgets(filter_x_widgets);
                        set(filter_size_label_x,'String','Cutoff freq.');
                    case 'gaussian'
                        view.ShowWidgets(filter_x_widgets);            
                        set(filter_size_label_x,'String','Cycles/samp.');
                    case 'butterworth'
                        view.ShowWidgets([filter_x_widgets,filter_y_widgets]);
                        set(filter_size_label_x,'String','Cycles/samp.');
                        set(filter_size_label_y,'String','Order(n)');
                    otherwise
                        disp('bad response type')
                end                
            case 'bandpass'
                switch(frequencyVarietyTypes{get(freqVarietyDD, 'Value')})
                    case 'ideal'
                        view.ShowWidgets([filter_x_widgets,filter_y_widgets]);
                        set(filter_size_label_x,'String','Cutoff freq.');
                        set(filter_size_label_y,'String','Bandwidth');
                    case 'gaussian'
                        view.ShowWidgets([filter_x_widgets,filter_y_widgets]);
                        set(filter_size_label_x,'String','Cutoff freq.');
                        set(filter_size_label_y,'String','Bandwidth');
                    case 'butterworth'
                        view.ShowWidgets([filter_x_widgets,filter_y_widgets,filter_z_widgets]);
                        set(filter_size_label_x,'String','Cutoff freq.');
                        set(filter_size_label_y,'String','Bandwidth');
                        set(filter_size_label_z,'String','Order(n)');
                    otherwise
                        disp('bad response type')
                end
            case 'bandreject'
                switch(frequencyVarietyTypes{get(freqVarietyDD, 'Value')})
                    case 'ideal'
                        view.ShowWidgets([filter_x_widgets,filter_y_widgets]);
                        set(filter_size_label_x,'String','Cutoff freq.');
                        set(filter_size_label_y,'String','Bandwidth');
                    case 'gaussian'
                        view.ShowWidgets([filter_x_widgets,filter_y_widgets]);
                        set(filter_size_label_x,'String','Cutoff freq.');
                        set(filter_size_label_y,'String','Bandwidth');
                    case 'butterworth'
                        view.ShowWidgets([filter_x_widgets,filter_y_widgets,filter_z_widgets]);
                        set(filter_size_label_x,'String','Cutoff freq.');
                        set(filter_size_label_y,'String','Bandwidth');
                        set(filter_size_label_z,'String','Order(n)');
                    otherwise
                        disp('bad response type')
                end
            case 'notch reject'
                
            otherwise
                disp('bad frequency variety selected.')
        end
        
    end

    % Callback function for impulse response dropdown
    function impulseTypeDDCallback(hObj,event)
        txt = impulseResponseTypes{get(impRespDD, 'Value')};
        disp(txt)
        view.HideWidgets(filter_option_widgets);
        switch(txt)            
            case 'average'
                view.ShowWidgets([filter_x_widgets,filter_y_widgets]);
                set(filter_size_label_x,'String','Width');
                set(filter_size_label_y,'String','Height');
            case 'disk'
                view.ShowWidgets([filter_x_widgets]);    
                set(filter_size_label_x,'String','Radius');
            case 'gaussian'
                view.ShowWidgets([filter_x_widgets,filter_y_widgets,filter_z_widgets]);
                set(filter_size_label_x,'String','Width');
                set(filter_size_label_y,'String','Height');
                set(filter_size_label_z,'String','Sigma');
            case 'laplacian'
                view.ShowWidgets([filter_x_widgets]);
            case 'log'
                view.ShowWidgets([filter_x_widgets,filter_y_widgets,filter_z_widgets]);
                set(filter_size_label_x,'String','Rows');
                set(filter_size_label_y,'String','Cols');
                set(filter_size_label_z,'String','Sigma');
            case 'motion'
                view.ShowWidgets([filter_x_widgets,filter_y_widgets]);
                set(filter_size_label_x,'String','Length');
                set(filter_size_label_y,'String','Theta');
            case 'sobel'
                
            case 'prewitt'
                
            case 'unsharp'
                view.ShowWidgets([filter_x_widgets]);
                set(filter_size_label_x,'String','Alpha');
            otherwise
                disp('Invalid filter typ...e' );
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
            double(str2double(get(filter_size_value_z, 'String')))];     
        
        if(strcmp(filterTypes{get(filterDD, 'Value')},'Impulse Response')==0)
            ctrl.DoFiltering(frequencyResponseTypes{get(freqRespDD,'Value')},...
                params, filt_img5, frequencyVarietyTypes{get(freqVarietyDD, 'Value')},filt_img4);
        else
            ctrl.DoFiltering(impulseResponseTypes{get(impRespDD,'Value')},...
                params, filt_img5, 0,4);
        end
    end 
     
end