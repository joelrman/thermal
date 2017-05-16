function EFIELD = calibIR(imagename,Ecalib)
% calibIR.m
%
% Written by: Joel R. Mangalasinghe
% Melbourne Space Program Ltd. and Melbourne School of Engineering, The
% University of Melbourne
% Last modified: 16-May-17
%
% Function that produces a resultant emissivity map by operating on a
% grayscale Infra-Red thermal image that contains the component to be
% analysed along with a calibration material.
%
% Desired 'colormap <map>' setting should be set prior to running code.
%
% IMPORTANT!
% The component and calibration material are all at the same uniform
% temperature at least 20C above ambient. The emissivity of the calibration
% material is known. Measurement should take place such that reflected
% temperature is uniform and this should be input into the IR camera.
% Program only works when IR input image is in grayscale colour scheme!
%
% FUNCTION INPUTS:
% imagename = A string containing the filename of the image being analysed
% without the file extension.
% Ecalib = A number representing the emissivity of the calibration section
%
% INPUTS AFTER STARTING FUNCTION:
% Zcalib = A number that is found by interrogating the coordinate of the
% calibration section in the displayed figure. This number is the 'Z'
% value.
% Zbarmin = The Z value found by interrogating the coordinate at the
% left-most side of the colour-bar.
% Zbarmax = The Z value found by interrogating the coordinate at the
% right-most side of the colour-bar.
% Tmin = A number that is shown on the left side of the temperature
% colour-bar that represents the minimum temperature in that image.
% Tmax = A number that is shown on the right side of the temperature
% colour-bar that represents the maximum temperature in that image.
%
% OUTPUTS:
% EFIELD = A map of the emissivity of the entire component.
%
% Variable prefix name convention:
% T = Temperature in Celsius
% i = Z value
% E = emissivity
%
% Variable suffix name convention:
% calib = calibrated section
% FIELD = a matrix that represents some property of the entire input image
% barmin/barmax = the minimum/maximum property on the colourbar

imgMAT = imread(imagename,'jpg'); % Saving image into uint8 matrix
ZFIELD = double(imgMAT(:,:,1)); % Convert to double to avoid uint8 255 max

% Showing picture
surf(flipud(ZFIELD),'EdgeColor','None')
view(2)
imgsize = size(ZFIELD);
axis([1 imgsize(2) 1 imgsize(1)])
daspect([1,1,1])

% Inputs from image
fprintf('To complette ''Z'' value tasks, you may need to press Ctrl-C \n to interrogate figure and then re-run function:');
Zcalib = input('Enter ''Z'' value of calibration section:\n');
Zbarmin = input('Enter ''Z'' value at min colour-bar temperature:\n');
Zbarmax = input('Enter ''Z'' value at max colour-bar temperature:\n');
Tmin = input('Enter min temperature (C) on temperature colour-bar:\n');
Tmax = input('Enter max temperature (C) on temperature colour-bar:\n');

% Calibration factor for change in temperature to change in Z value
m = (Tmax-Tmin)/(Zbarmax-Zbarmin);

% Calculating temperatures from Z values
% % T0 = Tmin-m*(Zbarmin - 0); % For debugging
% % T255 = Tmax+m*(255 - ibarmax); % For debugging
Tcalib = Tmin+m*(Zcalib - Zbarmin);
TFIELD = m*(ZFIELD - Zbarmin)+Tmin;

% Calculating emissivities from temperatures
EFIELD = Ecalib*(TFIELD+273).^4/(Tcalib+273).^4;

% Showing emissivity map
surf(flipud(EFIELD),'EdgeColor','None')
view(2)
axis([1 imgsize(2) 1 imgsize(1)])
daspect([1,1,1])
end