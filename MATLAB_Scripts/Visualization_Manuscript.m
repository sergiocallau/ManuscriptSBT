%% Initialization
clear all, clc, close all

%% Load 1st scenario data
a = load('D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration\BAL-GPE_Matlab_Toolbox\Visualization_Posterior_51Run.mat');

%% Load 2nd scenario data
b = load('D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration\BAL-GPE_Matlab_Toolbox_HorVel\Visualization_Posterior_MC2x10e6.mat');
%% Precalculations for visualizations
FP = 'D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration';
Time=1:145;
ObsLimTemp=20;
ObsLimHorVel=165;
load(fullfile((FP),'TemperatureObs'));
DepthObs=TempObs.Depthm;
Observation_Temp=a.Observation(1:ObsLimTemp);
Observation_Temp(1,20)=22;
load(fullfile((FP),'LayerDepth_Profile'));

%% Figure 1
figure(1)
set(gcf,'Position',[10 20 800 1250]);

% 1st scenario
sfh1=subplot(2,1,1);
ax1 = gca;
set(gcf,'Color',[1 1 1]);
hold on;
box on;
% Observed Values
plot(Time,a.Observation(ObsLimTemp+1:ObsLimHorVel),'.-','color',[0 0 0],'Linewidth',0.7)

% Prior results
plot(Time,a.PriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel),'color',[1 0 0],'Linewidth',0.7)
y=a.PriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel);
y_std=a.PriorResponseSurface_Std(ObsLimTemp+1:ObsLimHorVel);
xconf = [Time, fliplr(Time)];
yconf = [y+y_std, fliplr(y-y_std)];
fill(xconf, yconf, 1, 'facecolor', [1 0 0], 'edgecolor', 'none', 'facealpha', 0.2);

% Posterior results
plot(Time,a.PosteriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel),'color',[0 0 1],'Linewidth',0.7)
y=a.PosteriorResponseSurface_Mean(ObsLimTemp+1:ObsLimHorVel);
y_std=a.PosteriorResponseSurface_Std(ObsLimTemp+1:ObsLimHorVel);
xconf = [Time, fliplr(Time)];
yconf = [y+y_std, fliplr(y-y_std)];
fill(xconf, yconf, 1, 'facecolor', [0 0 1], 'edgecolor', 'none', 'facealpha', 0.2);
ylim([-5 35])
set(ax1,'XTick',[0:25:150]);
xlabel('Time [hours]')
ylabel('$\mathrm{Depth-averaged~Velocity [mm~s^{-1}]}$','Interpreter','latex')
grid on
hold on
sfh1.Position = sfh1.Position + [0 0.05 0 0];
hsp1 = get(gca, 'Position');

% 2nd scenario
sfh2 = subplot(2,1,2);
ax2 = gca;
set(gcf,'Color',[1 1 1]);
hold on;
box on;

% Observed Values
plot(Time,b.Observation,'.-','color',[0 0 0],'Linewidth',0.7)

% Prior results
plot(Time,b.ProirResponseSurface_Mean,'color',[1 0 0],'Linewidth',0.7)
y=b.ProirResponseSurface_Mean;
y_std=b.ProirResponseSurface_Std;
xconf = [Time, fliplr(Time)];
yconf = [y+y_std, fliplr(y-y_std)];
fill(xconf, yconf, 1, 'facecolor', [1 0 0], 'edgecolor', 'none', 'facealpha', 0.2);

% Posterior results
plot(Time,b.PosteriorResponseSurface_Mean,'color',[0 0 1],'Linewidth',0.7)
y=b.PosteriorResponseSurface_Mean;
y_std=b.PosteriorResponseSurface_Std;
xconf = [Time, fliplr(Time)];
yconf = [y+y_std, fliplr(y-y_std)];
fill(xconf, yconf, 1, 'facecolor', [0 0 1], 'edgecolor', 'none', 'facealpha', 0.2);

ylim([-5 35])
set(ax2,'XTick',[0:25:150]);

xlabel('Time [hours]')
ylabel('$\mathrm{Depth-averaged~Velocity [mm~s^{-1}]}$','Interpreter','latex')
%title('Horizontal Velocity Depth-Averaged Values')
hL=legend({'U measured';...
    'U prior';'STD Prior';...
    'U posterior';'STD Posterior'},...
    'Location','southoutside','Orientation','Horizontal','NumColumns',3);
grid on
hsp2 = get(gca, 'Position');
set(gca, 'Position', [hsp2(1:3)  1*hsp1(4)]) 
sfh2.Position = sfh2.Position + [0 0.1 0 0];

print(gcf,'foo.png','-dpng','-r300');

