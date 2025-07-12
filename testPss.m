addpath component\

ssblock = zeros([240 4]);
ncellid = 17;
pssSymbols = generatePssSymbols(ncellid);
pssIndices = generatePssIndices([240, 4]);
ssblock(pssIndices) = 1 * pssSymbols;
imagesc(abs(ssblock));
clim([0 4]);
axis xy;
xlabel('OFDM symbol');
ylabel('Subcarrier');
title('SS/PBCH block containing PSS');
