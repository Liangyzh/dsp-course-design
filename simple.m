clc 
clear
close all

img=imread('sig.jpg');
f=rgb2gray(img);
[g,t]=edge(f,'canny');

imgp=double(g);
[y,x]=find(imgp==1);
p=polyfit(x,y,1);  

[n,m]=size(f);
rx=1:m;
ry=p(1)*rx+p(2);

% imshow(img)
% hold on
% plot(rx,ry)

imghsv=rgb2hsv(img);
imgh=imghsv(:,:,1);
point=double(ceil(ry)>0).*double(ceil(ry)<n);
xp=rx;
yp=ceil(point.*ry);
rsh=zeros(1,length(xp));
for i=1:length(xp)
    if yp(i)==0
        continue;
    end
    rsh(i)=imgh(yp(i),xp(i));
end

rsh=rsh*360;
subplot(121)
plot(rsh)

lpf=conv(rsh,ones(1,5)/5);
lpf=conv(lpf,ones(1,5)/5);
lpf=conv(lpf,ones(1,5)/5);
subplot(122)
plot(lpf)

dis1=(lpf-350).^2;
dis2=(lpf).^2;

start=double(dis1>1000&dis2>1600);
for i=1:8
start=double(conv(start,ones(1,10),'same')>5);
end
a=find(start==1);
startp=a(1);endp=a(end);
seq=lpf(startp:endp);
% subplot(122)
plot(seq)


dc=sum(seq)/length(seq);
findis=(seq-dc).^2;
pf=conv(findis,ones(1,3)/3,'same');
pf=conv(pf,ones(1,3)/3,'same');

% pf=conv(pf,ones(1,3)/3,'same');
result=double((conv(pf,[0 1 -1],'same')>0)&(conv(pf,[-1,1,0],'same')>0));

val=nonzeros(result.*findis);
position=nonzeros(result.*[1:length(result)]);

val(find(max(val)==val))=0;
val(find(max(val)==val))=0;

circle_num=5;
for i=1:circle_num
    finp(i)=position(find(max(val)==val))+startp;
    val(find(max(val)==val))=0;
%     plot(finp(i),p(1)*finp(i)+p(2),'*');
end






