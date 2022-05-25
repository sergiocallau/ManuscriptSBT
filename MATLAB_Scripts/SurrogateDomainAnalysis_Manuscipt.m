%% Initialization
close all; clear all; clc;
%% Load Bathymetry data
SBT_Bathymetry=load('SBT_Bathymetry');
ADCP_Bathymetry=load('ADCP_Section_Bathymetry');
ADCP_Measurement_Section=load('grid_measurement_section');

%% Load surrogate model adapted for all the domain
load('SurrogateMatrix_2');
ADPCSection=127; %Section with observed data

%% Load ADCP data
load('D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration\ADCP.mat');
load('HorizontalVelocityADCP_CompleteSection');
n_M=4;
RDI_depth=ADCP.depth;
timeavg_speed=ADCP.timeAVGspeed;
time=ADCP.time*24;
depthavg_speed=ADCP.depthAVGspeed;
M_speed=ADCP.m_speed;

%% Load DELFT3D Horizontal velocity results in the monitoring section
load('DELFT3D_Results_Stage2');
load('DELFT3D_HorVel_Profile_Stage2');

%% Load GPE surrogate model Results (Monitoring section)
load('BALGPE_ADCP_Results_Stage2');

%% Calculation of Horizontal velocities - BALGPE Domain (calculations in ADCP Section)
RS_HV=HV_RSMatrix(:,:,ADPCSection,:);
RS_HV_Std=HV_RSMatrix_Std(:,:,ADPCSection,:);
DataSize_RS_HV=size(RS_HV);
% Horizontal Velocity Matrix [Layer x Time]
for i=1:DataSize_RS_HV(1)
    for j=1:DataSize_RS_HV(4)
        Velocity_H_RS(j,i)=nanmean(RS_HV(i,[1:end],1,j));
        Velocity_H_RS_Std(j,i)=nanmean(RS_HV_Std(i,[1:end],1,j));
    end
end
% Erase null velocities in Horizontal Velocity Matrix
for i=1:DataSize_RS_HV(4)
    Summation(i,1)=sum(Velocity_H_RS(i,1:end));
end

[Value, Position]=sort(Summation); % Detect layers with Zero Values
for i=1:size(Value)
    if Value(i) == 0
        DiscartedCol(i)=Position(i);
    end
end
%Discarte layers with 0 results
Velocity_H_RS(DiscartedCol,:)=[];
Velocity_H_RS=Velocity_H_RS(:,[1:end]);

Velocity_H_RS_Std(DiscartedCol,:)=[];
Velocity_H_RS_Std=Velocity_H_RS_Std(:,[1:end]);

% Modelling time in hours
Time_Model=1:DataSize_RS_HV(1);
DepthAVG_RS_hv = nanmean(Velocity_H_RS,1)*1000;
RS_HorVel = movmean(DepthAVG_RS_hv,n_M,'omitnan'); % for BAL
DepthAVG_RS_hv_Std = nanmean(Velocity_H_RS_Std,1)*1000;
RS_HorVel_std = movmean(DepthAVG_RS_hv_Std,n_M,'omitnan');

% Horizontal Velocity Time Average Analysis
Data_Size_RS_Model=size(Velocity_H_RS);
for i=1:Data_Size_RS_Model(1)
    HV_Time_AVG_RS(i,1)=(mean(Velocity_H_RS(i,[1:end])))*1000;
    HV_Time_AVG_RS_Std(i,1)=(mean(Velocity_H_RS_Std(i,[1:end])))*1000;
end

%% Horizontal Velocity Figure
f1 = figure;
ax1 = gca;
hold on;
box on;

%Observed Values
plot(time,M_speed,'k-','color',[0 0 0],'Linewidth',1) %Plot ADCP Observations

%Model outputs Delft3D
plot(Time_Model,M_HorVel,'color',[0 0 1],'Linewidth',1) %Plot DELFT3D results

