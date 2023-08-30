%      Number of non-zero value in each output
%      X=3749 Y=3749 Z=1667 tX=1666 tY=1666 tZ=1666
% 70%->  2624   2624   1167    1166    1166    1166

in1e=data(5835:8335,1:6);
in2e=data(5835:8335,1:6);
in3e=data(10626:end,1:6); %*
in4e=data(835:1835,1:6);
in5e=data(2501:3501,1:6);
in6e=data(4168:5168,1:6);
Xe=data(5835:8335,7);
Ye=data(5835:8335,8);
Ze=data(10626:end,9); %*
tXe=data(835:1835,10);
tYe=data(2501:3501,11);
tZe=data(4168:5168,12);

in1v=data(8336:9584,1:6);
in2v=data(8336:9584,1:6);
in3v=data(1:834,1:6); %*
in4v=data(1836:2500,1:6);
in5v=data(3502:4167,1:6);
in6v=data(5169:5834,1:6);
Xv=data(8336:9584,7);
Yv=data(8336:9584,8);
Zv=data(1:834,9); %*
tXv=data(1836:2500,10);
tYv=data(3502:4167,11);
tZv=data(5169:5834,12);

%%
%train
u1=in6e;
y1=tZe;
%Test
u2=in6v;
y2=tZv;
% %Validate
% in = u2;
% out= y2;

%% ANFIS
%--train data
trnData=[u1,y1];
% avg1=mean(y1);
[n,~]=size(trnData);

x=trnData(:,1:end-1);
y=trnData(:,end);

%--checking dataset for overfitting model validation
chkData=[u2,y2];
% avg2=mean(y2);
[n2,~]=size(chkData);

x2=chkData(:,1:end-1);
y2=chkData(:,end);
%If you use chkData, you must also supply chkFis and chkErr

%--building FIS
%Grid partition
numMFs = [2 2 2 2 2 2];
mfType = 'dsigmf';
%gaussmf|gbellmf|trimf|pimf|trapmf|psigmf|dsigmf|zmf|smf|sigmf
outmftype= ('linear');  %linear or constant
in_fis = genfis1(trnData,numMFs,mfType,outmftype);
%%OR
% numMFs = [2 2 2 2 2 2 2];
% inmftype = char('trimf','gbellmf','gbellmf'...
%                ,'trimf','gbellmf','gbellmf','trimf');
% %gaussmf or gbellmf or trimf or pimf
% outmftype= ('constant');  %linear or constant
% in_fis = genfis1(trnData,numMFs,inmftype,outmftype);

% %subtractive clustering
% radii = [0.5 0.5 0.5 0.5 0.5 0.5 1];
% in_fis = genfis2(x,y,radii);
% %radii specifies the ranges of influence on each columns of data
% %if in has two columns and out has one column->radii = [0.5 0.4 0.3]

% %FCM clustering
% cluster_n='auto'; %='auto' best=10,11,12,13,14
% fcmoptions=[nan;nan;nan;1];
% %options(1): Exponent for the partition matrix U. Default: 2.0.
% %options(2): Maximum number of iterations. Default: 100.
% %options(3): Minimum amount of improvement. Default: 1e-5.
% %options(4): Information displayed during iteration. Default: 1.
% in_fis = genfis3(x,y,'sugeno',cluster_n,fcmoptions);
% %type is either 'mamdani' or 'sugeno'

%--train options
trnOpt=[20 0 0.01 0.9 1.1];
% trnOpt(1): training epoch number (default: 10)
% trnOpt(2): training error goal (default: 0)
% trnOpt(3): initial step size (default: 0.01)
% trnOpt(4): step size decrease rate (default: 0.9)
% trnOpt(5): step size increase rate (default: 1.1)

%--display options
dispOpt=[1 1 1 1];
% dispOpt(1): ANFIS information, such as numbers of input and output membership functions, and so on (default: 1)
% dispOpt(2): error (default: 1)
% dispOpt(3): step size at each parameter update (default: 1)
% dispOpt(4): final results (default: 1)

%--optional optimization method
optMethod=1;
% The default method is the hybrid method = 1
% either 1 for the hybrid method or 0 for the backpropagation method

%--estimate ANFIS output
[ofis,~,~,chkFis,~]=anfis(trnData,in_fis,trnOpt,dispOpt,chkData,optMethod);

figure;
s(1) = subplot(3,1,1); 
s(2) = subplot(3,1,2);
s(3) = subplot(3,1,3);
t=1:n;
plot(s(1),t,y,t,evalfis(x,ofis),'LineWidth',1); grid on; legend('real','model'); title(s(1),'Train')
mout=evalfis(u2,ofis);
t=1:n2;
plot(s(2),t,y2,t,evalfis(x2,ofis),'LineWidth',1); grid on; legend('real','model'); title(s(2),'Validate')
plot(s(3),t,mout-y2); grid on; title(s(3),'Error')

MSE_train=((1/n2)*(sum((y-evalfis(x,ofis)).^2)))
MSE_valid=((1/n2)*(sum((y2-mout(:,1)).^2)))

% getfis(in_fis)

% figure
% t=1:n;
% plot(t,y,t,evalfis(x,ofis)); grid on;

