function grid = PBCH_resource_mapping(symbols, NcellID, L_max)
    % Tạo grid SS/PBCH block (240 subcarriers × 4 symbols)
    grid = complex(zeros(240, 4)); 
    
    % Xác định vị trí các tín hiệu khác
    v = mod(NcellID, 4); % Offset DM-RS dựa trên Cell ID
    
    % Tính số vị trí PBCH cần thiết (432)
    pbch_positions = [];
    
    % Duyệt qua tất cả resource elements
    for symbol_idx = 1:4
        for subcarrier_idx = 1:240
            % Bỏ qua các vị trí dành cho PSS
            if symbol_idx == 2 && subcarrier_idx >= 57 && subcarrier_idx <= 183
                continue;
            end
            
            % Bỏ qua các vị trí dành cho SSS
            if symbol_idx == 4 && subcarrier_idx >= 57 && subcarrier_idx <= 183
                continue;
            end
            
            % Bỏ qua các vị trí dành cho DM-RS
            if (symbol_idx == 1 || symbol_idx == 3) && mod(subcarrier_idx-1, 4) == v
                continue;
            end
            
            % Vị trí hợp lệ cho PBCH
            pbch_positions = [pbch_positions; subcarrier_idx, symbol_idx];
        end
    end
    
    % Kiểm tra số lượng vị trí
    if length(pbch_positions) < 864
        error('Không đủ vị trí cho PBCH: %d < 864', length(pbch_positions));
    end
    
    % Chọn 432 vị trí đầu tiên (mỗi vị trí chứa 1 symbol)
    pbch_positions = pbch_positions(1:432, :);
    
    % Ánh xạ symbol PBCH vào grid
    for i = 1:432
        subcarrier = pbch_positions(i, 1);
        symbol = pbch_positions(i, 2);
        grid(subcarrier, symbol) = symbols(i);
    end
    
    % Thêm DM-RS (giả lập - sẽ thay bằng giá trị thực sau)
    for symbol_idx = [1, 3]
        for subcarrier_idx = (1+v):4:240
            grid(subcarrier_idx, symbol_idx) = 1 + 1i; % Giá trị giả lập
        end
    end
    
    % Thêm PSS/SSS (giả lập)
    grid(57:183, 2) = 0.5 + 0.5i; % PSS
    grid(57:183, 4) = 0.5 + 0.5i; % SSS
end