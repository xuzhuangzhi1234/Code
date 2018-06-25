function B1 = smooth(A,hr,hs)
[row,col,dim] = size(A);
A = double(A);
A1 = A(:,:,1);
A2 = A(:,:,2);
A3 = A(:,:,3);
B = A;
h = 2*hs;

%Gaussian Kernel
u = 2*h+1;
kernel = ones(u,u);
for i=1:1:u
    for j=1:1:u
        kernel(i,j)=(i-h-1)^2+(j-h-1)^2;
    end
end
kernel = exp(-kernel./(hs*hs));

%Smooth the original graph
for i = 1:row
    for j = 1:col
        x1 = max([1,h+2-i]);
        y1 = max([1,h+2-j]);
        x2 = min([2*h+1,row+h+1-i]);
        y2 = min([2*h+1,col+h+1-j]);
        Partkernel = kernel(x1:x2,y1:y2);
        x3 = i-h-1+x1;      %The codes above seem to be very complicated, but note that we need
        y3 = j-h-1+y1;      %to check the boundary of the graph. I will explain this in the project
        x4 = i+x2-h-1;      %report more clearly. These codes prevent such a condition that the 
        y4 = j+y2-h-1;      %pixels which will be operating in the kernel exceeds the boundary of the picture.
        for t=1:1:5         %Every time, the vector moves towards the destination a litter. Here, the iteration is 5 times. It is suffcient to converge.
            Part = A1(x3:x4,y3:y4);
            Difference = Part - A1(i,j);
            Difference = Difference.^2;
            R = exp(-Difference./(hr.^2));
            weight = R.*Partkernel;
            value = sum(sum(Part.*weight));
            sumnumber = sum(sum(weight));
            A1(i,j) =  value/sumnumber;

            Part = A2(x3:x4,y3:y4);
            Difference = Part - A2(i,j);
            Difference = Difference.^2;
            R = exp(-Difference./(hr.^2));
            weight = R.*Partkernel;
            value = sum(sum(Part.*weight));
            sumnumber = sum(sum(weight));
            A2(i,j) =  value/sumnumber;

            Part = A3(x3:x4,y3:y4);
            Difference = Part - A3(i,j);
            Difference = Difference.^2;
            R = exp(-Difference./(hr.^2));
            weight = R.*Partkernel;
            value = sum(sum(Part.*weight));
            sumnumber = sum(sum(weight));
            A3(i,j) =  value/sumnumber;
        end
        B(i,j,1)=A1(i,j);
        B(i,j,2)=A2(i,j);
        B(i,j,3)=A3(i,j);
    end
end
B1 = uint8(B);

