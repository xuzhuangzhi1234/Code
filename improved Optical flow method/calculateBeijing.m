%calculateBeijing(֡���ַ�)
function calculate(file1,file2)
tic
% file1 = imread(file1);
% file2 = imread(file2);
%�Ҷ�ͼ
file1 = rgb2gray(imread(file1));
file2 = rgb2gray(imread(file2));
[M,N] = size(file1);
pic1 = file1;
pic2 = file2;
file1=medfilt2(file1,[3 3]);%������ֵ�˲�
file2=medfilt2(file2,[3 3]);
file1=im2double(file1);
file2=im2double(file2);
file3=file1-file2;
a=medfilt2(file3,[3,3]);

 th=55/255;
 %��ֵͼ��
k= abs(file3)>=th;
a(k)=1;
k= abs(file3)<th;
a(k)=0;
 a=bwareaopen(a,15);%ɾ��С���ͼ��

se90=strel ('line',3,90);se0=strel ('line',3,0);%������̬ѧ�ṹԪ��
a=bwmorph(a,'close'); %������ͼ�������̬ѧ������  �����ͺ�ʴ ��ȡ������ͼ��
a=imdilate(a,[se90,se0]);%���ͣ�����ն�����
a=bwmorph(a,'close');
a=bwareaopen(a,50);
  imshow(a)
  toc
