%% BAL-GPE Matlab Toolbox
% Bayesian^3 Active Learning for Gaussian Process Emulator 
% Author: Sergey Oladyshkin
% Stuttgart Center for Simulation Science
% Department of Stochastic Simulation and Safety Research for Hydrosystems,
% Institute for Modelling Hydraulic and Environmental Systems
% University of Stuttgart, Pfaffenwaldring 5a, 70569 Stuttgart
% E-mail: Sergey.Oladyshkin@iws.uni-stuttgart.de
% Phone: +49-711-685-60116
% Fax: +49-711-685-51073
% http://www.iws.uni-stuttgart.de
%% The current BAL-GRE Matlab Toolbox is based on the following manuscripts: 
%Oladyshkin, S., Mohammadi, F., Kroeker I. and Nowak, W. Bayesian active learning for Gaussian process emulator using information theory. Entropy, 22(8), 890, 2020. (https://www.mdpi.com/1099-4300/22/8/890)
%Oladyshkin, S. and Nowak, W. The Connection between Bayesian Inference and Information Theory for Model Selection, Information Gain and Experimental Design. Entropy, 21(11), 1081, 2019. (https://www.mdpi.com/1099-4300/21/11/1081)
close all;
clear all;
clc;

%% Loading of BAL-GPE Response
load('StochasticCal2x10e6.mat');
%load('D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration\60_Run\BAL_Files\SurrogateModelResults_MC2E6.mat');
% clear ResponseSurface_Std;
% load('Visualization_Posterior_MC2x10e6.mat', 'CovarianceMatrix');% Erase
% NumberOfMeasurments=145; % Erase
% MeasurmentSpace.index=1:145; % Erase
%% Loading of Synthetic Measurments
%load('SynthecMeasurments.mat','PhysicalSpace', 'MeasurmentSpace','Observation','NumberOfMeasurments','MeasurementError','CovarianceMatrix');%Loading Synthetic Measurments

%% Prior Statistics for Measurment Points
for NofM=MeasurmentSpace.index
    PriorResponseSurface_Mean(NofM)=mean(ResponseSurface(NofM,:));   
    PriorResponseSurface_Std(NofM)=std(ResponseSurface(NofM,:));
end

%% Bayesian updating
%Deviation of Response Surface from Measurments
MeasurementError_HorVel=3;
MeasurementError_Temp=2;
Deviation=zeros(MCsize,NumberOfMeasurments);
%Observation=Observation(21:165);
for NofM=MeasurmentSpace.index
    Deviation(:,NofM)=Observation(NofM)-ResponseSurface(NofM,:);
end
%Computation of Likelihood according to the Deviation
Likelihood=zeros(1,MCsize);
for i=1:1:length(Deviation)     
    Likelihood(i)=1/(sqrt(2*pi)*MeasurementError_HorVel*MeasurementError_Temp)^NumberOfMeasurments*exp(-0.5*Deviation(i,:)*inv(CovarianceMatrix)*Deviation(i,:)');
end
%Maximum Likelihood
[value id_ML]=max(Likelihood);
ResponseSurface_ML=ResponseSurface(:,id_ML);

%% Rejection Sampling
load('Prior_distribution_2x10^6');
Unif=random('unif',0,1,1,MCsize);
ii=0;
for i=1:MCsize
    if Likelihood(i)/max(Likelihood)>Unif(i)
        ii=ii+1;
        Posterior_distribution(:,ii)=Prior_distribution(:,i);
        Posterior_ResponseSurface(:,ii)=ResponseSurface(:,i);
    end
    %Progress report 
    if mod(100*i/MCsize,10)==0 
        fprintf('Rejection sampling: '); disp([datestr(now) ' - ' num2str(round(100*i/MCsize)) '% completed']);
   end
end

%% Posterios Statistics for Measurment Points
for NofM=MeasurmentSpace.index; 
    PosteriorResponseSurface_Mean(NofM)=mean(Posterior_ResponseSurface(NofM,:));   
    PosteriorResponseSurface_Std(NofM)=std(Posterior_ResponseSurface(NofM,:));
end

save('Visualization_Posterior_51Run.mat','-v7.3')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data processed
load('Visualization_Posterior_51Run.mat')
%% Precalculations for visualizations
FP = 'D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration';
Time=1:145;
ObsLimTemp=20;
ObsLimHorVel=165;
load(fullfile((FP),'TemperatureObs'));
DepthObs=TempObs.Depthm;
Observation_Temp=Observation(1:ObsLimTemp);
Observation_Temp(1,20)=22;
load(fullfile((FP),'LayerDepth_Profile'));

%% Visualization of GPE surrogate evaluated with mean prior and mean posterior (Horizontal Velocity)
figure(1)
ax1 = gca;
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[100 400 700 150]);
hold on;
box on;

% Observed Values
plot(Time,Observation(ObsLimTemp+1:ObsLimHorVel),'.-','color',[0 0 0],'Linewidth',0.7)

% Maximum likelihood
%plot(Time,ResponseSurface_ML(ObsLimTemp+1:ObsLimHorVel),'color',[0 1 0],'Linewidth',1)

% Prior results
plot(Time,PriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel),'color',[1 0 0],'Linewidth',0.7)
y=PriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel);
y_std=PriorResponseSurface_Std(ObsLimTemp+1:ObsLimHorVel);
xconf = [Time, fliplr(Time)];
yconf = [y+y_std, fliplr(y-y_std)];
fill(xconf, yconf, 1, 'facecolor', [1 0 0], 'edgecolor', 'none', 'facealpha', 0.2);

