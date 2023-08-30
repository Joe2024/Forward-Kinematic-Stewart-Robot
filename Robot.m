in1e=data(5835:8335,1:6);
in2e=data(5835:8335,1:6);
% in3e=data(9585:11459,1:6); %NARX and Old HW
% in3e=data(9585:11209,1:6);
in3e=data(10631:11209,1:6);
in4e=data(835:1835,1:6);
% in4e=data(834:2000,1:6);
in5e=data(2501:3501,1:6);
in6e=data(4168:5168,1:6);
Xe=data(5835:8335,7);
Ye=data(5835:8335,8);
% Ze=data(9585:11459,9);     %NARX and Old HW
% Ze=data(9585:11209,9);
Ze=data(10631:11209,9);
tXe=data(835:1835,10);
% tXe=data(834:2000,10);
tYe=data(2501:3501,11);
tZe=data(4168:5168,12);

in1v=data(8336:9584,1:6);
in2v=data(8336:9584,1:6);
% in3v=data(1:1834,1:6);      %NARX and Old HW
in3v=data(11210:11459,1:6);
in4v=data(1836:2500,1:6);
% in4v=data(2001:2501,1:6);
in5v=data(3502:4167,1:6);
in6v=data(5169:5834,1:6);
Xv=data(8336:9584,7);
Yv=data(8336:9584,8);
% Zv=data(1:1834,9);         %NARX and Old HW
Zv=data(11210:11459,9);
tXv=data(1836:2500,10);
% tXv=data(2001:2501,10);
tYv=data(3502:4167,11);
tZv=data(5169:5834,12);

% in=Gd(2501:2778);
% out=Gd(2502:2779);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
dataT=iddata(tXe,in4e,1);
dataC=iddata(tXv,in4v,1);
tic
Model = nlarx(dataT,[0  [1 1 1 1 1 1]  [0 0 0 0 0 0]],sigmoidnet('Num',7));
% Model =nlhw(dataT,[[1 1 1 1 1 1 1] [3 3 3 3 3 3 3] [0 0 0 0 0 0 0]],poly1d(2),poly1d(1));
toc
compare (dataT, Model)
figure
compare (dataC, Model)


Model=nlhw32;
out=tXv;
[n,~]=size(out);
% x0 = findstates(Model,[tXv in4v],[],'sim'); %NARX
x0 = findstates(Model,[tXv in4v]); %HW


tic
Mout=sim(Model,dataC,x0);
% Mout=sim('RobotNARX','StopTime', 't');
toc

mout=Mout.OutputData;
e=1:n;
figure;
plot(e/10,mout,'k',e/10,out,'b')




% [n,m]=size(out);
% x0 = findstates(model1,[out in],[],'pred');
% XX = iddata(out,in,1);
% 
% e=1:n+1;
% out2=Gd(2502:2779+1);
% figure;
% plot(e,out2,e,mout)
% 
% mout(n+1,:)=[];
