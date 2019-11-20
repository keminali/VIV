function fd = fftAnalysis(u,fs)
% goal:find the frequency
L=length(u);
Y = fft(u);
P2 = abs(Y/L); P1 = P2(1:L/2+1); P1(2:end-1) = 2*P1(2:end-1); f = fs*(0:(L/2))/L;
fp =[f', P1];
fd = sortrows(fp,2,'descend');
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
