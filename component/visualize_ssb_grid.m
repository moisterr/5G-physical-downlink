function visualize_ssb_grid(ssb_grid, ncellid)
    figure('Position', [100, 100, 800, 600]);
    
    pbch_mask = ~isnan(ssb_grid);
    dmrs_mask = false(size(ssb_grid));
    v = mod(ncellid, 4);
    
    for l = 0:3
        for k = 0:239
            if mod(k - v, 4) == 0
                dmrs_mask(k+1, l+1) = true;
            end
        end
    end
    
    img = zeros([size(ssb_grid), 3]);
    
    pbch_intensity = abs(ssb_grid);
    pbch_intensity(isnan(pbch_intensity)) = 0;
    img(:, :, 3) = pbch_intensity/max(pbch_intensity(:)); % Blue channel
    
    img(:, :, 1) = dmrs_mask * 0.8; % Red channel
    
    pss_sss_mask = false(size(ssb_grid));
    pss_sss_mask(:, [1, 3]) = true;
    img(:, :, 2) = pss_sss_mask * 0.6; % Green channel
    
    image(1:4, 1:240, img);
    axis xy;
    xlabel('Symbol Index');
    ylabel('Subcarrier Index');
    title(sprintf('SS/PBCH Block Resource Mapping (NCellID = %d)', ncellid));
    
    hold on;
    plot(NaN, NaN, 'r', 'LineWidth', 2, 'DisplayName', 'DM-RS');
    plot(NaN, NaN, 'g', 'LineWidth', 2, 'DisplayName', 'PSS/SSS');
    plot(NaN, NaN, 'b', 'LineWidth', 2, 'DisplayName', 'PBCH');
    legend('Location', 'northeastoutside');
    
    grid on;
    set(gca, 'GridAlpha', 0.3, 'XTick', 1:4, 'YTick', 0:20:240);
end