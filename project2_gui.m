
function project2_gui()
 
    % Create a window for the GUI
    window = figure('Color', [0.9255 0.9137 0.8471],...
                    'Name', 'Time Frequency Demo',...
                    'DockControl', 'off',...
                    'Units', 'Pixels',...
                    'Position', [100 50 800 600]);
 
    % Add axes on left side for time domain plot
    ax1 = axes('Parent', window,...
                    'Units', 'normalized',...
                    'Position', [0.07 0.37 0.40 0.58])
 
    % Add axes on right side for frequency domain plot
    ax2 = axes('Parent', window,...
                    'Units', 'normalized',...
                    'Position', [0.55 0.37 0.40 0.58])
 
    % Add "Frequency" slider control to window
    f_slider = uicontrol('Parent', window,...
                    'Style', 'slider',...
                    'Units', 'normalized',...
                    'Position', [0.2 0.22 0.6 0.08],...
                    'Min', 0,...
                    'Max', 100,...
                    'Value', 10,...
                    'Callback', @updateGraph);
 
    % Add "Amplitude" slider control to window
    A_slider = uicontrol('Parent', window,...
                    'Style', 'slider',...
                    'Units', 'normalized',...
                    'Position', [0.2 0.12 0.6 0.08],...
                    'Min', 0,...
                    'Max', 10,...
                    'Value', 5,...
                    'Callback', @updateGraph);
 
    % Add "Frequency" edit control to window
    f_edit = uicontrol('Parent', window,...
                    'Style', 'edit',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.82 0.22 0.16 0.08]);
 
    % Add "Amplitude" edit control to window
    A_edit = uicontrol('Parent', window,...
                    'Style', 'edit',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.82 0.12 0.16 0.08]);
 
    % Add "Frequency" label control to window
    f_label = uicontrol('Parent', window,...
                    'Style', 'text',...
                    'String', 'Frequency:',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.02 0.22 0.16 0.08]);
 
    % Add "Amplitude" label control to window
    A_label = uicontrol('Parent', window,...
                    'Style', 'text',...
                    'String', 'Amplitude:',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.02 0.12 0.16 0.08]);
 
    % Add "Sin" button to window
    sin_button = uicontrol('Parent', window,...
                    'Style', 'pushbutton',...
                    'String', 'Sine',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.22 0.02 0.16 0.08],...
                    'Callback', @sinCallback);
 
    % Add "Square" button to window
    sqr_button = uicontrol('Parent', window,...
                    'Style', 'pushbutton',...
                    'String', 'Square',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.42 0.02 0.16 0.08],...
                    'Callback', @sqrCallback);
 
    % Add "Saw" button to window
    saw_button = uicontrol('Parent', window,...
                    'Style', 'pushbutton',...
                    'String', 'Saw',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.62 0.02 0.16 0.08],...
                    'Callback', @sawCallback);
 
    % Set up signal data
    T=0.01;tmax=1;
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