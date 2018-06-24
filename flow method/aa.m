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
 
%get image size and adjust for border  ��ȡͼ��Ա߽���е���
[h,w]=size(fr_f1);  
hm5=h-5; wm5=w-5;
z=zeros(h,w); v1=z; v2=z;

%initialize        ��ʼ��
dsx2=v1; dsx1=v1; dst=v1;
alpha2=625;
imax=20;

%Calculate gradients  �����ݶ�
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

%������������˶�����Ļ���ԭ���ǣ���ͼ���е�ÿһ�����ص㸳��һ���ٶ�ʸ��������γ���һ��ͼ���˶�����
%  ���˶���һ���ض�ʱ�̣�ͼ���ϵĵ�����ά�����ϵĵ�һһ��Ӧ�����ֶ�Ӧ��ϵ����ͶӰ��ϵ�õ������ݸ������ص���ٶ�ʸ��������
%  ���Զ�ͼ����ж�̬���������ͼ����û���˶����壬�����ʸ��������ͼ�������������仯�ġ�
%  ��ͼ�������˶�����ʱ��Ŀ���ͼ�񱳾���������˶����˶��������γɵ��ٶ�ʸ����Ȼ�����򱳾��ٶ�ʸ����ͬ���Ӷ������˶����弰λ�á�
%  ���ù����������˶��������������Ҫ���ڴ���������������ʱ��ʵʱ�Ժ�ʵ���Զ��ϲ
%  ���ǹ��������ŵ����ڹ�������Я�����˶�������˶���Ϣ�����һ�Я�����йؾ�����ά�ṹ�ķḻ��Ϣ�����ܹ��ڲ�֪���������κ���Ϣ������£������˶����� 
