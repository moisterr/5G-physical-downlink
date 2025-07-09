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

% qpsk option
% scatter(real(symb), imag(symb), 'filled');
% axis equal; grid on;
% xlabel('In-phase'); ylabel('Quadrature');
% title('Modulated Symbols for PBCH (QPSK)');


% 5. Resource Element Mapping
ncellid = 42; % Physical Cell ID
grid = ssb_grid();
ans = mapped_ssb(grid, symb, ncellid);

% 6. Visualize resource mapping
visualize_ssb_grid(ans, ncellid);
