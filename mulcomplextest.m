clc
clear
close all
%%

i1=imread('3.jpg');  
i2=imread('sig.jpg');  %source
i11=rgb2gray(i1);  
i22=rgb2gray(i2);   
imwrite(i11,'v1.jpg','quality',80);  
imwrite(i22,'v2.jpg','quality',80);  
[result,r1,r2]=match('v1.jpg','v2.jpg');  
imshow(i1)
hold on
plot(result(1,:),result(2,:),'*')

% p=polyfit(result(2,:),result(1,:),1);  
p=polyfit(result(1,:),result(2,:),1); 
[n,m]=size(i11);
rx=1:m;
ry=p(1)*rx+p(2);
plot(ry,rx);
hold off

figure,plot(result(1,:),result(2,:),'*');
hold on 
plot(rx,ry)
% plot(rx,ry);