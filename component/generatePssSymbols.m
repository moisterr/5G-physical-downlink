function sym = generatePssSymbols(ncellid)
%nrPSS Primary synchronization signal
%   SYM = nrPSS(NCELLID) returns a real column vector SYM containing the
%   primary synchronization signal (PSS) symbols as defined in TS 38.211
%   Section 7.4.2.2, given physical layer cell identity NCELLID (0...1007).
%
%   Example:
%   ncellid = 17;
%   pss = nrPSS(ncellid);

    narginchk(1,1);

    % Validate physical layer cell identity (0...1007)
    validateattributes(ncellid,{'numeric'}, ...
        {'scalar','integer','>=',0,'<=',1007},'nrPSS','NCELLID');

    % Predefined PSS sequence (length 127, BPSK)
    d_PSS = [...
      1  -1  -1   1  -1  -1  -1  -1   1   1  -1  -1  -1   1   1  -1   1 ...
     -1   1  -1  -1   1   1  -1  -1   1   1   1   1   1  -1  -1   1  -1 ...
     -1   1  -1   1  -1  -1  -1   1  -1   1   1   1  -1  -1   1   1  -1 ...
      1   1   1  -1   1   1   1   1   1   1  -1   1   1  -1   1   1  -1 ...
     -1   1  -1   1   1  -1  -1  -1  -1   1  -1  -1  -1   1   1   1   1 ...
     -1  -1  -1  -1  -1  -1  -1   1   1   1  -1  -1  -1   1  -1  -1   1 ...
      1   1  -1   1  -1   1   1  -1   1  -1  -1  -1  -1  -1   1  -1   1 ...
     -1   1  -1   1   1   1   1  -1].';

    % Index shift based on cell ID mod 3
    n2 = mod(ncellid,3);

    % PSS sequence mapping (length 127)
    seq = d_PSS(1 + mod(43*n2 + (0:126),127));

    % Always return double precision
    sym = double(seq);
end
