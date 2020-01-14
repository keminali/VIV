clc
clear
step=60;
for i=1:step
    h=figure(1); % exit
    
    set(0,'defaultfigurecolor','w')
    f_name=strcat('AnimationFrame',num2str(i,'%.6d'),'.jpg')
    aa=imread([f_name]);
%   cc=imcrop(aa,[20 20 2000 800]);   %crop image
    imshow(aa)
%     imshow([f_name]);
%   imshow([num2str(i),'.jpg']);
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File?
    if i==1
        imwrite(imind,cm,['Frame','.gif'],'gif', 'Loopcount',inf,'DelayTime',0.1);
    elseif i==step
        imwrite(imind,cm,['Frame','.gif'],'gif','WriteMode','append','DelayTime',0.1);
    else
        imwrite(imind,cm,['Frame','.gif'],'gif','WriteMode','append','DelayTime',0.1);
    end
end
