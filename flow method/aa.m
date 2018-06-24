%f1 and f2 are  two consecutive frames of a video sequence
clc;
clear;
close all



f1=imread('CT0010.jpg');
f40=imread('CT0011.jpg');

figure;
imshow(f1)
figure
imshow(f40)


fr_f1=rgb2gray(f1);
fr_f40=rgb2gray(f40);     
Xn=double(fr_f1);
Xnp1=double(fr_f40);
 
%get image size and adjust for border  获取图像对边界进行调整
[h,w]=size(fr_f1);  
hm5=h-5; wm5=w-5;
z=zeros(h,w); v1=z; v2=z;

%initialize        初始化
dsx2=v1; dsx1=v1; dst=v1;
alpha2=625;
imax=20;

%Calculate gradients  计算梯度
dst(5:hm5,5:wm5) = ( Xnp1(6:hm5+1,6:wm5+1)-Xn(6:hm5+1,6:wm5+1) + Xnp1(6:hm5+1,5:wm5)-Xn(6:hm5+1,5:wm5)+ Xnp1(5:hm5,6:wm5+1)-Xn(5:hm5,6:wm5+1) +Xnp1(5:hm5,5:wm5)-Xn(5:hm5,5:wm5))/4;
dsx2(5:hm5,5:wm5) = ( Xnp1(6:hm5+1,6:wm5+1)-Xnp1(5:hm5,6:wm5+1) + Xnp1(6:hm5+1,5:wm5)-Xnp1(5:hm5,5:wm5)+ Xn(6:hm5+1,6:wm5+1)-Xn(5:hm5,6:wm5+1) +Xn(6:hm5+1,5:wm5)-Xn(5:hm5,5:wm5))/4;
dsx1(5:hm5,5:wm5) = ( Xnp1(6:hm5+1,6:wm5+1)-Xnp1(6:hm5+1,5:wm5) + Xnp1(5:hm5,6:wm5+1)-Xnp1(5:hm5,5:wm5)+ Xn(6:hm5+1,6:wm5+1)-Xn(6:hm5+1,5:wm5) +Xn(5:hm5,6:wm5+1)-Xn(5:hm5,5:wm5))/4;


for i=1:imax
   delta=(dsx1.*v1+dsx2.*v2+dst)./(alpha2+dsx1.^2+dsx2.^2);
   v1=v1-dsx1.*delta;
   v2=v2-dsx2.*delta;
end;
u=z; u(5:hm5,5:wm5)=v1(5:hm5,5:wm5);
v=z; v(5:hm5,5:wm5)=v2(5:hm5,5:wm5);

xskip=round(h/32);
[hs,ws]=size(u(1:xskip:h,1:xskip:w))
us=zeros(hs,ws); vs=us;

N=xskip^2;
for i=1:hs-1
  for j=1:ws-1
     hk=i*xskip-xskip+1;
     hl=i*xskip;
     wk=j*xskip-xskip+1;
     wl=j*xskip;
     us(i,j)=sum(sum(u(hk:hl,wk:wl)))/N;
     vs(i,j)=sum(sum(v(hk:hl,wk:wl)))/N;
   end;
end;

figure(3);
quiver(us,vs);

axis ij;
axis tight;
axis equal;

%　光流法检测运动物体的基本原理是：给图像中的每一个像素点赋予一个速度矢量，这就形成了一个图像运动场，
%  在运动的一个特定时刻，图像上的点与三维物体上的点一一对应，这种对应关系可由投影关系得到，根据各个像素点的速度矢量特征，
%  可以对图像进行动态分析。如果图像中没有运动物体，则光流矢量在整个图像区域是连续变化的。
%  当图像中有运动物体时，目标和图像背景存在相对运动，运动物体所形成的速度矢量必然和邻域背景速度矢量不同，从而检测出运动物体及位置。
%  采用光流法进行运动物体检测的问题主要在于大多数光流法计算耗时，实时性和实用性都较差。
%  但是光流法的优点在于光流不仅携带了运动物体的运动信息，而且还携带了有关景物三维结构的丰富信息，它能够在不知道场景的任何信息的情况下，检测出运动对象。 
