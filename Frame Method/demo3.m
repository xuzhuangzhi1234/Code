clear all;
close all;
clc;
VideoReader('a.avi')                                %��ʾ��Ƶ����Ϣ,��Ƶʹ��aviread��ȡ֮ǰͨ��winavi9.0����ʽת��ΪZJmedia uncompress RGB24
avi=VideoReader('a.avi'); %ʹ��aviread��ȡ��Ƶ��ע����Ƶ�ĸ�ʽ��aviread��ȡ����Ƶ�и�ʽ����
VidFrames=read(avi,[1,98]);

N=2;                                             %����6֡��֡���ַ�����Ҫ��ȡǰ7֡��
start=1;                                        %start=100���ӵ�100+1֡��ʼ������7֡
threshold=50;
for k=1+start:98                       %����ӵ�101����107֡                   
       mov(k).cdata=rgb2gray(VidFrames(:,:,:,k));      %����ɫͼ��ת��Ϊ�Ҷ�ͼ��
       % avi(k-start).cdata=avi(k).cdata;
end
  [hang,lie]=size(mov(1+start).cdata);            %��avi��1+start��.cdata�ĸ�ʽ����һ������
  
  alldiff=zeros(hang,lie,N);                       %����һ����ά�ľ���alldiff���ڴ洢���յĸ���֡�Ĳ�ֽ��        
  
for k=1+start:N+start
  diff=abs(mov(k).cdata-mov(k+1).cdata);           %��֡���

           %idiff=diff>20;                          %��ֵ������ֵѡ��Ϊ20����ֵ����
           idiff=diff>threshold;                           %idiff�е�����λ�߼�ֵ��diff�е���ֵΪunit8
           alldiff(:,:,k)=double(idiff);           %�洢��֡�Ĳ�ֽ��������ΪʲôҪת����double�͵ģ���������
end

%�۲�֡���ֵĶ�ֵ�����������۲�ǰ��֡��������֡��ֶ�ֵ�����
for k=1+start:N+start
subplot(3,2,k-start),imshow(alldiff(:,:,k)),%title('��1,2֡���')
title(strcat(num2str(k),'֡','-',num2str(k+1),'֡'));
end