%Model outputs GPE surrogate
plot(Time,ResponseSurface_ML','color',[1 0 0],'Linewidth',1) %Plot BALGPE ADCP results

%Model outputs adapted GPE surrogate
plot(Time_Model,RS_HorVel,'color',[0 1 0],'Linewidth',1) %Plot BALGPE Domain results in ADCP Section

set(ax1,'XTick',[0:25:150]);
ylim([5 25]);

xlabel('time [hours]')
ylabel('$\mathrm{Velocity [mm s^{-1}]}$','Interpreter','latex')
%title('Horizontal Velocity Depth-Averaged Values')
legend({'Horizontal Velocity Obs';'Horizontal Velocity Delft3D';'Horizontal Velocity GPE'...
    ;'Horizontal Velocity GPE_{Adjusted}';}, 'Location','southoutside','Orientation','Horizontal','NumColumns',2)

grid on
set(f1,'Position',[40  187 800  430]) ;
print(gcf,'foo.png','-dpng','-r300');  
%% rmse monitoring section

%% Figure Time-Averaged Speed and Magnitude (calculated speed)
f2 = figure;
ax2 = gca;
hold on
box on

% Observed data
plot(timeavg_speed,RDI_depth,'.-','color',[0 0 0],'Linewidth',1)

% Model output
plot(HV_Time_AVG,abs((Layer_Depth)),'.-','color',[0 0 1],'Linewidth',1);
plot(HV_Time_AVG_RS,abs((Layer_Depth)),'.-','color',[1 0 0],'Linewidth',1);

%Std results
x=HV_Time_AVG_RS';
x_std=HV_Time_AVG_RS_Std';
xconf = [x+x_std, fliplr(x-x_std)];
yconf = [abs((Layer_Depth')), fliplr(abs((Layer_Depth')))];
fill(xconf, yconf, 1, 'facecolor', [1 0 0], 'edgecolor', 'none', 'facealpha', 0.2);

ax2.XAxisLocation = 'top';
ax2.YDir = 'reverse' ;
legend({'Horizontal Velocity Obs';'Horizontal Velocity DELFT3D';'Horizontal Velocity GPE_{Adapted}'...
    ;'Std GPE_{Adapted}'},'Location','southeast')
xlabel('Velocity [mm s^{-1}]')
ylabel('$\mathrm{Water Depth [m]}$','Interpreter','latex')
title('Time-Averaged Values - Horizontal Velocity')
grid on
print(gcf,'foo.png','-dpng','-r300');  


%% Clear memory
% clear HV_RSMatrix;
% clear HV_RSMatrix_Std;
%% Bathymetry data
f4= figure;
set(gcf,'Position',[100 200 600 400]);
set(gca, 'FontSize', 10);
h1=surf(SBT_Bathymetry.data.X/1000, SBT_Bathymetry.data.Y/1000, SBT_Bathymetry.data.Val);
set(h1,'edgecolor','none')
colormap(jet); 
b1=colorbar;
view(0,90);
ylabel(b1,'Depth [m]','Rotation',270,'Position', [3 25 0]);
%ylabel('y coordinate [km]');
ylabel('$\mathrm{Y coordinate [km]}$','Interpreter','latex')
xlabel('$\mathrm{Y coordinate [km]}$','Interpreter','latex')
xlabel('X coordinate [km]');
hold on
h2=plot3(ADCP_Bathymetry.data.X/1000, ADCP_Bathymetry.data.Y/1000,ADCP_Bathymetry.data.Val,'k');
legend(h2,{'Monitoring section'},'location','southwest');
view(0,90);
set(gca, 'FontSize', 9);
grid on
print(gcf,'foo.png','-dpng','-r300');  

%% Load DELFT3D Horizontal velocity results for all the domain
load('HorizontalVelocityDomainDELFT3D_Stage2');
HV_Val=data.Val;
x=squeeze(data.X(1,:,:,1));
y=squeeze(data.Y(1,:,:,1));

