clear all;
clc;
avi=VideoReader('a.avi');                           %ʹ��MMREADER����������Ƶ��������aviread����
VidFrames=read(avi,[1,98]);
N=4;                                             %����N֡��֡���ַ�
start=10;                                        %��ʼ֡
threshold=3;
for k=1+start:N+1+start                                              
    mov(k).cdata=rgb2gray(VidFrames(:,:,:,k));      %����ɫͼ��ת��Ϊ�Ҷ�ͼ��;
end
  [row,col]=size(mov(1+start).cdata);            %��mov(1+start).cdata�ĸ�ʽ����һ������

  alldiff=zeros(row,col,N);                       %����һ����ά�ľ���alldiff���ڴ洢���յĸ���֡�Ĳ�ֽ��        

for k=1+start:N+start
  diff=abs(mov(k).cdata-mov(k+1).cdata);           %��֡���
  idiff=diff<threshold;                           %��ֵ����idiff�е�����λ�߼�ֵ��diff�е���ֵΪunit8
  alldiff(:,:,k)=double(idiff);           
end

%�۲���
i=1;
for k=1+start:N+start
    figure(i);
    imshow(alldiff(:,:,k))
    title(strcat(num2str(k),'֡','-',num2str(k+1),'֡'));
    i=i+1;
end