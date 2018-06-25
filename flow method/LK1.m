function LK1
image1 = imread('image1.png');
image2 = imread('image2.png');
image1 = rgb2gray(image1);
image2 = rgb2gray(image2);
image1 = single(image1);
image2 = single(image2);
[dx1,dy1] = gradient(image1);
[dx2,dy2] = gradient(image2);
dx = 1/2*(dx1+dx2);
dy = 1/2*(dy1+dy2);
dt = image1 - image2;
u = zeros(size(image1)); 
v = zeros(size(image1));
window = 9;
half = floor(window/2);
for i = half+1:size(dx,1)-half
    for j = half+1:size(dx,2)-half
        tempdx = (dx(i-half:i+half, j-half:j+half))';
        tempdy = (dy(i-half:i+half, j-half:j+half))';
        tempdt = (dt(i-half:i+half, j-half:j+half))';
        tempdx = tempdx(:); 
        tempdy = tempdy(:); 
        tempdt = tempdt(:);   
        A = [tempdx tempdy];  
        U = -pinv(A'*A)*A'*tempdt;   
        u(i,j)=U(1); 
        v(i,j)=U(2); 
    end; 
end;   
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
        result(i,j,3) = 0.4;
        result(i,j,1) = (u(i,j)-umin)/(umax-umin);
        result(i,j,2) = (v(i,j)-vmin)/(vmax-vmin);
    end
end
figure,imshow(result);
result = im2uint8(result);
B = smooth(result,10,4);
figure,imshow(B);