%% Load 3rd Stage data
c=load('D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration\BAL-GPE_Matlab_Toolbox_Temp\Visualization_Posterior_MC2x10e6_Temp.mat');
%% Previous calculation
FP = 'D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration';
Time=1:145;
ObsLimTemp=20;
ObsLimHorVel=165;
load(fullfile((FP),'TemperatureObs'));
DepthObs=TempObs.Depthm;
Observation_Temp=c.Observation(1:ObsLimTemp);
Observation_Temp(1,20)=22;
load(fullfile((FP),'LayerDepth_Profile'));
Observation(1,20)=22;

%% Figure 2
figure(2)
set(gcf,'Position',[100 100 800 400]);

%1st stage
sfh3=subplot(1,2,1);
ax3=gca;
set(gcf,'Color',[1 1 1]);
hold on
box on

% Observations
plot(flip(Observation_Temp'),DepthObs,'o-','color',[0 0 0],'linewidth',0.7);

% ML results
plot(a.ResponseSurface_ML(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[1 0 1],'linewidth',0.7);

% Prior results
plot(a.PriorResponseSurface_Mean(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[1 0 0],'linewidth',0.7);
x=a.PriorResponseSurface_Mean(1:ObsLimTemp);
x_std=a.PriorResponseSurface_Std(1:ObsLimTemp);
xconf = [x+x_std, fliplr(x-x_std)];
yconf = [abs((Layer_Depth(4:23)')), fliplr(abs((Layer_Depth(4:23)')))];
fill(xconf, yconf, 1, 'facecolor', [1 0 0], 'edgecolor', 'none', 'facealpha', 0.2);

% Posterior results
plot(a.PosteriorResponseSurface_Mean(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[0 0 1],'linewidth',0.7);
x=a.PosteriorResponseSurface_Mean(1:ObsLimTemp);
x_std=a.PosteriorResponseSurface_Std(1:ObsLimTemp);
xconf = [x+x_std, fliplr(x-x_std)];
yconf = [abs((Layer_Depth(4:23)')), fliplr(abs((Layer_Depth(4:23)')))];
fill(xconf, yconf, 1, 'facecolor', [0 0 1], 'edgecolor', 'none', 'facealpha', 0.2);

ax3.YDir = 'reverse' ;
ax3.XAxisLocation = 'top' ;
%set(ax4,'XTick',[6:2:30]);
xlim([10 25]);
xlabel('Temperature °C');
ylabel('Reservoir depth [m]','Interpreter','latex');
grid on
sfh3.Position = sfh3.Position + [0 0 0 -0.03];
hsp3 = get(gca, 'Position');


% 3rd stage
sfh4=subplot(1,2,2);
ax5=gca;
set(gcf,'Color',[1 1 1]);
hold on
box on

% Observations
plot(flip(Observation_Temp'),DepthObs,'o-','color',[0 0 0],'linewidth',0.7);

% Prior results
plot(c.ProirResponseSurface_Mean,abs((Layer_Depth(4:23))),'color',[1 0 0],'linewidth',0.7);
x=c.ProirResponseSurface_Mean;
x_std=c.ProirResponseSurface_Std;
xconf = [x+x_std, fliplr(x-x_std)];
yconf = [abs((Layer_Depth(4:23)')), fliplr(abs((Layer_Depth(4:23)')))];
fill(xconf, yconf, 1, 'facecolor', [1 0 0], 'edgecolor', 'none', 'facealpha', 0.2);

% Posterior results
plot(c.PosteriorResponseSurface_Mean,abs((Layer_Depth(4:23))),'color',[0 0 1],'linewidth',0.7);
x=c.PosteriorResponseSurface_Mean;
x_std=c.PosteriorResponseSurface_Std;
xconf = [x+x_std, fliplr(x-x_std)];
yconf = [abs((Layer_Depth(4:23)')), fliplr(abs((Layer_Depth(4:23)')))];
fill(xconf, yconf, 1, 'facecolor', [0 0 1], 'edgecolor', 'none', 'facealpha', 0.2);

ax5.YDir = 'reverse' ;
ax5.XAxisLocation = 'top' ;
%set(ax5,'XTick',[15:5:25]);
xlim([10 25]);
xlabel('Temperature °C');
ylabel('Reservoir depth [m]','Interpreter','latex');
hL = legend({'T measured','T Prior','STD Prior',...
    'T Posterior','STD Posterior'},'Location','southoutside',...
    'Orientation','Horizontal','NumColumns',6);
grid on;
hsp4 = get(gca, 'Position');
set(gca, 'Position', [hsp4(1:2) 1*hsp3(3)  1*hsp3(4)]) 
sfh4.Position = sfh4.Position + [0 0 0 0];

hL.Position = hL.Position + [-0.08 0 0 0];

print(gcf,'foo.png','-dpng','-r300');

%% Deterministic HorVel data
d = load('Deterministic_FirstStage_HorVel.mat');
e = load('Deterministic_SecondStage_HorVel.mat');

%% Figure 3
figure(1)
set(gcf,'Position',[10 20 800 1250]);

% 1st scenario
sfh5=subplot(2,1,1);
ax1 = gca;
set(gcf,'Color',[1 1 1]);
hold on;
box on;

%Observed Values
plot(d.time,d.M_speed,'k-','color',[0 0 0],'Linewidth',1) %Plot ADCP Observations

%Model outputs Delft3D
plot(d.Time_Model,d.M_HorVel,'color',[0 0 1],'Linewidth',1) %Plot DELFT3D results

%Model outputs GPE surrogate
plot(d.Time,d.ResponseSurface_ML(21:165)','color',[1 0 0],'Linewidth',1) %Plot BALGPE ADCP results

set(ax1,'XTick',[0:25:150]);
ylim([5 25]);

xlabel('Time [hours]')
ylabel('$\mathrm{Deth-averaged~Velocity~U [mm~s^{-1}]}$','Interpreter','latex')
grid on
sfh5.Position = sfh5.Position + [0 0.05 0 0];
hsp5 = get(gca, 'Position');

% 2nd scenario
sfh6 = subplot(2,1,2);
ax2 = gca;
set(gcf,'Color',[1 1 1]);
hold on;
box on;

%Observed Values
plot(e.time,e.M_speed,'k-','color',[0 0 0],'Linewidth',1) %Plot ADCP Observations

%Model outputs Delft3D
plot(e.Time_Model,e.M_HorVel,'color',[0 0 1],'Linewidth',1) %Plot DELFT3D results

%Model outputs GPE surrogate
plot(e.Time,e.ResponseSurface_ML','color',[1 0 0],'Linewidth',1) %Plot BALGPE ADCP results

set(ax2,'XTick',[0:25:150]);
ylim([5 25]);

xlabel('time [hours]')
ylabel('$\mathrm{Depth-averaged~Velocity~U [mm~s^{-1}]}$','Interpreter','latex')
%title('Horizontal Velocity Depth-Averaged Values')
legend({'U measured'; 'U Verification (full complexity)';'U Verification (GPE)';...
    }, 'Location','southoutside','Orientation','Horizontal','NumColumns',2)

grid on
hsp6 = get(gca, 'Position');
set(gca, 'Position', [hsp6(1:3)  1*hsp5(4)]) 
sfh6.Position = sfh6.Position + [0 0.1 0 0];

print(gcf,'foo.png','-dpng','-r300');
%%
f=load('D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration\BAL-GPE_Matlab_Toolbox\TempProfile_Delft3D.mat');
g=load('D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration\BAL-GPE_Matlab_Toolbox_Temp\TempProfile_Delft3D.mat')
%% Figure 4
figure(24)
set(gcf,'Position',[100 100 800 400]);

%1st stage
sfh7=subplot(1,2,1);
ax3=gca;
set(gcf,'Color',[1 1 1]);
hold on
box on
% Observations
plot(flip(Observation_Temp'),DepthObs,'o-','color',[0 0 0],'linewidth',0.7);

%Delft3D results
plot(f.Temp_Profile(1:20)',abs((Layer_Depth(4:23))),'color',[0 0 1],'linewidth',0.7);

% ML results
plot(a.ResponseSurface_ML(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[1 0 0],'linewidth',0.7);

ax3.YDir = 'reverse';
ax3.XAxisLocation = 'top' ;
%set(ax4,'XTick',[6:2:30]);
xlim([10 25]);
xlabel('Temperature °C');
ylabel('Reservoir depth [m]','Interpreter','latex');
grid on
sfh7.Position = sfh7.Position + [0 0 0 -0.03];
hsp7 = get(gca, 'Position');


% 3rd stage
sfh8=subplot(1,2,2);
ax5=gca;
set(gcf,'Color',[1 1 1]);
hold on
box on
% Observations
plot(flip(Observation_Temp),DepthObs,'o-','color',[0 0 0],'linewidth',0.7);

%Delft3D results
plot(g.Temp_Profile(1:20)',abs((Layer_Depth(4:23))),'color',[0 0 1],'linewidth',0.7);

% ML results
plot(c.ResponseSurface_ML(1:ObsLimTemp),abs((Layer_Depth(4:23))),'color',[1 0 0],'linewidth',0.7);

ax5.YDir = 'reverse' ;
ax5.XAxisLocation = 'top' ;
%set(ax4,'XTick',[6:2:30]);
xlim([10 25]);
xlabel('Temperature °C');
ylabel('Reservoir depth [m]','Interpreter','latex');
title('Temperature Profile [01.08.2016]')
hL=legend({'T measured','T Verification (full complexity)'...
    ,'T Verification (GPE)'},'Location','southoutside',...
    'Orientation','Horizontal','NumColumns',3);
grid on;
hsp8 = get(gca, 'Position');
set(gca, 'Position', [hsp8(1:2) 1*hsp7(3)  1*hsp7(4)]) 
sfh8.Position = sfh8.Position + [0 0 0 0];

hL.Position = hL.Position + [-0.1 0 0 0];

print(gcf,'foo.png','-dpng','-r300');