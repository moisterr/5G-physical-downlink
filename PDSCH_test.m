addpath PDSCH\  
  
% Định nghĩa các tham số cần thiết  
A = 3842;           % Transport block size  
BG = 1;             % Base graph (1 hoặc 2)  
Q_m = 2;            % QPSK = 2 bits/symbol  
G = 132;            % Output length  
a = round(rand(A,1)); % Dữ liệu ngẫu nhiên  
  
% 1. Tạo encoder và modulator    
enc = NRLDPCEncoder('A', A, 'BG', BG, 'G', G, 'Q_m', Q_m);    
mod = NRModulator('Modulation', 'QPSK');    
  
% Hiển thị thông tin đầu vào  
fprintf('=== THÔNG TIN ĐẦU VÀO ===\n');  
fprintf('Transport block size (A): %d bits\n', A);  
fprintf('Base graph (BG): %d\n', BG);  
fprintf('Output length (G): %d bits\n', G);  
fprintf('Modulation: QPSK (Q_m = %d bits/symbol)\n', Q_m);  
fprintf('Dữ liệu đầu vào: %d bits\n', length(a));  
fprintf('Mẫu dữ liệu đầu vào (10 bit đầu): %s\n', mat2str(a(1:min(10,end))'));  
  
g = step(enc, a);  % a là dữ liệu đầu vào    
fprintf('Sau mã hóa LDPC: %d bits\n', length(g));  
fprintf('Mẫu dữ liệu sau mã hóa (10 bit đầu): %s\n', mat2str(g(1:min(10,end))'));  
  
% 3. Điều chế    
fprintf('\n=== QUÁ TRÌNH ĐIỀU CHẾ ===\n');  
tx = step(mod, g);  % tx là tín hiệu PDSCH đã điều chế  
fprintf('Sau điều chế: %d symbols phức\n', length(tx));  
fprintf('Tỷ lệ: %d bits -> %d symbols (%.1f bits/symbol)\n', length(g), length(tx), length(g)/length(tx));  
  
% Hiển thị một số symbol đầu tiên  
fprintf('Mẫu symbols điều chế (5 symbol đầu):\n');  
for i = 1:min(5, length(tx))  
    fprintf('  Symbol %d: %.4f + %.4fi\n', i, real(tx(i)), imag(tx(i)));  
end  
  
% Thống kê tín hiệu  
fprintf('\n=== THỐNG KÊ TÍN HIỆU ===\n');  
fprintf('Công suất trung bình: %.6f\n', mean(abs(tx).^2));  
fprintf('Biên độ tối đa: %.6f\n', max(abs(tx)));  
fprintf('Biên độ tối thiểu: %.6f\n', min(abs(tx)));  
  