% Posterior results
plot(Time,PosteriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel),'color',[0 0 1],'Linewidth',0.7)
y=PosteriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel);
y_std=PosteriorResponseSurface_Std(ObsLimTemp+1:ObsLimHorVel);
xconf = [Time, fliplr(Time)];
yconf = [y+y_std, fliplr(y-y_std)];
fill(xconf, yconf, 1, 'facecolor', [0 0 1], 'edgecolor', 'none', 'facealpha', 0.2);

%ylim([10 25])
set(ax1,'XTick',[0:25:150]);

xlabel('time [hours]')
ylabel('$\mathrm{Depth-averaged~Velocity [mm~s^{-1}]}$','Interpreter','latex')
%title('Horizontal Velocity Depth-Averaged Values')
%legend({'Horizontal Velocity Obs';...
%    'Horizontal Velocity Prior';'STD Prior';...
%    'Horizontal Velocity Posterior';'STD Posterior'},...
%    'Location','southoutside','Orientation','Horizontal','NumColumns',3)

grid on
set(gcf,'Position',[100  100 800  430]);
print(gcf,'foo.png','-dpng','-r300');

%% scatter posterior
figure (2)
%set(gcf,'Position',[10  50 600  600]);
set(gcf,'Name','string')
Num_MD=50; %Number of Simulation
% ModelDirectory=strcat (sprintf('%02d', Num_MD),'_Run');
% load(fullfile(FP,ModelDirectory,'BAL_Files','Posterior_MC10e6'));
% Posterior_Dist=Prior_distribution(:,ipost);
[R, P, fh]=corrplot(Posterior_distribution','varNames',{'BeV','BeD','T_O'},'type','Kendall','testR','on'); 
th = findall(fh(1).Parent.Parent, 'type', 'text', 'String', '{\bf Correlation Matrix}'); ;
th.String = 'Correlation Matrix';

print(gcf,'foo.png','-dpng','-r300');

%% Visualization of GPE surrogate mean posterior with ML first stage (Horizontal Velocity)
figure(3)
ax3 = gca;
set(gcf,'Color',[1 1 1]);
hold on;
box on;

% Observed Values
plot(Time,Observation(ObsLimTemp+1:ObsLimHorVel),'.-','color',[0 0 0],'Linewidth',1)

% Maximum likelihood
plot(Time,ResponseSurface_ML(ObsLimTemp+1:ObsLimHorVel),'color',[0 1 0],'Linewidth',2)

% Posterior results
plot(Time,PosteriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel),'--','color',[0 0 1],'Linewidth',1)
y=PosteriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel);
y_std=PosteriorResponseSurface_Std(ObsLimTemp+1:ObsLimHorVel);
xconf = [Time, fliplr(Time)];
yconf = [y+y_std, fliplr(y-y_std)];
fill(xconf, yconf, 1, 'facecolor', [0 0 1], 'edgecolor', 'none', 'facealpha', 0.2);

%ylim([-5 35])
set(ax3,'XTick',[0:25:150]);

xlabel('time [hours]')
ylabel('$\mathrm{Velocity [mm s^{-1}]}$','Interpreter','latex')
title('Horizontal Velocity Depth-Averaged Values')
legend({'Horizontal Velocity Obs';'Horizontal Velocity Max Likelihood';...
    'Horizontal Velocity Posterior';'STD Posterior'},...
    'Location','southoutside','Orientation','Horizontal','NumColumns',3)

grid on
set(gcf,'Position',[100  100 800  430]);

print(gcf,'foo.png','-dpng','-r300');

