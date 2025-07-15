% PBCH_test.m - Full PBCH simulation
addpath component\

% 1. Generate payload
a = randi([0 1], 1, 32);  % 32-bit payload
disp('Payload:');
disp(a);

% 2. Channel coding
f = PBCH_encode(a);        % Encoded bits (864 bits)
disp('Polar Encoded:');
disp(f);
c = f; 

% 4. Modulation
moduType = 'QPSK';
symb = nrModuMapper(c, moduType);

% --- Display the modulated symbols ---
%disp('Modulated Symbols (symb):');
%disp(symb(1:15)); % Display first 15 complex symbols
%fprintf('Number of Modulated Symbols: %d\n', length(symb));

% qpsk option
% scatter(real(symb), imag(symb), 'filled');
 %axis equal; grid on;
 %xlabel('In-phase'); ylabel('Quadrature');
 %title('Modulated Symbols for PBCH (QPSK)');

