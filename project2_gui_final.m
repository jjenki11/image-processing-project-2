% another test comment
function project2_gui_final()
 
    % This is our ui wrapper class
    uic = ui_components;
    
    % Create the main container
    window = uic.Container([0.9255 0.9137 0.8471],'Demo',[100 50 800 600]);   
    
    % This is an ugly little section... cant get it to work when wrapping
    % it in the ui_components class
    tgroup = uitabgroup('Parent', window);
    tab0 = uitab('Parent', tgroup, 'Title', 'Home');
    tab1 = uitab('Parent', tgroup, 'Title', 'Convolution');
    tab2 = uitab('Parent', tgroup, 'Title', 'Draw Spectrum');
    tab3 = uitab('Parent', tgroup, 'Title', 'Filtering');
    tab4 = uitab('Parent', tgroup, 'Title', 'About');
    set(tgroup,'SelectionChangeCallback',@(obj,evt) tabChangedCB(obj,evt));
                      
    % Add axes on left side for time domain plot
    ax1 = uic.Plot(tab1,[0.07 0.37 0.40 0.58]);
 
    % Add axes on right side for frequency domain plot
    ax2 = uic.Plot(tab1,[0.55 0.37 0.40 0.58]);
 
    % Add "Frequency" slider control to window
    f_slider = uic.Slider(tab1,[0.2 0.22 0.6 0.08],[0 100],10,@updateGraph);
 
    % Add "Amplitude" slider control to window
    A_slider = uic.Slider(tab1,[0.2 0.12 0.6 0.08],[0 10],5,@updateGraph);
 
    % Add "Frequency" edit control to window
    f_edit = uic.Edit(tab1,18,[0.82 0.22 0.16 0.08]);
 
    % Add "Amplitude" edit control to window
    A_edit = uic.Edit(tab1,18,[0.82 0.12 0.16 0.08]);
 
    % Add "Frequency" label control to window
    f_label = uic.Label(tab1,'Frequency:',18,[0.02 0.22 0.16 0.08]);
 
    % Add "Amplitude" label control to window
    A_label = uic.Label(tab1,'Amplitude:',18,[0.02 0.12 0.16 0.08]);
 
    % Add "Sin" button to window
    sin_button = uic.Button(tab1,'Sine',18,[0.22 0.02 0.16 0.08],@sinCallback);
 
    % Add "Square" button to window
    sqr_button = uic.Button(tab1,'Square',18,[0.42 0.02 0.16 0.08],@sqrCallback);
 
    % Add "Saw" button to window
    saw_button = uic.Button(tab1,'Saw',18,[0.62 0.02 0.16 0.08],@sawCallback);
    
    % A dropdown test
    %test_dd = uic.DropDown(tab1,{'a', 'b', 'c', 'd'}, [0.62 0.02 0.16 0.08], @sawCallback);
    
    % Set up signal data
    T=0.001;tmax=1;
    t=0:T:tmax;
    N=length(t);
    fs=1/T;fax=0:fs/N:(N-1)*fs/N;
    A=5;f=4;
 
    % Set up plot titles and axis labels
    xlabel(ax1, 'time seconds');
    ylabel(ax1, 'amplitude')
    title(ax1, 'Time waveform')
    
    xlabel(ax2, 'frequency Hz');
    ylabel(ax2, 'magnitude')
    title(ax2, 'Magnitude Frequency Spectrum')
 
    wave_shape  = 1; % 1 is sin, 2 is squarewave, 3 is sawtooth
 
    % Call the slider callback function once when the
    % program first runs to make sure that the plots
    % appear immediately (without the user clicking anything)
    updateGraph()
    
    
 
    % Callback function for "Sine" button
    function sinCallback(hObj, event)
        wave_shape = 1;
        updateGraph()
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
        tabName = event.OldValue.Title
        if strcmp(tabName, 'Convolution')
            disp('byebyeconvolution')
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
        plot(ax1, t, x);
        set(ax1, 'xlim', [0 1], 'ylim', [-11 11])
        plot(ax2, fax, abs(X));
        set(ax2, 'xlim', [0 100], 'ylim', [0 11])
 
        % Update frequency and amplitude text
        set(f_edit, 'String', f)
        set(A_edit, 'String', A)
    end
 
end