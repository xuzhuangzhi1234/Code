function LK2
im1 = imread('image1.png');
im2 = imread('image2.png');
result2 = im2;
figure,imshow(im1);
figure,imshow(im2);
image1=single(rgb2gray(im1));
image2=single(rgb2gray(im2));

Levels=3;
window=15;
k=4;

half = floor(window/2);
temp1 = image1;
temp2 = image2;
for i=2:Levels
    image1 = impyramid(image1, 'reduce');
    image2 = impyramid(image2, 'reduce');
    temp1(1:size(image1,1), 1:size(image1,2), i) = image1;
    temp2(1:size(image2,1), 1:size(image2,2), i) = image2;
end;

for p = 1:Levels
    qq = Levels - p;
    image1 = temp1(1:(size(temp1,1)/(2^qq)), 1:(size(temp1,2)/(2^qq)),qq+1);
    image2 = temp2(1:(size(temp2,1)/(2^qq)), 1:(size(temp2,2)/(2^qq)),qq+1);
    if p==1
        u=zeros(size(image1));
        v=zeros(size(image1));
    else
        u = 2*imresize(u,size(u)*2,'bicubic');
        v = 2*imresize(v,size(v)*2,'bicubic');
    end
    [dx1,dy1] = gradient(image1);
    [dx2,dy2] = gradient(image2);
    for r=1:1:k
        u=round(u);
        v=round(v);
        for i = 1+half:size(image1,1)-half
            for j = 1+half:size(image2,2)-half
                picture1 = image1(i-half:i+half,j-half:j+half);
                up = i-half+v(i,j);
                down = i+half+v(i,j);
                left = j-half+u(i,j);
                right = j+half+u(i,j);
                if (up<1)||(down>size(image1,1))||(left<1)||(right>size(image1,2))
                    continue;
                else
                    picture2 = image2(up:down, left:right);
                    dxtemp = (dx1(i-half:i+half,j-half:j+half)+dx2(up:down,left:right))/2;
                    dytemp = (dy1(i-half:i+half,j-half:j+half)+dy2(up:down,left:right))/2;
                    dt = picture2 - picture1;
                    A = [dxtemp(:) dytemp(:)];
                    M=-(pinv(A'*A))*A'*dt(:);
                    u(i,j)=u(i,j)+M(1);
                    v(i,j)=v(i,j)+M(2);
                end
            end
        end
    end
end
result=zeros(size(u,1),size(u,2),3);
umax = 0;
vmax = 0;
umin = 10000;
vmin = 10000;
for i=1:size(u,1)
    for j=1:size(u,2)
        if (u(i,j)>umax)
            umax = u(i,j);
        end
        if (u(i,j)<umin)
            umin = u(i,j);
        end
        if (v(i,j)>vmax)
            vmax = v(i,j);
        end
        if (v(i,j)<vmin)
            vmin = v(i,j);
        end
    end
end
for i=1:size(u,1)
    for j=1:size(u,2)
        result(i,j,1) = 0.4;
        result(i,j,2) = (u(i,j)-umin)/(umax-umin);
        result(i,j,3) = (v(i,j)-vmin)/(vmax-vmin);
    end
end
u = round(u);
v = round(v);
flag = zeros(size(u,1),size(u,2));
for i=1:1:size(u,1)
    for j=1:1:size(u,2)
        if (((i+v(i,j))>0)&&(i+v(i,j)<=size(u,1))&&(j+u(i,j)<=size(u,2))&&(j+u(i,j)>0))
            result2(i+v(i,j),j+u(i,j),1) = im1(i,j,1);
            result2(i+v(i,j),j+u(i,j),2) = im1(i,j,2);
            result2(i+v(i,j),j+u(i,j),3) = im1(i,j,3);
            flag(i,j) = 1;
        else
            continue;
        end
    end
end
for i=1:1:size(u,1)
    for j=1:1:size(u,2)
        if (flag(i,j)==0)
            if (i==1)
                result2(i,j)=im1(2,j);
            elseif (i==size(u,1))
                result2(i,j)=im1(i-1,j);
            elseif (j==1)
                result2(i,j)=im1(i,j+1);
            elseif (j==size(u,2))
                result2(i,j)=im1(i,j-1);
            else
                result2(i,j)=(im1(i-1,j)+im1(i,j-1)+im1(i+1,j)+im1(i,j+1))/4;
            end
        end
    end
end
figure,imshow(result);
result = im2uint8(result);
B = smooth(result,10,4);
figure,imshow(B);
figure,imshow(result2);