%% output: added mass damping ratios 
clear;clc;
Dia=0.1; 
Len=6*Dia; 
mass =0.0138; 
rho=1.225; 
deltaT = 0.005; 
fs = 200; IBEGIN=2000; IEND = 7000; ksi = 0.0054;fn=1.4607;
%% Data Loading 
Files = dir(fullfile('D:\vivc\files for added\ur3.5\gap_ratio0.5\\','*.txt'));
data = load(Files.name);
time = data(:,1);  % time, extract 1st column 
dis = data(:,2);   % displacement
force = data(:,3);   % force
vel = data(:,4);  % velocity
f = fftAnalysis(force,fs);
force_filter =fft_filter(force,0,5,0.005); 
%figure;plot(time,force, 'r-');hold on; plot(time, force_filter, 'b-'); %Needed to be Corrected
dis_fluc = dis - mean(dis); vel_fluc = vel - mean(vel); force_fluc = force_filter - mean(force_filter);
acc_fluc = diff(vel_fluc)/deltaT; acc_fluc(length(vel),1) = acc_fluc(length(vel)-1,1);
acc_filter =fft_filter(acc_fluc,0,5,0.005); acc_filter =acc_filter -mean(acc_filter);
%figure;plot(time,acc_fluc, 'r-');hold on; plot(time, acc_filter, 'b-'); %Needed to be Corrected
%figure; plot(time, force_fluc, 'r-');hold on; plot(time, acc_filter, 'b-'); %Needed to be Corrected
%figure; subplot(1,2,1);plot(time, force_fluc, 'r-');subplot(1,2,2); plot(time, acc_filter, 'b-'); %Needed to be Corrected
FA = -force_fluc.*acc_filter;
FV = -force_fluc.*vel_fluc; FV = -force_fluc.*vel_fluc; FV = fft_filter(FV,0,5,0.005); 
%% Abstract Data to calculate the add-mass force and add-damping force
FAC = FA(IBEGIN:IEND);FVC = FV(IBEGIN:IEND); TIMEC = time(IBEGIN:IEND); DISC = dis_fluc(IBEGIN:IEND);
peaksFAC=findpeaks(FAC);peaksFVC=findpeaks(FVC);
IndMin=find(diff(sign(diff(FAC)))>0)+1;  IndMinFVC = find(diff(sign(diff(FVC)))>0)+1;   
IndMax=find(diff(sign(diff(FAC)))<0)+1;  IndMaxFVC = find(diff(sign(diff(FVC)))<0)+1; 
%figure;plot(FAC(1:end)); hold on; plot(IndMin,FAC(IndMin),'r^'); hold on; plot(IndMax,FAC(IndMax),'k*'); 
%figure;plot(FVC(1:end)); hold on; plot(IndMinFVC,FVC(IndMinFVC),'r^'); hold on; plot(IndMaxFVC,FVC(IndMaxFVC),'k*'); 

for i =1:length(IndMax)-1;
    aveFAC(i,1) = mean(FAC(IndMax(i):IndMax(i+1)));
    TIMEAC(i,1) = mean(TIMEC(IndMax(i):IndMax(i+1)));
    Amp = max(abs(DISC(IndMax(i):IndMax(i+1))));
    MA(i,1) = 2.*aveFAC(i,1)/(2.*pi*f(1,1))^4/Amp/Amp;
end
for i =1:length(IndMaxFVC)-1;
    aveFVC(i,1) = mean(FVC(IndMaxFVC(i):IndMaxFVC(i+1)));
    TIMEVC(i,1) = mean(TIMEC(IndMaxFVC(i):IndMaxFVC(i+1))); 
    Amp = max(abs(DISC(IndMaxFVC(i):IndMaxFVC(i+1)))); 
    CA(i,1) = 2.*aveFAC(i,1)/(2.*pi*f(1,1))^2/Amp/Amp;
end
MA_star = MA./(rho*Dia^2/4*Len);        % added mass ratio
CA_star = CA./(4.*pi*fn*mass*ksi);      % added damping ratio
figure;subplot(1,2,1);plot(TIMEAC,MA_star,'ro-');subplot(1,2,2);plot(TIMEVC,CA_star,'bs-');