%% Visualization of GPE surrogate evaluated with mean prior and mean posterior (temperature)
figure(4)
ax4=gca;
set(gcf,'Color',[1 1 1]);
hold on
box on

% Observations
plot(flip(Observation_Temp'),DepthObs,'o-','color',[0 0 0],'linewidth',0.7);

% ML results
plot(ResponseSurface_ML(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[1 0 1],'linewidth',0.7);

% Prior results
plot(PriorResponseSurface_Mean(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[1 0 0],'linewidth',0.7);
x=PriorResponseSurface_Mean(1:ObsLimTemp);
x_std=PriorResponseSurface_Std(1:ObsLimTemp);
xconf = [x+x_std, fliplr(x-x_std)];
yconf = [abs((Layer_Depth(4:23)')), fliplr(abs((Layer_Depth(4:23)')))];
fill(xconf, yconf, 1, 'facecolor', [1 0 0], 'edgecolor', 'none', 'facealpha', 0.2);

% Posterior results
plot(PosteriorResponseSurface_Mean(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[0 0 1],'linewidth',0.7);
x=PosteriorResponseSurface_Mean(1:ObsLimTemp);
x_std=PosteriorResponseSurface_Std(1:ObsLimTemp);
xconf = [x+x_std, fliplr(x-x_std)];
yconf = [abs((Layer_Depth(4:23)')), fliplr(abs((Layer_Depth(4:23)')))];
fill(xconf, yconf, 1, 'facecolor', [0 0 1], 'edgecolor', 'none', 'facealpha', 0.2);

ax4.YDir = 'reverse' ;
ax4.XAxisLocation = 'top' ;
%set(ax4,'XTick',[6:2:30]);
xlim([10 25]);
xlabel('Temperature °C');
ylabel('Reservoir depth [m]','Interpreter','latex');
title('Temperature Profile [01.08.2016]')
legend({'Temperature Observed','Temperature Prior','STD Prior',...
    'Temperature Posterior','STD Posterior'},'Location','southoutside',...
    'Orientation','Horizontal','NumColumns',3);
grid on;

print(gcf,'foo.png','-dpng','-r300');

%save('Visualization_Posterior.mat','-v7.3')

%% Visualization of GPE surrogate evaluated with Delft3D (ML First stage) (temperature)
load('TempProfile_Delft3D.mat');
figure(5)
ax5=gca;
set(gcf,'Color',[1 1 1]);
hold on
box on

% Observations
plot(flip(Observation_Temp'),DepthObs,'o-','color',[0 0 0],'linewidth',0.7);

%Delft3D results
plot(Temp_Profile(1:20)',abs((Layer_Depth(4:23))),'color',[0 0 1],'linewidth',0.7);

% ML results
plot(ResponseSurface_ML(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[1 0 0],'linewidth',0.7);


ax5.YDir = 'reverse' ;
ax5.XAxisLocation = 'top' ;
%set(ax4,'XTick',[6:2:30]);
xlim([5 30]);
xlabel('Temperature °C');
ylabel('Depth [m]','Interpreter','latex');
title('Temperature Profile [01.08.2016]')
legend({'Temperature Observed','Temperature Delft3D [ML 1^{st} Stage]'...
    ,'Temperature GPE [ML 1^{st} Stage]'},'Location','southoutside',...
    'Orientation','Horizontal','NumColumns',2);
grid on;

print(gcf,'foo.png','-dpng','-r300');

%save('Visualization_Posterior.mat','-v7.3')

%% calculation of residuals
Posterior_residuals = Observation (ObsLimTemp+1:ObsLimHorVel) - PosteriorResponseSurface_Mean (ObsLimTemp+1:ObsLimHorVel);
Prior_residuals = Observation (ObsLimTemp+1:ObsLimHorVel) - PriorResponseSurface_Mean (ObsLimTemp+1:ObsLimHorVel);

%Temp_Error_GPE = Observation(1:20) - ResponseSurface_ML(1:20)';
%Temp_Error_DELFT3D = Observation(1:20) - Temp_Profile(1:20)';

Temp_Error_GPE = Observation(1:20) - PosteriorResponseSurface_Mean(1:20);
Temp_Error_DELFT3D = Observation(1:20) - PriorResponseSurface_Mean(1:20);

ME_GPE = mean(Temp_Error_GPE);
ME_DELFT3D = mean(Temp_Error_DELFT3D);
STD_GPE = std(Temp_Error_GPE);
STD_DELFT3D = std(Temp_Error_DELFT3D);
RMSE_GPE = sqrt(mean(Temp_Error_GPE.^2));
RMSE_DELFT3D = sqrt(mean(Temp_Error_DELFT3D.^2));
