% PDCCH_test.m - Full PDCCH simulation (Encoding part)

% Add the 'component' directory to the MATLAB path
addpath component\

% 1. Generate payload (input bits 'a')
% According to your PDCCH_encode function constraints:
% - A (length of 'a') should be > 0 and <= 140.
% Let's choose a payload length of 100 bits as an example.
payload_length_a = 100;
a = randi([0 1], 1, payload_length_a); % Generate random 0s and 1s
disp('--- 1. Payload (Input bits ''a'') ---');
disp(['Length of ''a'': ', num2str(length(a))]);
disp(a(1:min(15, end))); % Display first 15 bits for brevity

% 2. Define E (desired number of output bits)
% According to your PDCCH_encode function constraints:
% - E should be <= 8192.
% Let's choose E = 512 as an example.
E = 512;
disp(' ');
disp(['--- 2. Desired Output Bits (E): ', num2str(E), ' ---']);

% 3. Define RNTI (Radio Network Temporary Identifier)
% According to your PDCCH_encode function constraints:
% - RNTI should be a 1x16 array of bits.
% You can use the default (all ones) or specify your own.
RNTI = ones(1, 16); % Using the default RNTI
% RNTI = randi([0 1], 1, 16); % Or generate a random RNTI
disp(' ');
disp('--- 3. RNTI (16-bit) ---');
disp(RNTI);

% 4. Channel coding (PDCCH Encoding)
% Call your PDCCH_encode function
try
    f = PDCCH_encode(a, E, RNTI); % Encoded bits
    disp(' ');
    disp('--- 4. Polar Encoded Output (f) ---');
    disp(['Length of encoded output ''f'': ', num2str(length(f))]);
    disp(f(1:min(15, end))); % Display first 15 bits for brevity

    % You can also verify if the output length matches E
    if length(f) == E
        disp('Output length matches the desired E value. Encoding successful!');
    else
        disp('WARNING: Output length does NOT match the desired E value. Check encoding logic.');
    end

catch ME
    % Catch and display any errors from PDCCH_encode
    disp(' ');
    disp('--- ERROR during PDCCH_encode ---');
    disp(ME.message);
    disp('Encoding failed. Please check your PDCCH_encode function and its dependencies.');
end

if exist('f', 'var') && ~isempty(f) && length(f) > 0
    c = f; % Assign encoded bits to 'c' for modulation
    % 5. Modulation
    moduType = 'QPSK';
    try
        symb = nrModuMapper(c, moduType);
        disp(' ');
        disp('--- 5. Modulated Symbols (symb) ---');
        disp('Modulation successful.');
        disp(['Number of Modulated Symbols: ', num2str(length(symb))]);
        disp(symb(1:min(15, end))); % Display first 15 complex symbols
        % Plotting QPSK constellation
        figure;
        scatter(real(symb), imag(symb), 'filled');
        axis equal; grid on;
        xlabel('In-phase'); ylabel('Quadrature');
        title('Modulated Symbols for PDCCH (QPSK)');
    catch ME_mod
        disp(' ');
        disp('--- ERROR during Modulation ---');
        disp(ME_mod.message);
        disp('Modulation failed. Please ensure nrModuMapper is correctly implemented or available.');
    end
end