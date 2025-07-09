function mapped_ssb = map_pbch_to_re(ssb_grid, pbch_symbols, ncellid)
    % Input:
    %   ssb_grid: 
    %   pbch_symbols: 
    %   ncellid: Physical Cell ID (0-1007)
    % Output:
    %   mapped_ssb: 
    
    mapped_ssb = ssb_grid;
    symbol_idx = 1; 
    
    v = mod(ncellid, 4);
    k_prime = [0, 1, 2, 3]; 
    
    for l = 0:3 
        if l == 1 || l == 3 
            for k = 0:239 
                if mod(k - v, 4) == 0 
                    continue;
                end
                
                mapped_ssb(k+1, l+1) = pbch_symbols(symbol_idx);
                symbol_idx = symbol_idx + 1;
                
                if symbol_idx > length(pbch_symbols)
                    return;
                end
            end
        end
    end
end