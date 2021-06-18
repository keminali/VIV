% two point correlation, 


%read .dat file
 % N-- no. of time steps
 % i-- no. of iteration
 % c -- vorticity
 % j -- number of file name
 % m -- matrix, row direction is spanwise distance, column direction is time steps
 % l -- length in the spanwise direction, i.e. z direction in the cfd 
 % xc -- cross correlation
clear;clc;
N=38;  % no. of saved case and dat files
j=9000;
m=zeros(120,N); % 120*4 matrix 
for i=1:N   
    j=j+25;
    filename = sprintf('gap_1-1-%d.dat',j);
    fid=fopen(filename,'rt');
    c=textscan(fid,'%f','HeaderLines',15,'delimiter',' ');  % ignore the first 15 rows, and 'space' as delimiter
    c=cell2mat(c);   % cell array into a single matrix.
    fclose(fid);
    c=c(2:2:end,:); % extract even rows of a vector
    m(:,i)=c;
end
m=m';
csvwrite('vorticity_x.csv',m);  
m1=m(:,1); % 1st column of matrix 'm'
m50=m(:,50);  %z= 2.5D
m60=m(:,60);  % z=3D
% plot time histories of x vorticity at the first point
t= linspace(0,4.75,38);  % time length = 4.75s=38*25*0.005
t=t';
T=1/1.1248; % mean period at g/d=1 ur5
t_nor=t/T;
figure(1)
plot(t_nor,m50,t_nor,m60,'-o','LineWidth',2);
legend('2.5D','3D');
xlabel ('\it normalized time (T)','fontsize',20,'fontname','Times New Roman');
ylabel ('\it  vorticity X','fontsize' ,20,'fontname','Times New Roman');
saveas(gcf, 'x_vorticity_his','png')
% cross-correlation of m50 and m60
[xc,lags] = xcorr(m50,m60,'coeff');  %  'coeff'    - normalizes the sequence so that the auto-correlations at zero lag are identically 1.0.
figure(2)
stem(lags(39:end),xc(39:end),'filled')  % there are 38 time steps, thus, 0 lag is 38+1=39
saveas(gcf, 'cross_correlation_vs_lags','png')
% two point correlation of x vorticity along spanwise 
% % math expression, refer to ch10, Lars Davidson, fluid mechanics, turbulent flow and turbulence modeling
for k=1:120
    cor(k)=dot(m1,m(:,k))/N; % two point correlation
end
autocor=dot(m1,m1)/N;
cor=cor';
cor_nor=cor/autocor;  % normalized
l=linspace(0,0.6,120);  % spanwise length
l=l';
l=l/0.1;  % normalization, D=0.1m
figure(3)
plot(l,cor_nor);

xlabel ('\it z(D)','fontsize',20,'fontname','Times New Roman');
ylabel ('\it R','fontsize' ,20,'fontname','Times New Roman');
saveas(gcf, 'two_point_correlation','epsc') % current window, file-name, format
saveas(gcf, 'two_point_correlation','png')
saveas(gcf, 'two_point_correlation','svg')

%%%%%%%%%%%%%%%% begin of  validation %%%%%%%%%%%%%%%%%%%%%%%%%
% % input signal sine waves
% clear;clc;
% x = linspace(0,2*pi,100);
% y=sin(x);
for i=1:N
% y1=sin(x+pi);
% plot(x,y, x, y1)
% autocor=dot(y,y)/100; % autocorrelation
% corr=dot(y,y1)/(autocor*100);
%%%%%%%%%%%%%%%% end of validation %%%%%%%%%%%%%%%%%%%%%%%%%

