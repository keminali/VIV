% goal: 
%%time history 0f lift, drag, and displacement
%% find the frequency via FFT
%% r.m.s of lift and drag

clear;
clc;
%% read xls data
data=xlsread('gap1Ur8.xlsx');
A1=data(1000:10000,1);    % time, assign 1st column data to A1, rows(1e3, 1e4)
A2=data(1000:10000,2);    % displacement
A3=data(1000:10000,3);    % lift coeff
A4=data(1000:10000,4);    % drag coeff
figure(1);
U=1.1686;
%% %%%%%%%%%%%%%
% Figure 1
%%%%%%%%%%%%%%%%
fig_hei=0.28;  
fig_wei=0.9;
lef_cor_x=0.08;
lef_cor_y=0.1;
%% plot data
%cd, drag coeffcient
subplot(3,1,1,'position', [lef_cor_x lef_cor_y+fig_hei+fig_hei fig_wei fig_hei])  % 3 rows, 1 column, 1st subfigure,
plot(A1*U/0.1,A4,'k-'); 
ylabel('\itC_{D}','fontsize',20,'fontname','Times New Roman');
set(gca,'fontsize',20,'fontname','Times New Roman')
axis([20,400,-inf,inf])
set(gca,'xticklabel',[])
box off
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on
%cl
subplot(3,1,2,'position', [lef_cor_x lef_cor_y+fig_hei fig_wei fig_hei])   % 2nd subfigure
plot(A1*U/0.1,A3,'k --');
ylabel('\itC_{l}','fontsize',20,'fontname','Times New Roman');
set(gca,'fontsize',20,'fontname','Times New Roman')
axis([20,400,-inf,inf])
set(gca,'xticklabel',[])
box off
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on
%A/D -- normalized displacement
subplot(3,1,3,'position', [lef_cor_x lef_cor_y fig_wei fig_hei])   % 3rd subfigure
plot(A1*U/0.1,A2/0.1,'k -.');
ylabel('\itA/D','fontsize',20,'fontname','Times New Roman');
xlabel('\ittU/D','fontsize',20,'fontname','Times New Roman');
set(gca,'fontsize',20,'fontname','Times New Roman')
axis([20,400,-inf,inf])
box off
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data_FFT=[A2,A3,A4];
S=[Data_FFT(:,1)-mean(Data_FFT(:,1)),Data_FFT(:,2)-mean(Data_FFT(:,2)),Data_FFT(:,3)-mean(Data_FFT(:,3))];
Fs=200;%
N=9000;%
t=[0:1/Fs:N/Fs];
Y=fft(S,N);
Ayy=(abs(Y));
%Ayy=Ayy/(N/2);
Ayy_1=Ayy(:,1);
Ayy_2=Ayy(:,2);
Ayy_3=Ayy(:,3);
F=([1:N]-1)*Fs/N;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2nd figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
%cd
subplot(3,1,1,'position', [lef_cor_x lef_cor_y+fig_hei+fig_hei fig_wei fig_hei])
plot(F(1:N/2),Ayy_3(1:N/2),'b-','linewidth',2);
ylabel('\itAmplitude','fontsize',20,'fontname','Times New Roman');
set(gca,'fontsize',20,'fontname','Times New Roman')
axis([0,10,0,inf])
set(gca,'xticklabel',[])
box off
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on
%cl -- subplot
subplot(3,1,2,'position', [lef_cor_x lef_cor_y+fig_hei fig_wei fig_hei])
plot(F(1:N/2),Ayy_2(1:N/2),'b-','linewidth',2);
ylabel('\itAmplitude','fontsize',20,'fontname','Times New Roman');
set(gca,'fontsize',20,'fontname','Times New Roman')
axis([0,10,0,3e3])
set(gca,'xticklabel',[])
box off
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on
%displacement -- subplot
subplot(3,1,3,'position', [lef_cor_x lef_cor_y fig_wei fig_hei])
plot(F(1:N/2),Ayy_1(1:N/2),'b-','linewidth',2);
xlabel('\itf','fontsize',20,'fontname','Times New Roman');
ylabel('\itAmplitude','fontsize',20,'fontname','Times New Roman');
set(gca,'fontsize',20,'fontname','Times New Roman')
axis([0,10,0,200])
box off
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on
%% mean_Cd
mean_Cd=mean(A4)
%% rms_Cd
rms_Cd=rms(A4)
%% rms_cl
rms_Cl=rms(A3)
%% displacement
A2_mean=A2(A2>0.06);
s=sum(A2_mean);
l=length(find(A2>0.06));
dis_ave=s/l;
%% RMS displacement
Rms=rms(A2);
dis=Rms*(2)^0.5
% max displacement
max_dis=max (A2) 
K=F';
C=data(:,1)*U/0.1;
