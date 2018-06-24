clear all;
close all;
clc;
VideoReader('a.avi')                                %显示视频的信息,视频使用aviread读取之前通过winavi9.0将格式转换为ZJmedia uncompress RGB24
avi=VideoReader('a.avi'); %使用aviread读取视频，注意视频的格式，aviread读取的视频有格式限制
VidFrames=read(avi,[1,98]);

N=2;                                             %考虑6帧的帧间差分法（需要读取前7帧）
start=1;                                        %start=100，从第100+1帧开始连续读7帧
threshold=50;
for k=1+start:98                       %处理从第101到第107帧                   
       mov(k).cdata=rgb2gray(VidFrames(:,:,:,k));      %将彩色图像转换为灰度图像
       % avi(k-start).cdata=avi(k).cdata;
end
  [hang,lie]=size(mov(1+start).cdata);            %以avi（1+start）.cdata的格式生成一个矩阵
  
  alldiff=zeros(hang,lie,N);                       %生成一个三维的矩阵alldiff用于存储最终的各个帧的差分结果        
  
for k=1+start:N+start
  diff=abs(mov(k).cdata-mov(k+1).cdata);           %邻帧差分

           %idiff=diff>20;                          %二值化，阈值选择为20，阈值调整
           idiff=diff>threshold;                           %idiff中的数据位逻辑值，diff中的数值为unit8
           alldiff(:,:,k)=double(idiff);           %存储各帧的差分结果，这里为什么要转换成double型的？？？？？
end

%观察帧间差分的二值化结果，这里观察前五帧的相邻两帧差分二值化结果
for k=1+start:N+start
subplot(3,2,k-start),imshow(alldiff(:,:,k)),%title('第1,2帧差分')
title(strcat(num2str(k),'帧','-',num2str(k+1),'帧'));
end