%calculateCanny���Ľ��㷨���е������Ե�����㣩
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

 th=75/255;
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
%����ͼ������
[width3,length3]=size(a);
wifthU=width3;
wifthD=1;
lengthL=length3;
lengthR=1;
for i=1:width3
    for j=1:length3
        if a(i,j)~=0
            if i<wifthU
               wifthU=i; 
            end
             if i>wifthD
               wifthD=i;
             end
             if j<lengthL
               lengthL=j; 
             end
             if j>lengthR
               lengthR=j; 
            end
        end
    end
end
%ͼ���и�
lenR = 8-mod(lengthR-lengthL,8)+lengthR-lengthL;
lenW =  8-mod(wifthD-wifthU,8)+wifthD-wifthU;
pic1 = imcrop(file1,[lengthL,wifthU,lenR-1,lenW-1]);
pic2 = imcrop(file2,[lengthL,wifthU,lenR-1,lenW-1]);
BW1 = edge(pic1,'canny');  % ����canny����,�񻯣�  

pic1 = im2double (pic1);    
pic2 = im2double (pic2); 
BW1 = im2double (BW1);   
imshow(BW1)
toc