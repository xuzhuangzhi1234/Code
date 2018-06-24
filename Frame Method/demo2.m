clear all;
close all;
clc;
mov=VideoReader('a.avi');
N=mov.NumberOfFrames;


for i=2:N
    frame=read(mov,i);
    Pframe=read(mov,i-1);
    if ndims(frame)==3
        x=rgb2gray(frame);
    else
        x=frame;
    end
    if ndims(Pframe)==3
        y=rgb2gray(Pframe);
    else
        y=Pframe;
    end
    subplot(1,2,1);
    imshow(Pframe,[]);
     title(sprintf('第%d帧',i-1))
    %差分算法
    x=medfilt2(x);
    y=medfilt2(y);
    n=im2double(x);
    p=im2double(y);

    c=n-p;
    c=medfilt2(c);
    t=10/256;

    c(abs(c)>=t)=255;
    c(abs(c)<t)=0;
    c=logical(c);

    x1=Pframe(:,:,1);
    x1(c)=0;
    x2=Pframe(:,:,2);
    x2(c)=255;
    x3=Pframe(:,:,3);
    x3(c)=0;
    xc=cat(3,x1,x2,x3);  

    subplot(1,2,2);
    imshow(xc,[]);
    title(sprintf('第%d帧',i-1))

end