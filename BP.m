clear
clc
%����ѵ���������뼯
load data;
%��һ��
data1=data';
data=mapminmax(data1,0,1);
data=data';
num=2;%��Ӧ�ĸ�����
%����ѵ�������Լ�
x_train=[data(1:48,1).';data(1:48,2).';data(1:48,3).';data(1:48,4).'];
x_test=[data(49:51,1).';data(49:51,2).';data(49:51,3).';data(49:51,4).'];
y_train=[data(2:49,num).'];
y_test=[data(50:52,num).'];
%����BP������
%��������
net=newff(minmax(x_train),[4,1],{'tansig','purelin'},'trainlm');%������Ԫ�������������Ԫ����
%����ѵ������
net.trainParam.epochs = 100;
%�����������
net.trainParam.goal=0.001;
%ѵ������
[net,tr]=train(net,x_train,y_train);
%��ѵ�����Ͳ��Լ��ϵı���
y_train_predict=sim(net,x_train);
y_test_predict=sim(net,x_test);
%��ͼ �ֱ���ѵ�����Ͳ��Լ���
subplot(1,2,1)
plot(1:length(y_train_predict),y_train_predict,'*',1:length(y_train_predict),y_train,'o')
title('In Train data')
subplot(1,2,2)
plot(1:3,y_test_predict,'*',1:3,y_test,'o')
title('In Test data')
%������ ѵ�����Ͳ��Լ�
train_error=sum(abs(y_train_predict- y_train))/length(y_train);
test_error=sum(abs(y_test_predict- y_test))/length(y_test);





