function ind = generatePBCHDMRSIndices(ncellid)
%nrPBCHDMRSIndices PBCH DM-RS RE indices (simplified version)
%   IND = nrPBCHDMRSIndices(NCELLID) returns 1-based linear indices for the
%   PBCH DM-RS within a 240-by-4 SS/PBCH grid. NCELLID is 0...1007.

    % Kiểm tra đầu vào
    if ~isscalar(ncellid) || ncellid < 0 || ncellid > 1007 || floor(ncellid) ~= ncellid
        error('NCELLID must be an integer in the range 0 to 1007.');
    end

    K = 240;
    v = mod(ncellid,4);

    ind = v + [ ...
        (1*K):4:(1*K + 236), ...
        (2*K):4:(2*K + 44), ...
        (2*K + 192):4:(2*K + 236), ...
        (3*K):4:(3*K + 236) ...
    ].';

    % MATLAB index (1-based)
    ind = uint32(ind + 1);
end
