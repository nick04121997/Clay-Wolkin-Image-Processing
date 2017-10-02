%I = imread('lena.bmp');
[M,N,L] = size(I);
J = zeros(M,N);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
J(1:2:M,1:2:N) = R(1:2:M,1:2:N);
J(2:2:M,2:2:N) = B(2:2:M,2:2:N);
J(J==0) = G(J==0);
T = zeros(M,N,3);
figure,imshow(uint8(J));

%% Reconstruct Bayer Filtered Image here
for i = 2:M-1
    for j = 2:N-1
        if mod(i,2) == 0 && mod(j,2) == 1 %G
            T(i,j,1)=round((J(i-1,j)+J(i+1,j))/2);
            T(i,j,2)=round(J(i,j));
            T(i,j,3)=round((J(i,j-1)+J(i,j+1))/2);
        elseif mod(i,2) == 1 && mod(j,2) == 0
            T(i,j,1)=round((J(i,j-1)+J(i,j+1))/2);
            T(i,j,2)=round(J(i,j));
            T(i,j,3)=round((J(i-1,j)+J(i+1,j))/2);
        elseif mod(i,2) == 1 %R
            T(i,j,1)=round(J(i,j));
            T(i,j,2)=round((J(i-1,j)+J(i+1,j)+J(i,j-1)+J(i,j+1))/4);
            T(i,j,3)=round((J(i-1,j-1)+J(i+1,j-1)+J(i+1,j-1)+J(i-1,j+1))/4);
        else %B
            T(i,j,1)=round((J(i-1,j-1)+J(i+1,j-1)+J(i+1,j-1)+J(i-1,j+1))/4);
            T(i,j,2)=round((J(i-1,j)+J(i+1,j)+J(i,j-1)+J(i,j+1))/4);
            T(i,j,3)=round(J(i,j));
        end
    end
end