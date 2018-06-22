%calculateBeijing(帧间差分法)
function calculate(file1,file2)
tic
% file1 = imread(file1);
% file2 = imread(file2);
%灰度图
file1 = rgb2gray(imread(file1));
file2 = rgb2gray(imread(file2));
[M,N] = size(file1);
pic1 = file1;
pic2 = file2;
file1=medfilt2(file1,[3 3]);%进行中值滤波
file2=medfilt2(file2,[3 3]);
file1=im2double(file1);
file2=im2double(file2);
file3=file1-file2;
a=medfilt2(file3,[3,3]);

 th=55/255;
 %二值图像
k= abs(file3)>=th;
a(k)=1;
k= abs(file3)<th;
a(k)=0;
 a=bwareaopen(a,15);%删除小面积图形

se90=strel ('line',3,90);se0=strel ('line',3,0);%创建形态学结构元素
a=bwmorph(a,'close'); %对上述图像进行形态学闭运算  先膨胀后腐蚀 提取二进制图像
a=imdilate(a,[se90,se0]);%膨胀，解决空洞问题
a=bwmorph(a,'close');
a=bwareaopen(a,50);
  imshow(a)
  toc
