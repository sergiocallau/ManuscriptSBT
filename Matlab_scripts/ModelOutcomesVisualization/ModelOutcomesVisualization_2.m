%% Initialization
clear all; clc; close all;

%% Load response surface outcomes (training runs)
a = load('SM_Scenario00.mat');
b = load('SM_Scenario01.mat');
c = load('SM_Scenario02.mat');

%% Load model outcomes (post-calibration)
d = load('Det_Scenario00.mat');
e = load('Det_Scenario01.mat');
f = load('Det_Scenario02.mat');

%% Precalculation for visualizations
load('T_Observations.mat');
Time=1:145;
ObsLimTemp=20;
ObsLimHorVel=165;
DepthObs=TempObs.Depthm;
Observation_Temp=a.Observation(1:ObsLimTemp);
Observation_Temp(1,20)=22;

%% Figure 1
figure(1)
set(gcf,'Position',[10 20 800 1250]);

%%%%%% Scenario 0 %%%%%%
sfh1=subplot(2,1,1);
ax1 = gca;
set(gcf,'Color',[1 1 1]);
hold on;
box on;

% Posterior results
RS1 = a.Posterior_ResponseSurface;

for i=1:121
    hold on
    plot(Time,RS1(21:165,i),'color',[0.8 0.8 0.8],'linewidth',0.5)
end

% Observed Values
plot(Time,a.Observation(ObsLimTemp+1:ObsLimHorVel),'.-','color',[0 0 0],'Linewidth',0.7)

% Full complexity
plot(Time,d.M_HorVel,'color',[0 0 1],'Linewidth',0.7)

% Surrogate model
plot(Time,d.ResponseSurface_ML(21:165),'--','color',[0 0 1],'Linewidth',0.7)

ylim([5 25])
set(ax1,'XTick',[0:25:150]);
xlabel('Time (hours)','FontName', 'Arial', 'FontSize', 12)
ylabel('Depth-averaged Velocity (mm s^{-1})','FontName', 'Arial', 'FontSize', 12)
grid on
hold on
sfh1.Position = sfh1.Position + [0 0.05 0 0];
hsp1 = get(gca, 'Position');
set(gca,'FontName', 'Arial', 'FontSize', 12);

%%%%%% Scenario 1 %%%%%%
sfh2 = subplot(2,1,2);
ax2 = gca;
set(gcf,'Color',[1 1 1]);
hold on;
box on;

% Posterior results
RS2 = b.Posterior_ResponseSurface;

for i=1:582
    hold on
    h (i) = plot(Time,RS2(:,i),'color',[0.8 0.8 0.8],'linewidth',0.5);
end

% Observed Values
h(583) = plot(Time,b.Observation,'.-','color',[0 0 0],'Linewidth',0.7);

% Full complexity
h(584) = plot(Time,e.M_HorVel,'color',[0 0 1],'Linewidth',0.7);

% Surrogate model
h(585) = plot(Time,e.ResponseSurface_ML,'--','color',[0 0 1],'Linewidth',0.7);

ylim([5 25])
set(ax2,'XTick',[0:25:150]);

xlabel('Time (hours)','FontName', 'Arial', 'FontSize', 12)
ylabel('Depth-averaged Velocity (mm s^{-1})','FontName', 'Arial', 'FontSize', 12)

legend(h([582 583 584 585]),{'Training runs';...
    'Measurements';'Full-complexity model (post calibration)';...
    'Surrogate model (post calibration)'},...
   'Location','southoutside','Orientation','Horizontal','NumColumns',2,...
   'FontName', 'Arial', 'FontSize', 12);
grid on
hsp2 = get(gca, 'Position');
set(gca, 'Position', [hsp2(1:3)  1*hsp1(4)]) 
sfh2.Position = sfh2.Position + [0 0.1 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

print(gcf,'U_outcomes.png','-dpng','-r600');

%% Figure 2
figure(2)
set(gcf,'Position',[100 100 800 500]);

%%%%%% Scenario 1 %%%%%%
sfh3=subplot(1,2,1);
ax3=gca;
set(gcf,'Color',[1 1 1]);
hold on
box on

% Posteriors
for i=1:121
    hold on
    plot(RS1(1:20,i),abs((Layer_Depth(4:23))),'color',[0.8 0.8 0.8],'linewidth',0.5)
end

% Observations
plot(flip(Observation_Temp'),DepthObs,'o-','color',[0 0 0],'linewidth',0.7);

% Full complexity
plot(d.Temp_Profile(1:20)',abs((Layer_Depth(4:23))),'color',[0 0 1],'linewidth',0.7);

% Surrogate model
plot(a.ResponseSurface_ML(1:ObsLimTemp),abs((Layer_Depth(4:23))),'--','color',[0 0 1],'linewidth',0.7);

ax3.YDir = 'reverse' ;
ax3.XAxisLocation = 'top' ;
xlim([10 25]);
xlabel('Temperature (°C)','FontName', 'Arial', 'FontSize', 12');
ylabel('Reservoir depth (m)','FontName', 'Arial', 'FontSize', 12);
grid on
sfh3.Position = sfh3.Position + [0 0 0 -0.03];
hsp3 = get(gca, 'Position');
set(gca,'FontName', 'Arial', 'FontSize', 12);

%%%%%%% Scenario 2 %%%%%%%
sfh4=subplot(1,2,2);
ax5=gca;
set(gcf,'Color',[1 1 1]);
hold on
box on

% Posteriors
RS3 = c.Posterior_ResponseSurface;
for i=1:23511
    hold on
    h(i) = plot(RS3(1:20,i),abs((Layer_Depth(4:23))),'color',[0.8 0.8 0.8],'linewidth',0.5);
end

% Observations
h(23512) = plot(flip(Observation_Temp'),DepthObs,'o-','color',[0 0 0],'linewidth',0.7);

% Full complexity
h(23513) = plot(f.Temp_Profile(1:20)',abs((Layer_Depth(4:23))),'color',[0 0 1],'linewidth',0.7);

% Surrogate model
h(23514) = plot(c.ResponseSurface_ML(1:ObsLimTemp),abs((Layer_Depth(4:23))),'--',...
    'color',[0 0 1],'linewidth',0.7);

ax5.YDir = 'reverse' ;
ax5.XAxisLocation = 'top' ;
xlim([10 25]);

xlabel('Temperature (°C)','FontName', 'Arial', 'FontSize', 12);
ylabel('Reservoir depth (m)','FontName', 'Arial', 'FontSize', 12);

hL = legend(h([23511 23512 23513 23514]),{'Training runs',...
    'Measurements','Full-complexity model (post calibration)',...
    'Surrogate model (post calibration)'},'Location','southoutside',...
    'Orientation','Horizontal','NumColumns',2, 'FontName', 'Arial', 'FontSize', 12);

grid on;
hsp4 = get(gca, 'Position');
set(gca, 'Position', [hsp4(1:2) 1*hsp3(3)  1*hsp3(4)]) 
sfh4.Position = sfh4.Position + [0 0 0 0];

hL.Position = hL.Position + [0 0.015 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

print(gcf,'T_outcomes.png','-dpng','-r600');

