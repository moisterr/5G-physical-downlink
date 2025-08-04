function [] = plotNrConstellation(moduType)
% plotNrConstellation Visualizes constellation diagram for 5G NR modulation schemes
%
% Input:
%   moduType - Modulation type as a string: 
%              'bpsk', 'qpsk', '16qam', '64qam', or '256qam'
%
% This function uses nrModuMapper to generate complex modulation symbols
% and plots them on the IQ (In-phase, Quadrature) plane with binary labels.

close all;  % Close existing figures

% Set normalization factor (A), number of constellation points (M),
% x-axis scaling (xMax), and figure height depending on modulation
switch lower(moduType)
    case 'bpsk'
        A = 1;
        M = 2;
        xMax = 1.2;
        figHeight = 250;
    case 'qpsk'
        A = 1/sqrt(2);
        M = 4;
        xMax = 1.2;
        figHeight = 250;
    case '16qam'
        A = 1/sqrt(10);
        M = 16;
        xMax = 3.2;
        figHeight = 600;
    case '64qam'
        A = 1/sqrt(42);
        M = 64;
        xMax = 7.5;
        figHeight = 800;
    case '256qam'
        A = 1/sqrt(170);
        M = 256;
        xMax = 15.9;
        figHeight = 1200;
end

% Generate all binary input combinations for the modulation
% Each row of symbBits represents one symbol's bit pattern
symbBits = de2bi(0:M-1, 'left-msb');   % Binary values from 0 to M-1
symbBitsIn = symbBits.';              % Transpose to column format

% Use the NR mapper function to get complex symbols
symbs = nrModuMapper(symbBitsIn(:), lower(moduType));  % Linear input vector

close all;

% Plot constellation points normalized by A
plot(symbs/A, 'or', 'MarkerFaceColor','r');
hold on;

% Label each point with corresponding binary string
for i = 1:M
    str = num2str(symbBits(i,:));      % Convert bits to string
    str = str(find(~isspace(str)));    % Remove spaces
    text(real(symbs(i))/A, imag(symbs(i))/A - 0.3, ...
        str, 'HorizontalAlignment','center');  % Label point
end

% Set plot limits and formatting
xlim([-xMax, xMax]);
ylim([-xMax - 0.3, xMax]);
xlabel({'Inphase', '(A)'});
ylabel({'Qadrature', '(A)'});
xticks([-floor(xMax):2:-1 0 1:2:floor(xMax)]);
yticks([-floor(xMax):2:-1 0 1:2:floor(xMax)]);
grid on;

% Resize figure for visibility
set(gcf, 'Position', [100 100 figHeight figHeight]);
title([moduType ' Constellation']);

end
