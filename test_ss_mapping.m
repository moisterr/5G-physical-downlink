% File: test_ss_mapping.m

% Main script to test PSS and SSS mapping into the SS/PBCH block.

% Add the 'component' folder to MATLAB's path so helper functions can be found.

% Make sure the 'component' folder exists in the same directory as this script.

addpath('component');

% 1. Initialize the SS/PBCH block matrix

ssblock = zeros(240, 4);

fprintf('Initial SS/PBCH block matrix size: %dx%d\n', size(ssblock, 1), size(ssblock, 2));

% 2. Generate PSS Symbols and Map to SS/PBCH Block

ncellid = 17; % Example Physical Cell ID

pssSymbols = generatePssSymbols(ncellid); % Call custom PSS symbol generator

pssIndices = generatePssIndices(size(ssblock)); % Generate PSS indices

ssblock(pssIndices) = 1 * pssSymbols; % Map PSS symbols (beta_PSS = 1)

fprintf('\nGenerated PSS symbols for ncellid = %d (u = %d):\n', ncellid, mod(ncellid, 3));

disp(pssSymbols(1:15));

fprintf('Shape of generated PSS symbols: %dx%d\n', size(pssSymbols, 1), size(pssSymbols, 2));

fprintf('First 15 PSS indices:\n');

disp(pssIndices(1:15));

% 3. Generate SSS Symbols and Map to SS/PBCH Block

sssSymbols = generateSssSymbols(ncellid); % Call custom SSS symbol generator

sssIndices = generateSssIndices(size(ssblock)); % Generate SSS indices

ssblock(sssIndices) = 1 * sssSymbols; % Map SSS symbols (beta_SSS = 1)

fprintf('\nGenerated SSS symbols for ncellid = %d (NID1=%d, NID2=%d):\n', ncellid, floor(ncellid/3), mod(ncellid,3));

disp(sssSymbols(1:15));

fprintf('Shape of generated SSS symbols: %dx%d\n', size(sssSymbols, 1), size(sssSymbols, 2));

fprintf('First 15 SSS indices:\n');

disp(sssIndices(1:15));

% 4. Display the updated SS/PBCH block (first 15 rows)

fprintf('\nSS/PBCH block after mapping PSS and SSS symbols (first 15 rows, all 4 columns):\n');

disp(ssblock(1:15, :));

% 5. Plot the SS/PBCH block matrix to show the location of PSS and SSS

figure; % Open a new figure window for the plot

imagesc(abs(ssblock));

colormap(jet); % Use a colormap like 'jet' to clearly show values

colorbar; % Add a color bar to interpret the colors

axis xy; % Flip Y-axis to match typical resource grid visualization (subcarrier low at bottom)

xlabel('OFDM Symbol');

ylabel('Subcarrier');

title('SS/PBCH Block with PSS and SSS Mapped (Custom Functions)');

hold on;

% Highlight PSS location (OFDM symbol 1, subcarriers 57-183)

rectangle('Position', [0.5, 56.5, 1, 127], 'EdgeColor', 'r', 'LineWidth', 2, 'LineStyle', '--');

text(1, 120, 'PSS', 'Color', 'white', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% Highlight SSS location (OFDM symbol 2, subcarriers 57-183)

rectangle('Position', [2.5, 56.5, 1, 127], 'EdgeColor', 'g', 'LineWidth', 2, 'LineStyle', '--');

text(3, 120, 'SSS', 'Color', 'white', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

hold off;

% To run this script:

% 1. Create a folder named 'component' in the same directory as this script.

% 2. Save the .m files for each function into the 'component' folder.

% 3. Save this script as 'test_ss_mapping.m' in the main directory.

% 4. In MATLAB Command Window, navigate to the main directory and type 'test_ss_mapping' and press Enter.