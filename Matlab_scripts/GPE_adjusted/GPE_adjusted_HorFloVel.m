%% Initialization
close all; clear all; clc;

%% Load Bathymetry data
load('SR_bathymetry');

%% Load surrogate model adjusted for all the domain
load('SurrogateMatrix_2');

%% Load DELFT3D Horizontal velocity results for all the domain
load('HorizontalVelocityDomainDELFT3D.mat');
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
set(gcf,'Position',[50 50 950 1100]);
set(gcf,'Color',[1 1 1]);
hold on
an=annotation('textbox', [0.4, 0, 0.1, 0.1], 'String',...
    "Coordinate System: EPSG:5667-DHNH/3-degree Gauss-Kruger Zone-3",...
    'FontName', 'Arial', 'FontSize', 12);
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
ylabel('Y coordinate (km)')
sp1.Position = sp1.Position +[0 0 -0.05 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

sp2 = subplot (3, 2, 2);
h=surf(x*10^-3,y*10^-3,Pump_DELFT3D23);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title({'Delft3D-FLOW','3-m below maximum operation water level'})
sp2.Position = [sp2.Position(1:2)  1*sp1.Position(3) sp2.Position(4)]...
    + [-.025 0 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

sp3 = subplot (3, 2, 3);
h=surf(x*10^-3,y*10^-3,Pump_GPE15);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('16-m below maximum operation water level')
ylabel('Y coordinate (km)')
sp3.Position = [sp3.Position(1:2)  1*sp1.Position(3) sp3.Position(4)]...
    + [0 0 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

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
set(gca,'FontName', 'Arial', 'FontSize', 12);

sp5 = subplot (3, 2, 5);
h=surf(x*10^-3,y*10^-3,Pump_GPE7);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('30-m below maximum operation water level')
ylabel('Y coordinate (km)')
xlabel('X coordinate (km)')
sp5.Position = [sp5.Position(1:2)  1*sp1.Position(3) sp5.Position(4)]...
    + [0 0 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

sp6 = subplot (3, 2, 6);
h=surf(x*10^-3,y*10^-3,Pump_DELFT3D7);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
a1=colorbar;
ylabel(a1,'Horizontal Velocity (m s^{-1})','FontName', 'Arial', 'FontSize', 12,...
    'Rotation',270,'Position', [3.7 0.075 0]);
view(0,90);
set(gca, 'FontSize', 9);
box on
title('30-m below maximum operation water level')
xlabel('X coordinate (km)')
sp6.Position = [sp6.Position(1:2)  1*sp1.Position(3) sp6.Position(4)]...
    + [-0.025 0 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

print(gcf,'pump.png','-dpng','-r600');  
%% Horizontal Velocity 2D Turbine
f6= figure;
set(gcf,'Position',[50 50 950 1100]);
hold on
an=annotation('textbox', [0.4, 0, 0.1, 0.1], 'String',...
    "Coordinate System: EPSG:5667-DHNH/3-degree Gauss-Kruger Zone-3",...
    'FontName', 'Arial', 'FontSize', 12);
an.Position = an.Position + [0 -0.05 0 0];

sp1 = subplot (3, 2, 1);
h=surf(x*10^-3,y*10^-3,Turb_GPE23);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title({'GPE_{Adjusted}','3-m below maximum operation water level'},...
    'FontName', 'Arial', 'FontSize', 12)
ylabel('Y coordinate (km)')
sp1.Position = sp1.Position +[0 0 -0.05 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

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
set(gca,'FontName', 'Arial', 'FontSize', 12);

sp3 = subplot (3, 2, 3);
h=surf(x*10^-3,y*10^-3,Turb_GPE15);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('16-m below maximum operation water level')
ylabel('Y coordinate (km)')
sp3.Position = [sp3.Position(1:2)  1*sp1.Position(3) sp3.Position(4)]...
    + [0 0 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

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
set(gca,'FontName', 'Arial', 'FontSize', 12);

sp5 = subplot (3, 2, 5);
h=surf(x*10^-3,y*10^-3,Turb_GPE7);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
view(0,90);
set(gca, 'FontSize', 9);
box on
title('30-m below maximum operation water level')
ylabel('Y coordinate (km)')
xlabel('X coordinate (km)')
sp5.Position = [sp5.Position(1:2)  1*sp1.Position(3) sp5.Position(4)]...
    + [0 0 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

sp6 = subplot (3, 2, 6);
h=surf(x*10^-3,y*10^-3,Turb_DELFT3D7);
set(h,'edgecolor','none')
caxis([0 0.15])
colormap(jet); 
a1=colorbar;
ylabel(a1,'Horizontal Velocity (m s^{-1})','FontName', 'Arial', 'FontSize', 12,...
    'Rotation',270,'Position', [3.7 0.075 0]);
view(0,90);
set(gca, 'FontSize', 9);
box on
title('30-m below maximum operation water level')
xlabel('X coordinate (km)')
sp6.Position = [sp6.Position(1:2)  1*sp1.Position(3) sp6.Position(4)]...
    + [-0.025 0 0 0];
set(gca,'FontName', 'Arial', 'FontSize', 12);

print(gcf,'turbine.png','-dpng','-r600');  
