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


 ssblock = zeros([240 4]);

ncellid = 17;

pssSymbols = generatePssSymbols(ncellid);
pssIndices = generatePssIndices;
ssblock(pssIndices) = 1 * pssSymbols;

figure;
subplot(2, 2, 1);
imagesc(abs(ssblock));
clim([0 4]);
axis xy;
xlabel('OFDM symbol'); ylabel('Subcarrier');
title('PSS mapped');

sssSymbols = generateSssSymbols(ncellid);
sssIndices = generateSssIndices;
ssblock(sssIndices) = 2 * sssSymbols;

subplot(2, 2, 2);
imagesc(abs(ssblock));
clim([0 4]);
axis xy;
xlabel('OFDM symbol'); ylabel('Subcarrier');
title('PSS + SSS mapped');

pbchIndices = generatePBCHIndices(ncellid);
ssblock(pbchIndices) = 3 * symb;

subplot(2, 2, 3);
imagesc(abs(ssblock));
clim([0 4]);
axis xy;
xlabel('OFDM symbol'); ylabel('Subcarrier');
title('PSS + SSS + PBCH mapped');

ibar_SSB = 0;
dmrsSymbols = generatePBCHDMRS(ncellid, ibar_SSB);
dmrsIndices = generatePBCHDMRSIndices(ncellid);
ssblock(dmrsIndices) = 4 * dmrsSymbols;

subplot(2, 2, 4);
imagesc(abs(ssblock));
clim([0 4]);
axis xy;
xlabel('OFDM symbol'); ylabel('Subcarrier');
title('Full SS/PBCH Block');    

sgtitle('SS/PBCH Block Mapping Progression');