%% Selection of horizontal velocity results
% Layer 7 - turbine
T_GPE_HV7(:,:,:)=HV_RSMatrix(49,:,:,7);% results of the GPE adapted
Turb_GPE7=squeeze(T_GPE_HV7(1,:,:));
T_DELFT3D_HV7(:,:,:)=HV_Val(49,:,:,7);% DELFT3D Results
Turb_DELFT3D7=squeeze(T_DELFT3D_HV7(1,:,:));
% Layer 15 - turbine
T_GPE_HV15(:,:,:)=HV_RSMatrix(49,:,:,15);% results of the GPE adapted
Turb_GPE15=squeeze(T_GPE_HV15(1,:,:));
T_DELFT3D_HV15(:,:,:)=HV_Val(49,:,:,15);% DELFT3D Results
Turb_DELFT3D15=squeeze(T_DELFT3D_HV15(1,:,:));
% Layer 23 - turbine
T_GPE_HV23(:,:,:)=HV_RSMatrix(49,:,:,23);% results of the GPE adapted
Turb_GPE23=squeeze(T_GPE_HV23(1,:,:));
T_DELFT3D_HV23(:,:,:)=HV_Val(49,:,:,23);% DELFT3D Results
Turb_DELFT3D23=squeeze(T_DELFT3D_HV23(1,:,:));

% Layer 7 - pump
P_GPE_HV7(:,:,:)=HV_RSMatrix(52,:,:,7);% results of the GPE adapted
Pump_GPE7=squeeze(P_GPE_HV7(1,:,:));
P_DELFT3D_HV7(:,:,:)=HV_Val(52,:,:,7);% DELFT3D Results
Pump_DELFT3D7=squeeze(P_DELFT3D_HV7(1,:,:));
% Layer 15 - pump
P_GPE_HV15(:,:,:)=HV_RSMatrix(52,:,:,15);% results of the GPE adapted
Pump_GPE15=squeeze(P_GPE_HV15(1,:,:));
P_DELFT3D_HV15(:,:,:)=HV_Val(52,:,:,15);% DELFT3D Results
Pump_DELFT3D15=squeeze(P_DELFT3D_HV15(1,:,:));
% Layer 23 - pump
P_GPE_HV23(:,:,:)=HV_RSMatrix(52,:,:,23);% results of the GPE adapted
Pump_GPE23=squeeze(P_GPE_HV23(1,:,:));
P_DELFT3D_HV23(:,:,:)=HV_Val(52,:,:,23);% DELFT3D Results
Pump_DELFT3D23=squeeze(P_DELFT3D_HV23(1,:,:));

%% Horizontal Velocity 2D Pump
f5= figure;
set(gcf,'Position',[50 50 850 1100]);
set(gcf,'Color',[1 1 1]);
hold on
an=annotation('textbox', [0.4, 0, 0.1, 0.1], 'String',...
    "Coordinate System: EPSG:5667-DHNH/3-degree Gauss-Kruger Zone-3");
an.Position = an.Position + [0 -0.05 0 0];

sp1 = subplot (3, 2, 1);
h=surf(x*10^-3,y*10^-3,Pump_GPE23);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title({'GPE_{Adjusted}','3-m below maximum operation water level'})
ylabel('$\mathrm{Y coordinate~[km]}$','Interpreter','latex')
sp1.Position = sp1.Position +[0 0 -0.05 0];

sp2 = subplot (3, 2, 2);
h=surf(x*10^-3,y*10^-3,Pump_DELFT3D23);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title({'DELFT3D-FLOW','3-m below maximum operation water level'})
sp2.Position = [sp2.Position(1:2)  1*sp1.Position(3) sp2.Position(4)]...
    + [-.025 0 0 0];

sp3 = subplot (3, 2, 3);
h=surf(x*10^-3,y*10^-3,Pump_GPE15);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('16-m below maximum operation water level')
ylabel('$\mathrm{Y coordinate~[km]}$','Interpreter','latex')
sp3.Position = [sp3.Position(1:2)  1*sp1.Position(3) sp3.Position(4)]...
    + [0 0 0 0];

sp4 = subplot (3, 2, 4);
h=surf(x*10^-3,y*10^-3,Pump_DELFT3D15);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('16-m below maximum operation water level')
sp4.Position = [sp4.Position(1:2)  1*sp1.Position(3) sp4.Position(4)]...
    + [-.0250 0 0 0];

