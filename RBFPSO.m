clc;
clear;
tic;
SamNum=48;                         %ѵ��������
TargetSamNum=3;                   %����������
InDim=1;                            %��������ά��
UnitNum=2;                          %���ڵ���
MaxEpoch=1200;                      %���ѵ������
num=2;%��Ӧ�ĸ�����
%E0=0.2;                             %Ŀ�����
gbesthistory=[];
% ����Ŀ�꺯������������������ѵ��������
rand('state',sum(100*clock));
%NoiseVar=0.0005;
%Noise=NoiseVar*randn(1,SamNum);
load data
%��һ��
data1=data';
data=mapminmax(data1,0,1);
data=data';

%����ѵ�������Լ�
x_train=[data(1:48,1).';data(1:48,2).';data(1:48,3).';data(1:48,4).'];
x_test=[data(2:49,num).'];
y_train=[data(49:51,1).';data(49:51,2).';data(49:51,3).';data(49:51,4).'];
y_test=[data(50:52,num).'];
SamIn=x_train;
SamOut=x_test;
%��������
TargetIn=y_train;
TargetOut=y_test;


%����Ⱥ�㷨�е���������
c1 = 1.49445;
c2 = 1.49445;
popcount=10;   %������
poplength=6;  %����ά��
Wstart=0.9;%��ʼ����Ȩֵ
Wend=0.2;%�����������ʱ����Ȩֵ
%������ٶ������Сֵ
Vmax=1;
Vmin=-1;
popmax=4;
popmin=-4;
%����λ���ٶȺ�����ֵ��ʼ��

for i=1:popcount
    pop(i,:)=rand(1,9);%��ʼ������λ��
    V(i,:)=rand(1,9);%��ʼ�������ٶ�
    %����������Ӧ��ֵ
    Center=pop(i,1:3);
    SP=pop(i,4:6); 
    W=pop(i,7:9);
    Distance=dist(Center',SamIn);
    SPMat=repmat(SP',1,SamNum);%repmat��������
    UnitOut=radbas(Distance./SPMat);%���������
    NetOut=W*UnitOut;%�������
    Error=SamOut-NetOut;%�������
    %SSE=sumsqr(Error);
    %fitness(i)=SSE;
    RMSE=sqrt(sumsqr(Error)/SamNum);
    fitness(i)=RMSE;
    %fitness(i)=fun(pop(i,:));
end
%��Ӧ�Ⱥ�������Ӧ��ֵΪRBF��������


[bestfitness bestindex]=min(fitness);
gbest=pop(bestindex,:);%ȫ������ֵ
pbest=pop;%��������ֵ
pbestfitness=fitness;%����������Ӧ��ֵ
gbestfitness=bestfitness;%ȫ��������Ӧ��ֵ
%����Ѱ��
for i=1:MaxEpoch
   Vmax=1.00014^(-i);
   Vmin=-1.00014^(-i);
    for j=1:popcount
       % if (fitness(j)<gbestfitness|fitness==gbestfitness)
           % S(j)=0;
        %end
        %S(j)=1-(fitness(j)/100)^2;
       % GW(j)=Wstart-S(j)*(Wstart-Wend);
       % GW(j)=Wend+(GW(j)-Wend)*(MaxEpoch-i)/MaxEpoch;
        GW=Wstart-(Wstart-Wend)*i/MaxEpoch;
        %�ٶȸ���(��һ�ַ����������)
        V(j,:) = 1.000009^(-i)*(gbestfitness/fitness(j)+2)*rand*V(j,:) + c1*rand*(pbest(j,:) - pop(j,:)) + c2*rand*(gbest - pop(j,:));
        %V(j,:) = GW*((fitness(j)/2000)^2+1)*rand*V(j,:) + c1*rand*(pbest(j,:) - pop(j,:)) + c2*rand*(gbest - pop(j,:));
        %V(j,:) = GW*V(j,:) + c1*rand*(pbest(j,:) - pop(j,:)) + c2*rand*(gbest - pop(j,:));
        %V(j,:) = 0.9*V(j   ,:) + c1*rand*(pbest(j,:) - pop(j,:)) + c2*rand*(gbest - pop(j,:));
        %V(j,:) = 0.9*1.0003^(-j)* V(j,:) + c1*rand*(pbest(j,:) - pop(j,:)) + c2*rand*(gbest - pop(j,:));
        %V(j,:) = (gbestfitness/(exp(-fitness(j))+1)+0.5)*rand*V(j,:) + c1*rand*(pbest(j,:) - pop(j,:)) + c2*rand*(gbest - pop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %���Ӹ���
        pop(j,:)=pop(j,:)+0.5*V(j,:);
        pop(j,find(pop(j,:)>popmax))=popmax;
        pop(j,find(pop(j,:)<popmin))=popmin;
        %����������Ӧ��ֵ
        Center=pop(j,1:3);
        SP=pop(j,4:6); 
        W=pop(j,7:9);
        Distance=dist(Center',SamIn);
        SPMat=repmat(SP',1,SamNum);%repmat��������
        UnitOut=radbas(Distance./SPMat);
        NetOut=W*UnitOut;%�������
        Error=SamOut-NetOut;%�������
        %SSE=sumsqr(Error);
        %fitness(j)=SSE;
        RMSE=(sumsqr(Error)/SamNum);
        fitness(j)=RMSE;
       % Center=pop(j,1:10);
       % SP=pop(j,11:20);
       % W=pop(j,21:30);
       % fitness(j)=fun(pop(j,:));
    end
    for j=1:popcount
        
        %�������Ÿ���
        if fitness(j) < pbestfitness(j)
            pbest(j,:) = pop(j,:);
            pbestfitness(j) = fitness(j); 
        end
        
        %Ⱥ�����Ÿ���
        if fitness(j) < gbestfitness
            gbest = pop(j,:);
            gbestfitness = fitness(j);
        end
    end
    gbesthistory=[gbesthistory,gbest];
    %mse(i)=gbestfitness;
    %��Ⱥ������ֵ����RBF����
    Center=gbest(1,1:3);
    SP=gbest(1,4:6); 
    W=gbest(1,7:9);
    %Center=gbest(1,1:5);
    %SP=gbest(1,11:20); 
    % W=gbest(1,21:30);
     Distance=dist(Center',SamIn);
     SPMat=repmat(SP',1,SamNum);%repmat��������
     UnitOut=radbas(Distance./SPMat);
     NetOut=W*UnitOut;%�������
     Error=SamOut-NetOut;%�������
     %sse(i)=sumsqr(Error);
     mse(i)=(sumsqr(Error)/SamNum);
   % sse(i)=fun(gbest);
   %if sse(i)<E0,break,end 
end
toc;
% ���� 
Center=gbest(1,1:3);
SP=gbest(1,4:6); 
W=gbest(1,7:9);
TestDistance=dist(Center',TargetIn);
TesatSpreadsMat=repmat(SP',1,TargetSamNum);
TestHiddenUnitOut=radbas(TestDistance./TesatSpreadsMat);
TestNNOut=W*TestHiddenUnitOut;

%��ͼ �ֱ���ѵ�����Ͳ��Լ���
subplot(1,2,1)
plot(1:length(NetOut),NetOut,'*',1:length(NetOut),SamOut,'o')
title('In Train data')
subplot(1,2,2)
plot(1:3,TestNNOut,'*',1:3,TargetOut,'o')
title('In Test data')
%������ ѵ�����Ͳ��Լ�
train_error=sum(abs(SamOut-NetOut))/length(SamOut);
test_error=sum(abs(TargetOut-TestNNOut))/length(TargetOut);

%  ����ѧϰ�������
figure
hold on
grid
%[xx,Num]=size(errhistory);
plot(mse,'k-');
legend('mse')