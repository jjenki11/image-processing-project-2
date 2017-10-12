function [mag, phase] = imspecxy(in,offset)
    %
    % imspecxy(in,offset)
    %
    % Displays the Discrete-Space Fourier Transform (DSFT) of an image.  
    % Uses fft2( ) to compute samples of the DSFT.
    % The log of the values of the magnitude spectrum are mapped
    % to grayscale values and diaplyed as an image.  The
    % phase values are linearly mapped to grayscale values and 
    % also displayed as an image (pi -> white, -pi -> black).
    % 
    % in        Input image (2D array) 
    %           Assumed to be in xy format with in(1,1) being the lower left
    %           hand corner of the image
    %
    % offset    Optional
    %           Value added to Magnitude response prior to
    %           taking the log.  This effectively results in smaller values 
    %           shown darker than  with a standard log mapping.  
    %           This may be helpful in seeing where the small spectrum values lie.
    %           (Suggested offset=100+, default=1).


%     figure
    imstdxy(double(in));

    if nargin < 2
        offset=1;
    end

    X=fftshift(fft2(in));

    [sy,sx]=size(in);
    w1=linspace(-pi,pi,sx);
    w2=linspace(-pi,pi,sy);

    % figure
    mag=imlinxy(w1,w2,log(abs(X)+offset));
    % title('DSFT Magnitude');
    % xlabel('\omega_1 (radians/sample)');
    % ylabel('\omega_2 (radians/sample)');

    % figure
    phase=imlinxy(w1,w2,angle(X));
    % title('DSFT Phase');
    % xlabel('\omega_1 (radians/sample)');
    % ylabel('\omega_2 (radians/sample)');
end