sp5 = subplot (3, 2, 5);
h=surf(x*10^-3,y*10^-3,Pump_GPE7);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('30-m below maximum operation water level')
ylabel('$\mathrm{Y coordinate~[km]}$','Interpreter','latex')
xlabel('$\mathrm{X coordinate~[km]}$','Interpreter','latex')
sp5.Position = [sp5.Position(1:2)  1*sp1.Position(3) sp5.Position(4)]...
    + [0 0 0 0];

sp6 = subplot (3, 2, 6);
h=surf(x*10^-3,y*10^-3,Pump_DELFT3D7);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
a1=colorbar;
ylabel(a1,'Horizontal Velocity[m s^{-1}]','Rotation',270,'Position', [3.2 0.075 0]);
view(0,90);
set(gca, 'FontSize', 9);
box on
title('30-m below maximum operation water level')
xlabel('$\mathrm{X coordinate~[km]}$','Interpreter','latex')
sp6.Position = [sp6.Position(1:2)  1*sp1.Position(3) sp6.Position(4)]...
    + [-0.025 0 0 0];

print(gcf,'foo.png','-dpng','-r300');  
%% Horizontal Velocity 2D Turbine
f6= figure;
set(gcf,'Position',[50 50 850 1100]);
hold on
an=annotation('textbox', [0.4, 0, 0.1, 0.1], 'String',...
    "Coordinate System: EPSG:5667-DHNH/3-degree Gauss-Kruger Zone-3");
an.Position = an.Position + [0 -0.05 0 0];

sp1 = subplot (3, 2, 1);
h=surf(x*10^-3,y*10^-3,Turb_GPE23);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title({'GPE_{Adjusted}','3-m below maximum operation water level'})
ylabel('$\mathrm{Y coordinate ~[km]}$','Interpreter','latex')
sp1.Position = sp1.Position +[0 0 -0.05 0];

sp2 = subplot (3, 2, 2);
h=surf(x*10^-3,y*10^-3,Turb_DELFT3D23);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title({'Delft3D-FLOW','3-m below maximum operation water level'})
sp2.Position = [sp2.Position(1:2)  1*sp1.Position(3) sp2.Position(4)]...
    + [-.025 0 0 0];

sp3 = subplot (3, 2, 3);
h=surf(x*10^-3,y*10^-3,Turb_GPE15);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('16-m below maximum operation water level')
ylabel('$\mathrm{Y coordinate ~[km]}$','Interpreter','latex')
sp3.Position = [sp3.Position(1:2)  1*sp1.Position(3) sp3.Position(4)]...
    + [0 0 0 0];

sp4 = subplot (3, 2, 4);
h=surf(x*10^-3,y*10^-3,Turb_DELFT3D15);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('16-m below maximum operation water level')
sp4.Position = [sp4.Position(1:2)  1*sp1.Position(3) sp4.Position(4)]...
    + [-0.025 0 0 0];

sp5 = subplot (3, 2, 5);
h=surf(x*10^-3,y*10^-3,Turb_GPE7);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('30-m below maximum operation water level')
ylabel('$\mathrm{Y coordinate ~[km]}$','Interpreter','latex')
xlabel('$\mathrm{X coordinate ~[km]}$','Interpreter','latex')
sp5.Position = [sp5.Position(1:2)  1*sp1.Position(3) sp5.Position(4)]...
    + [0 0 0 0];

sp6 = subplot (3, 2, 6);
h=surf(x*10^-3,y*10^-3,Turb_DELFT3D7);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
a1=colorbar;
ylabel(a1,'Horizontal Velocity [m s^{-1}]','Rotation',270,'Position', [3.2 0.075 0]);
view(0,90);
set(gca, 'FontSize', 9);
box on
title('30-m below maximum operation water level')
xlabel('$\mathrm{X coordinate ~[km]}$','Interpreter','latex')
sp6.Position = [sp6.Position(1:2)  1*sp1.Position(3) sp6.Position(4)]...
    + [-0.025 0 0 0];

print(gcf,'foo.png','-dpng','-r300');  


