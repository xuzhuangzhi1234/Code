clear all;
clc;
avi=VideoReader('a.avi');                           %使用MMREADER方法读入视频流，抛弃aviread方法
VidFrames=read(avi,[1,98]);
N=4;                                             %考虑N帧的帧间差分法
start=10;                                        %起始帧
threshold=3;
for k=1+start:N+1+start                                              
    mov(k).cdata=rgb2gray(VidFrames(:,:,:,k));      %将彩色图像转换为灰度图像;
end
  [row,col]=size(mov(1+start).cdata);            %以mov(1+start).cdata的格式生成一个矩阵

  alldiff=zeros(row,col,N);                       %生成一个三维的矩阵alldiff用于存储最终的各个帧的差分结果        

for k=1+start:N+start
  diff=abs(mov(k).cdata-mov(k+1).cdata);           %邻帧差分
  idiff=diff<threshold;                           %二值化，idiff中的数据位逻辑值，diff中的数值为unit8
  alldiff(:,:,k)=double(idiff);           
end

%观察结果
i=1;
for k=1+start:N+start
    figure(i);
    imshow(alldiff(:,:,k))
    title(strcat(num2str(k),'帧','-',num2str(k+1),'帧'));
    i=i+1;
end