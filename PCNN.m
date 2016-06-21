function [P,ST]=PCNN1(matrixA,it)%P是点火图，ST时间信号
[p,q]=size(matrixA);%输入图像的大小
ST=zeros(it);%时间信号的长度，即迭代次数
DM=double(matrixA);%输入图像为uint8类型，转为double类型以利于处理
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%建立PCNN模型，未简化版
%初始化相关参数
link_arrange=3;%8邻域
% link_arrange=5;%24邻域
%以下三者关系应从大到小
alpha_F=0.6;% 馈送域时间系数,越大,时间信号波动越强
alpha_Theta=0.8;%阈值时间系数，越小,时间信号波动越强
alpha_L=1;% 连接域时间系数，越小,时间信号波动越强（不明显）
% alpha_Theta=0.05;
beta=0.1;%连接强度,越小，时间信号波动越强
% beta=0.4;
vL=0.2;%连接域幅度系数,越小，时间信号波动越强
vF=0.2;%馈送域幅度系数,越大,时间信号波动越强（不明显）
vTheta=2000;%阈值幅度系数,越大,时间信号波动越强
%初始化所有用到的矩阵
L=zeros(p,q);%馈送域输入,初始值为0
F=DM;%连接域输入，初始化为输入图像
U=zeros(p,q);%内部活性,初始值为0
Y=zeros(p,q);%点火图,初始值为0
Theta=zeros(p,q)+200;%初始阈值，对时间信号波形影响不大
%%%%%%%%
%突触连接权系数矩阵W
% W=[1/sqrt(2) 1 1/sqrt(2);
%          1   0    1     ;
%   1/sqrt(2) 1 1/sqrt(2)];
% W=[0.1091  0.1409  0.1091;0.1409 0 0.1409; 0.1091  0.1409  0.1091];
%good
if link_arrange==3
    %W=[0.08  0.15  0.08;0.15 0 0.15; 0.08  0.15  0.08];%better
    W=[0.707  1  0.707;1 0 1; 0.707  1  0.707];%连接权矩阵，中心点为0
end
if link_arrange==5
    W=[0.02 0.05  0.10  0.05 0.02;
        0.05 0.08  0.15  0.08 0.05;
        0.10 0.15   0    0.10 0.15;
        0.05 0.08  0.15  0.08 0.05;
        0.02 0.05  0.10  0.05 0.02];
end
W1=[1 1 1;
    1 0 1;
    1 1 1];%用于计算4邻域内像素灰度之和
%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n=1:it
    K=conv2(Y,W,'same');%计算模板W和Y的卷积，结果与Y的大小相同
    L=exp(-alpha_L)*L+vL*K;
    U=F.*(1+beta*L);
    Theta=exp(-alpha_Theta)*Theta+vTheta*Y;
    Y=im2double(U>Theta);
    %figure;
    %imshow(Y);
    F=exp(-alpha_F)*F+vF*K+DM;
    ST(n)=sum(sum(Y));
    %fprintf('第%d次迭代时点火点个数为%d\n',n,ST);
    %      if any(Y(:))==0;
    %          fprintf('第%d次迭代后没有点火点了\n',n);
    % %         break;
    %      end
    %  fprintf('第%d次迭代\n',n);
    figure,imshow(Y)
end
P=Y;
end