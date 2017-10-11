% another test comment
function project2_gui_final()
 
    % This is our ui wrapper class
    view = ui_components();
    
    % Create the main container
    window = view.Container([0.9255 0.9137 0.8471],'Demo',[100 50 800 600]);   
    
    % This is an ugly little section... cant get it to work when wrapping
    % it in the ui_components class
    tgroup = uitabgroup('Parent', window);
    tab0 = uitab('Parent', tgroup, 'Title', 'Home');
    tab1a = uitab('Parent', tgroup, 'Title', 'Convolution');
    tab1 = uitab('Parent', tgroup, 'Title', 'Convolution (testing)');
    tab2 = uitab('Parent', tgroup, 'Title', 'Draw Spectrum');
    tab3 = uitab('Parent', tgroup, 'Title', 'Filtering');
    tab4 = uitab('Parent', tgroup, 'Title', 'About');
    
    %set(tgroup,'SelectionChangeFcn',@tabChangedCB); % @(obj,evt) tabChangedCB(obj,evt));
    tgroup.SelectionChangedFcn = '@tabChangedCB';
%     i1 = imread('cameraman.tif');
    
% starting the convolution tab
    conv_img1 = view.ImageWindow(tab1a,[0.07 0.37 0.50 0.58],zeros(500,500)); 
    img1_path = view.Edit(tab1a,8,[0.07 0.6 0.3 0.08]); 
    img1_browser = view.Button(tab1a,'...',12,[0.37 0.6 0.09 0.08],@file1CB);
    
    conv_img2 = view.ImageWindow(tab1a,[0.07 0.01 0.50 0.58],zeros(500,500)); 
    img2_path = view.Edit(tab1a,8,[0.07 0.2 0.3 0.08]); 
    img2_browser = view.Button(tab1a,'...',12,[0.37 0.2 0.09 0.08],@file2CB);
    
    
                      
    % Add axes on left side for time domain plot
    ax1 = view.Plot(tab1,[0.07 0.37 0.40 0.58]); 
    % Add axes on right side for frequency domain plot
    ax2 = view.Plot(tab1,[0.55 0.37 0.40 0.58]); 
    % Add "Frequency" slider control to window
    f_slider = view.Slider(tab1,[0.2 0.22 0.6 0.08],[0 100],10,@updateGraph); 
    % Add "Amplitude" slider control to window
    A_slider = view.Slider(tab1,[0.2 0.12 0.6 0.08],[0 10],5,@updateGraph); 
    % Add "Frequency" edit control to window
    f_edit = view.Edit(tab1,18,[0.82 0.22 0.16 0.08]); 
    % Add "Amplitude" edit control to window
    A_edit = view.Edit(tab1,18,[0.82 0.12 0.16 0.08]); 
    % Add "Frequency" label control to window
    f_label = view.Label(tab1,'Frequency:',18,[0.02 0.22 0.16 0.08]); 
    % Add "Amplitude" label control to window
    A_label = view.Label(tab1,'Amplitude:',18,[0.02 0.12 0.16 0.08]); 
    % Add "Sin" button to window
    sin_button = view.Button(tab1,'Sine',18,[0.22 0.02 0.16 0.08],@sinCallback); 
    % Add "Square" button to window
    sqr_button = view.Button(tab1,'Square',18,[0.42 0.02 0.16 0.08],@sqrCallback); 
    % Add "Saw" button to window
    saw_button = view.Button(tab1,'Saw',18,[0.62 0.02 0.16 0.08],@sawCallback);    
    % Set up signal data
    T=0.001;tmax=1;
    t=0:T:tmax;
    N=length(t);
    fs=1/T;fax=0:fs/N:(N-1)*fs/N;
    A=5;f=4;    
    % 1 is sin, 2 is squarewave, 3 is sawtooth
    wave_shape  = 1; 
 
    % Call the slider callback function once when the
    % program first runs to make sure that the plots
    % appear immediately (without the user clicking anything)
    updateGraph();    
    
    
    
    % A dropdown test
    %test_dd = view.DropDown(tab1,{'a', 'b', 'c', 'd'}, [0.62 0.02 0.16 0.08], @sawCallback);
    
    
    
 
    % Callback function for "Sine" button
    function sinCallback(hObj, event)
        wave_shape = 1;
        updateGraph()
    end

    % Callback function for "browser" button
    function file1CB(hObj, event)
%         wave_shape = 1;
        disp('yoyoma')
        p = view.FileBrowser(tab1a,[0.1 0.37 0.4 0.2],[]);
        set(img1_path,'String',p);
%         disp(p)
    end

    % Callback function for "browser" button
    function file2CB(hObj, event)
%         wave_shape = 1;
        disp('yoyoma')
        p = view.FileBrowser(tab1a,[0.1 0.37 0.4 0.2],[]);
        set(img2_path,'String',p);
    end
 
    % Callback function for "Square" button
    function sqrCallback(hObj, event)
        wave_shape = 2;
        updateGraph()
    end
 
    % Callback function for "Saw" button
    function sawCallback(hObj, event)
        wave_shape = 3;
        updateGraph()
    end

    % Callback for tab change
    function tabChangedCB(hObj, event)
        tabName = event.OldValue.Title;
        if strcmp(tabName, 'Home')
            disp('byebyeconvolution')
            view.UpdateImage(conv_img1, imread('cameraman.tif'));
            view.UpdateImage(conv_img2, imread('cameraman.tif'));
        end
    end
 
    % Callback funuction for both slider controls
    function updateGraph(hObj, event)
        f = get(f_slider, 'Value')
        A = get(A_slider, 'Value')
 
        if wave_shape == 1
            x = A*cos(2*pi*f*t);
        elseif wave_shape == 2
            x = A*square(2*pi*f*t);
        else
            x = A*sawtooth(2*pi*f*t);
        end
 
        X=fft(x)/(N/2);

        view.UpdatePlot(ax1, t, x, 'time seconds', 'amplitude', ...
                      'Time waveform', [0 1], [-11 11]);

        view.UpdatePlot(ax2, fax, abs(X), 'frequency Hz', 'magnitude', ...
                      'Magnitude Frequency Spectrum', [0 100], [0 11]);
 
        % Update frequency and amplitude text
        set(f_edit, 'String', f)
        set(A_edit, 'String', A)
    end
 
end