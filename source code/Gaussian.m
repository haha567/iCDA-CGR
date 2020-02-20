%求高斯核函数
load('disease_circRNA_A.mat');
%计算疾病的高斯
Gaussian_Dis = zeros(89,89);
pare_a=0; %参数
sum=0; %记录总数
temp=0;
%按行来求（有按列来的）
for i=1:89   %行数
    temp=norm(A(i,:));
    sum=sum+temp^2;
end
pare_a=1/(sum/89);

for i=1:89
    i
    for j=1:89
        Gaussian_Dis(i,j)=exp(-pare_a*(norm(A(i,:)-A(j,:))^2));
    end
end

%计算miRNA的高斯
Gaussian_cricR = zeros(533,533);
pare_b=0; %参数
sum=0; %记录总数
temp=0;
%按列来求
for i=1:533   %列数
    temp=norm(A(:,i));
    sum=sum+temp^2;
end
pare_b=1/(sum/533);

for i=1:533
    i
    for j=1:533
        Gaussian_cricR(i,j)=exp(-pare_b*(norm(A(:,i)-A(:,j))^2));
    end
end
