%vehiclevideodetection(车载视频检测改进算法)
function vehiclevideodetection(file1,file2)
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


 th=50/255;
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
%计算图像轮廓
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
%图像切割
lenR = 8-mod(lengthR-lengthL,8)+lengthR-lengthL;
lenW =  8-mod(wifthD-wifthU,8)+wifthD-wifthU;
pic1 = imcrop(file1,[lengthL,wifthU,lenR-1,lenW-1]);
pic2 = imcrop(file2,[lengthL,wifthU,lenR-1,lenW-1]);
BW1 = edge(pic1,'canny');  % 调用canny函数

pic1 = im2double (pic1);    
pic2 = im2double (pic2); 
BW1 = im2double (BW1);   

%LK
[Dx, Dy] = dopyramid(pic1,pic2,BW1);


[m,n]=size(Dx);
bx=zeros(2,m*n);
s=0;
for i=1:m
    for j=1:n
      if(abs(Dx(i,j))>0||abs(Dy(i,j))>0)
        s=s+1;
        bx(1,s)=Dx(i,j);
        bx(2,s)=Dy(i,j);
%       else
%            Dx(i,j)=0;
%            Dy(i,j)=0;
      end
    end
end
x=bx(:,1:s);


[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(x,0.7500);
numClust = length(clustMembsCell);

c=0;num=1;
   sx=0;
    sy=0;
% figure(10),clf,hold on
% cVec = 'bgrcmykbgrcmykbgrcmykbgrcmyk';%, cVec = [cVec cVec];
% for k = 1:min(numClust,length(cVec))
for k = 1:numClust
    myMembers = clustMembsCell{k};
        [~,ss]=size(myMembers);
    myClustCen = clustCent(:,k);

    if  ss>=c  
      oldC = c;
      oldSx = sx;
      oldSy = sy;
      sx=myClustCen(1);
      sy=myClustCen(2);
      c = ss;
    end
% plot(x(1,myMembers),x(2,myMembers),[cVec(k) '.'])
%     plot(myClustCen(1),myClustCen(2),'o','MarkerEdgeColor','k','MarkerFaceColor',cVec(k), 'MarkerSize',10)

end
% % % % % % 删除背景点

for i=1:m
    for j=1:n
       if((abs(Dx(i,j)-sx)<=1.2&&abs(Dy(i,j)-sy)<=1.2))%。。。。。meanshift
           Dx(i,j)=0;
           Dy(i,j)=0;   
       end
       
   end
end


a=zeros(M,N);
a(:,:)=0;
for i=1:M
     for j=1:N
         o=i-wifthU+1;
         p=j-lengthL+1;
         if o>0&&p>0&&o<m&&p<n
             if(Dx(o,p)~=0||Dy(o,p)~=0)
               a(i,j)=1;
             else
                 a(i,j)=0;
             end
         else
              a(i,j)=0;
         end
     end
end


% %二值图
% [m,n]=size(Dx);
% a=zeros(m,n);
% for i=1:m
%     for j=1:n
%         if(Dx(i,j)~=0||Dy(i,j)~=0)
%            a(i,j)=1;
%         else
%             a(i,j)=0;
%         end
%     end
% end
   a=bwareaopen(a,25);%删除小面积图形

   imshow(a);
% density= 1;
% figure; 
% [maxI,maxJ]=size(Dx);
% Dx=Dx(1:density:maxI,1:density:maxJ);
% Dy=Dy(1:density:maxI,1:density:maxJ);
% quiver(1:density:maxJ,(maxI):(-density):1,Dx,-Dy,1);
% axis square;





 toc











function result = reduce (img)
[m,n] = size (img);
mid = zeros (m, n);
m1 = round (m/2); n1 = round (n/2);
result = zeros (m1, n1);
%卷积核
core = [0.0500    0.2500    0.4000    0.2500    0.0500]; 
for j=1:m,
   lin = conv([img(j,n-1:n) img(j,1:n) img(j,1:2)], core);%行方向的线性卷积  
   mid(j,1:n1) = lin(5:2:n+4);
end
for i=1:n1,
   row = conv([mid(m-1:m,i); mid(1:m,i); mid(1:2,i)]', core);
   result(1:m1,i) = row(5:2:m+4)';
end


function result = expand (img)   %反卷积
[m,n] = size (img);
mid = zeros (m, n);
m1 = m * 2; n1 = n * 2;
result = zeros (m1, n1);
core = [0.0500    0.2500    0.4000    0.2500    0.0500]; 
for j=1:m,
   t = zeros (1, n1);
   t(1:2:n1-1) = img (j,1:n);
   tmp = conv ([img(j,n) 0 t img(j,1) 0], core);
   mid(j,1:n1) = 2 .* tmp (5:n1+4); 
end
for i=1:n1,
   t = zeros (1, m1);
   t(1:2:m1-1) = mid (1:m,i)'; 
   tmp = conv([mid(m,i) 0 t mid(1,i) 0], core);
   result(1:m1,i) = 2 .* tmp (5:m1+4)';
end


%搭建高斯金字塔
function [Dx, Dy] =  dopyramid (P00, P10,CH0)
level=3;
if (level>0)
    P01 = reduce (P00); P11 = reduce (P10);CH1 = reduce (CH0);
end
if (level>1)
    P02 = reduce (P01); P12 = reduce (P11);CH2 = reduce (CH1);
end
if (level>2)
    P03 = reduce (P02); P13 = reduce (P12);CH3 = reduce (CH2);
end
if (level>3)
    P04 = reduce (P03); P14 = reduce (P13);CH4 = reduce (CH3);
end  %4层金字塔搭建完毕
 Dx = zeros (size (P03)); %申请空间
 Dy = zeros (size (P03));
 
for i=level:-1:0 %逐层计算
    Newp1 = warp (eval(['P0',num2str(i)]), Dx, Dy);   
    
    [m,n]=size(eval(['P0',num2str(i)]));
    [Vx, Vy] = doEstimate (Newp1, eval(['P1',num2str(i)]),eval(['CH',num2str(i)]));
     Dx(1:m, 1:n) = Dx(1:m,1:n) + Vx; Dy(1:m, 1:n) = Dy(1:m, 1:n) + Vy;      %g=g0+d0
     if i~=0
     Dx = expand (Dx); Dy = expand (Dy);%值扩大二倍
     Dx = Dx .* 2; Dy = Dy .* 2;
     end
end
[m,n]=size(P00);
for i=1:m
    for j=1:n
        if(CH0(i,j)==0)
            Dx(i,j)=0;
            Dy(i,j)=0;
        end
    end
end

function [Vx, Vy] = doEstimate(P0, P1, P2)%第一幅图第二幅图和边缘点
[m,n]=size (P0);
Vx = zeros (size (P0)); Vy = zeros (size (P0));
for i=2:m-1
    for j=2:n-1
        if(P2(i,j)==0)%减少计算量
            Vx(i,j)=0;
            Vy(i,j)=0;
            continue;
        end
      N=[0,0,0,0,0];
        for tWid = i-1:i+1       %行方向窗口
            for tLen = j-1:j+1   %列方向窗口
                N= N+ derivation(P0,P1,tWid,tLen);
            end    
        end
        [v, d] = eig ([N(1) N(3);N(3) N(2)]);
         namda1 = d(1,1); namda2 = d(2,2);
        if (namda1 > namda2) %使 namda2>namda1
            tmp = namda1; namda1 = namda2; namda2 = tmp;
            tmp1 = v (:,1); v(:,1) = v(:,2); v(:,2) = tmp1;
        end
        if (namda2 < 0.001)%不满足 
            Vx (i, j) = 0; Vy (i, j) = 0;
        elseif (namda2 > 100 * namda1)%不满足 
            n2 = v(1,2) * N(4) + v(2,2) * N(5);
            Vx (i,j) = n2 * v(1,2) / namda2;
            Vy (i,j) = n2 * v(2,2) / namda2;
        else
            n1 = v(1,1) * N(4) + v(2,1) * N(5);%计算的是图像的光流（inv(G)*b）  t(4)和t(5)表示的是图像的比匹配向量  
            n2 = v(1,2) * N(4) + v(2,2) * N(5);
            Vx (i,j) = n1 * v(1,1) / namda1 + n2 * v(1,2) / namda2;%就这个地方的公式仅仅针对半正定（类似于[a,b;b,c]的形式）的矩阵可以有如下的计算：这4行等价于inv(G)*b  即inv([t(1) t(2);t(2) t(3)])*[t(4,t(5))]'  
            Vy (i,j) = n1 * v(2,1) / namda1 + n2 * v(2,2) / namda2;
        end
    end
end



function [N] = derivation(P0,P1,i,j)
[m,n]=size(P0);
N=[0,0,0,0,0];
% if(i<=0)
%     i=i+m;
% elseif(i>m)
%     i=i-m;
% end
% if(j<=0)
%     j=j+n;
% elseif(j>n)
%     j=j-n;
% end
Fx = DerivativeX (P1, i, j);
Fy = DerivativeY (P1, i, j);
N(1)=Fx*Fx;
N(2)=Fy*Fy;
N(3)=Fx*Fy;
N(4)=Fx*(P1(i,j)-P0(i,j));
N(5)=Fy*(P1(i,j)-P0(i,j));

function result = DerivativeX (img, x, y)%求Fx
[m, n] = size (img);
    if (y == 1)
        result = img (x, y+1) - img (x, y);
    elseif (y == n)
        result = img (x, y) - img (x, y-1);
    else
        result = 0.5 * (img (x, y+1) - img (x, y-1));
    end
    
function result = DerivativeY (img, x, y)%求Fy

[m, n] = size (img);
    if (x == 1)
        result = img (x+1, y) - img (x, y);
    elseif (x == m)
        result = img (x, y) - img (x-1, y);
    else
        result = 0.5 * (img (x+1, y) - img (x-1, y));
    end
function result = warp (img, Dx, Dy)
[m, n] = size (img);
[x,y] = meshgrid (1:n, 1:m);
x = x + Dx (1:m, 1:n); y = y + Dy (1:m,1:n);
for i=1:m,
    for j=1:n,
        if x(i,j)>n
            x(i,j) = n;
        end
        if x(i,j)<1
            x(i,j) = 1;
        end
        if y(i,j)>m
            y(i,j) = m;
        end
        if y(i,j)<1
            y(i,j) = 1;
        end
    end
end
result = interp2 (img, x, y, 'linear'); %是缺省值
 