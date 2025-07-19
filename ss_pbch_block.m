% File: test_ss_mapping.m
% Main script to map PSS, SSS, and PBCH onto the SS/PBCH block resource grid,
% using generated indices and matching the provided diagram (image_ba5601.png).
addpath('component'); % Đảm bảo thư mục 'component' có trong đường dẫn MATLAB

% --- Kích thước và định nghĩa giá trị cho các loại tài nguyên ---
num_subcarriers = 240; % Tổng số sóng mang phụ trong SS/PBCH block
num_ofdm_symbols = 4;  % Tổng số ký hiệu OFDM trong SS/PBCH block

% Định nghĩa các giá trị số cho từng loại tài nguyên để vẽ bản đồ màu
% (Các giá trị này sẽ được ánh xạ tới màu sắc qua colormap)
BACKGROUND_VALUE = 0; % Nền trắng/xám (các vùng trống)
PSS_VALUE = 1;        % PSS (màu vàng)
SSS_VALUE = 2;        % SSS (màu đỏ)
PBCH_VALUE = 3;       % PBCH (màu xanh lá cây)

% 1. Initialize the SS/PBCH block resource map matrix
ssblock_resource_map = BACKGROUND_VALUE * ones(num_subcarriers, num_ofdm_symbols);
fprintf('Initial SS/PBCH block resource map size: %dx%d\n', size(ssblock_resource_map, 1), size(ssblock_resource_map, 2));

% --- Ánh xạ các vùng tài nguyên sử dụng các hàm generateIndices và logic từ image_ba5601.png ---

% 2. Ánh xạ vùng PSS (sử dụng generatePssIndices)
% Lưu ý: generatePssIndices sẽ trả về các chỉ số tuyến tính hoặc chỉ số mảng 2D.
% Giả định generatePssIndices trả về chỉ số mảng 2D (rows, cols) hoặc chỉ số tuyến tính.
% Dựa trên original test_ss_mapping.m comment, PSS là OFDM symbol 1, subcarriers 57-183.
% Chúng ta sẽ sử dụng generatePssIndices để xác định vị trí này một cách chính xác.
pssIndices = generatePssIndices([num_subcarriers, num_ofdm_symbols]); % Lấy các chỉ số PSS
ssblock_resource_map(pssIndices) = PSS_VALUE;
fprintf('\nPSS region mapped using generatePssIndices.\n');

% 3. Ánh xạ vùng SSS (sử dụng generateSssIndices)
% Dựa trên original test_ss_mapping.m comment, SSS là OFDM symbol 2, subcarriers 57-183.
sssIndices = generateSssIndices([num_subcarriers, num_ofdm_symbols]); % Lấy các chỉ số SSS
ssblock_resource_map(sssIndices) = SSS_VALUE;
fprintf('SSS region mapped using generateSssIndices.\n');

% 4. Ánh xạ vùng PBCH theo sơ đồ (image_ba5601.png)
% PBCH ở ký hiệu OFDM thứ 2 (chỉ số 2 trong MATLAB), phần trên và dưới vùng SSS
% SSS_start_sub và SSS_end_sub phải được xác định dựa trên cách generateSssIndices hoạt động.
% Giả sử SSS_start_sub = 57 và SSS_end_sub = 183 như trong các hình ảnh trước.
sss_start_sub = 57;
sss_end_sub = 183;

% Phần PBCH bên dưới SSS (ký hiệu OFDM thứ 2)
ssblock_resource_map(1:sss_start_sub-1, 2) = PBCH_VALUE;
% Phần PBCH bên trên SSS (ký hiệu OFDM thứ 2)
ssblock_resource_map(sss_end_sub+1:num_subcarriers, 2) = PBCH_VALUE;

% PBCH ở ký hiệu OFDM thứ 3 và thứ 4 (chỉ số 3 và 4 trong MATLAB), chiếm toàn bộ 240 SC
ssblock_resource_map(1:num_subcarriers, 3) = PBCH_VALUE;
ssblock_resource_map(1:num_subcarriers, 4) = PBCH_VALUE;
fprintf('PBCH regions mapped based on image_ba5601.png.\n');

% --- Vẽ đồ thị ---
figure;
imagesc(ssblock_resource_map);

% Đảo ngược trục Y để sóng mang phụ tăng dần từ dưới lên trên như trong hình
set(gca, 'YDir', 'normal');

% Đặt các nhãn trục và tiêu đề
xlabel('OFDM symbol');
ylabel('Subcarrier');
title('SS/PBCH block'); % Tiêu đề từ image_ba5601.png
% Điều chỉnh các giá trị trên trục X để khớp với hình của bạn (bắt đầu từ 0.5)
xticks(1:num_ofdm_symbols);
xticklabels({'0.5', '1.5', '2.5', '3.5'}); % Hoặc '0', '1', '2', '3' tùy vào convention

% Đặt các giá trị trên trục Y
yticks(0:50:num_subcarriers);
ylim([0 num_subcarriers + 0.5]); % Đảm bảo hiển thị toàn bộ 240 sóng mang phụ

% Tạo colormap tùy chỉnh để khớp với các màu trong hình ảnh bạn đã cung cấp (image_ba5601.png)
% Các màu tương ứng với các giá trị:
% 0: BACKGROUND_VALUE (Trắng/Xám nhạt)
% 1: PSS_VALUE (Vàng)
% 2: SSS_VALUE (Đỏ)
% 3: PBCH_VALUE (Xanh lá cây)

custom_colors = [
    0.95, 0.95, 0.95; % 1. Gần trắng/xám nhạt cho nền (BACKGROUND_VALUE = 0)
    1.0,  1.0,  0.0;  % 2. Vàng cho PSS (PSS_VALUE = 1)
    1.0,  0.0,  0.0;  % 3. Đỏ cho SSS (SSS_VALUE = 2)
    0.0,  1.0,  0.0   % 4. Xanh lá cây cho PBCH (PBCH_VALUE = 3)
];
colormap(custom_colors);

% Điều chỉnh giới hạn trục để hình ảnh khớp với trục X và Y của bạn
xlim([0.5 num_ofdm_symbols + 0.5]);
grid on; % Thêm lưới