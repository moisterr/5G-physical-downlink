function ind = generatePBCHIndices(ncellid)
% nrPBCHIndices Generate PBCH RE indices (linear, 1-based)
% Input: ncellid - physical cell ID (0...1007)
% Output: ind - linear indices of PBCH REs in SS/PBCH block (240x4)

    validateattributes(ncellid, {'numeric'}, ...
        {'scalar','integer','>=',0,'<=',1007}, 'nrPBCHIndices', 'NCELLID');

    K = 240;  % subcarriers per OFDM symbol in SS/PBCH block

    % Base indices for DMRS shift = 0 (v = 0)
    dmrsInd0 = [ ...
        (1*K):4:(1*K + 236), ...         % symbol l=1
        (2*K):4:(2*K + 44),  ...         % symbol l=2 (low)
        (2*K + 192):4:(2*K + 236), ...   % symbol l=2 (high)
        (3*K):4:(3*K + 236)              % symbol l=3
    ];

    % Select 3 PBCH REs from 4 REs per group based on v = mod(ncellid,4)
    notDmrs = [ 1 2 3; 0 2 3; 0 1 3; 0 1 2 ].';
    v = mod(ncellid, 4);

    % Calculate PBCH indices
    ind = dmrsInd0 + notDmrs(:, v+1);
    ind = uint32(ind(:) + 1);  % Convert to linear 1-based
end
