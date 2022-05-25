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
% Oladyshkin, S., Mohammadi, F., Kroeker I. and Nowak, W. Bayesian active learning for Gaussian process emulator using information theory. Entropy, X(X), X, 2020,
% Oladyshkin, S. and Nowak, W. The Connection between Bayesian Inference and Information Theory for Model Selection, Information Gain and Experimental Design. Entropy, 21(11), 1081, 2019,

clear all;
close all;
clc;
color=[0 0 1];
load('BME_RE_2E6.mat');
LFS=9; %Litle Font Size
BFS=10; %Big Font Size 
NumberOfPreliminaryTrainings = 1;
P_total = 51;
ActiveLearningLimit = 50;

%% Visualization of Bayesian Active Learning (50 model runs)
figure(1)
set(gca,'Color',[1 1 1])
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[100 500 700 250]);
subplot(1,2,1)
hold on
plot(NumberOfPreliminaryTrainings:P_total,BME(NumberOfPreliminaryTrainings:P_total), 'Color', color);
xlabel('Number of GPE surrogate model runs');
ylabel('$\mathrm{BME}$ ','Interpreter','latex');
xline(51);
grid on;
box on;
set(gca,'FontSize',BFS)
set(gca,'FontSize',LFS)
set(gca,'yscale','log');
xlim([1 NumberOfPreliminaryTrainings+ActiveLearningLimit]);

subplot(1,2,2)
hold on
plot(NumberOfPreliminaryTrainings:P_total,RE(NumberOfPreliminaryTrainings:P_total), 'Color', color);
xlabel('Number of GPE surrogate model runs');
ylabel('$\mathrm{\mathrm{D_{KL}}} \left[ p(\omega\vert\mathbf{y}_*), p(\omega) \right]$','Interpreter','latex');
grid on;
box on;
set(gca,'FontSize',BFS)
set(gca,'FontSize',LFS)
xlim([1 NumberOfPreliminaryTrainings+ActiveLearningLimit]);
ylim([5 10]);
xline(51);

print(gcf,'foo.png','-dpng','-r300');  

%% Specifications second plot
LFS=9; %Litle Font Size
BFS=10; %Big Font Size 
NumberOfPreliminaryTrainings = 1;
P_total = 61;
ActiveLearningLimit = 60;

%% Visualization of Bayesian Active Learning (60 model runs)
figure(2)
set(gca,'Color',[1 1 1])
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[100 500 700 250]);
subplot(1,2,1)
hold on
plot(NumberOfPreliminaryTrainings:P_total,BME(NumberOfPreliminaryTrainings:P_total), 'Color', color);
xlabel('Number of Delft3D model runs');
ylabel('$\mathrm{BME}$ ','Interpreter','latex');
grid on;
box on;
set(gca,'FontSize',BFS)
set(gca,'FontSize',LFS)
set(gca,'yscale','log');
xlim([1 NumberOfPreliminaryTrainings+ActiveLearningLimit]);
xline(51,'--','color',[1 0 0]);

subplot(1,2,2)
hold on
plot(NumberOfPreliminaryTrainings:P_total,RE(NumberOfPreliminaryTrainings:P_total), 'Color', color);
xlabel('Number of Delft3D model runs');
ylabel('$\mathrm{\mathrm{D_{KL}}} \left[ p(\omega\vert\mathbf{y}_*), p(\omega) \right]$','Interpreter','latex');
grid on;
box on;
set(gca,'FontSize',BFS)
set(gca,'FontSize',LFS)
xlim([1 NumberOfPreliminaryTrainings+ActiveLearningLimit]);
ylim([5 10]);
xline(51,'--','color',[1 0 0]);

print(gcf,'foo.png','-dpng','-r300');  

%% load posterior distributions of the two stages of the GPE construction
% Stage 1
load('Visualization_Posterior_51Run.mat', 'Likelihood');
PD_Stage_01=load('Visualization_Posterior_51Run.mat', 'Posterior_distribution');
load('Prior_distribution_2x10^6.mat');

[ii,jj]=ismember(PD_Stage_01.Posterior_distribution(1,:),Prior_distribution(1,:)); 
Posterior_Likelihood_Stage_01=Likelihood(jj(ii));

Lim_S01=1e-238;
[i01,j01]=find(Likelihood>Lim_S01);
Dist_S01 = Prior_distribution(:,j01);
Likelihood_S01 = Likelihood(j01);

% Stage 2
load('Visualization_Posterior_MC2x10e6.mat', 'Likelihood');
PD_Stage_02=load('Visualization_Posterior_MC2x10e6.mat', 'Posterior_distribution');
[ii,jj]=ismember(PD_Stage_02.Posterior_distribution(1,:),Prior_distribution(1,:)); 
Posterior_Likelihood_Stage_02=Likelihood(jj(ii));

Lim_S02=1e-135;
[i02,j02]=find(Likelihood>Lim_S02);
Dist_S02 = Prior_distribution(:,j02);
Likelihood_S02 = Likelihood(j02);

%stage 3
load('Visualization_Posterior_MC2x10e6_Temp.mat', 'Likelihood');
PD_Stage_03=load('Visualization_Posterior_MC2x10e6_Temp.mat', 'Posterior_distribution');
[ii,jj]=ismember(PD_Stage_03.Posterior_distribution(1,:),Prior_distribution(1,:)); 
Posterior_Likelihood_Stage_03=Likelihood(jj(ii));

Lim_S03=1e-135;
[i03,j03]=find(Likelihood>Lim_S03);
Dist_S03 = Prior_distribution(:,j03);
Likelihood_S03 = Likelihood(j03);

%% Visualization of Likelihood values during Bayesian Active Learning
figure(3)
LFS=9; %Litle Font Size
BFS=10; %Big Font Size 
set(gca,'FontSize',BFS)
set(gca,'FontSize',LFS)
set(gca,'Color',[1 1 1])
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[100 100 1250 350]);

subplot(1,3,1)

% scatter3(PD_Stage_01.Posterior_distribution(1,:)', PD_Stage_01.Posterior_distribution(2,:)',...
%     PD_Stage_01.Posterior_distribution(3,:)',Posterior_Likelihood_Stage_01*1e184,Posterior_Likelihood_Stage_01*100);

scatter3(Dist_S01(1,:)', Dist_S01(2,:)',...
    Dist_S01(3,:)',Likelihood_S01*1e234,Likelihood_S01);

colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\omega_{BeV}');
ylabel('\omega_{BeD}');
zlabel('\omega_{T_{OT}}');
ylabel(h,'Weight')
box on;
hold on;
view(110,30);

title({'Combination of the calibration parameters','GPE model - 1^{st} Stage'});

subplot(1,3,2)
% scatter3(PD_Stage_02.Posterior_distribution(1,:)', PD_Stage_02.Posterior_distribution(2,:)',...
%     PD_Stage_02.Posterior_distribution(3,:)',Posterior_Likelihood_Stage_02*1e134,Posterior_Likelihood_Stage_02*100);

scatter3(Dist_S02(1,:)', Dist_S02(2,:)',...
    Dist_S02(3,:)',Likelihood_S02*1e134,Likelihood_S02);


colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\omega_{BeV}');
ylabel('\omega_{BeD}');
zlabel('\omega_{T_{OT}}');
ylabel(h,'Weight')
box on;
hold on;
view(110,30);
title({'Combination of the calibration parameters','GPE model - 2^{nd} Stage'});


subplot(1,3,3)
% scatter3(PD_Stage_02.Posterior_distribution(1,:)', PD_Stage_02.Posterior_distribution(2,:)',...
%     PD_Stage_02.Posterior_distribution(3,:)',Posterior_Likelihood_Stage_02*1e134,Posterior_Likelihood_Stage_02*100);

scatter3(Dist_S03(1,:)', Dist_S03(2,:)',...
    Dist_S03(3,:)',Likelihood_S03*1e29,Likelihood_S03);


colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\omega_{BeV}');
ylabel('\omega_{BeD}');
zlabel('\omega_{T_{OT}}');
ylabel(h,'Weight')
box on;
hold on;
view(110,30);
title({'Combination of the calibration parameters','GPE model - 2^{nd} Stage'});
print(gcf,'foo.png','-dpng','-r300'); 

%% Visualization of Likelihood values during Bayesian Active Learning
figure(3)
LFS=9; %Litle Font Size
BFS=10; %Big Font Size 
set(gca,'FontSize',BFS)
set(gca,'FontSize',LFS)
set(gca,'Color',[1 1 1])
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[100 100 1250 300]);

subplot(1,3,1)

% scatter3(PD_Stage_01.Posterior_distribution(1,:)', PD_Stage_01.Posterior_distribution(2,:)',...
%     PD_Stage_01.Posterior_distribution(3,:)',Posterior_Likelihood_Stage_01*1e184,Posterior_Likelihood_Stage_01*100);

scatter3(Dist_S01(1,:)', Dist_S01(2,:)',...
    Dist_S01(3,:)',Likelihood_S01*1e234,Likelihood_S01);

colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\omega_{BeV}');
ylabel('\omega_{BeD}');
zlabel('\omega_{T_{OT}}');
ylabel(h,'Weight')
box on;
hold on;
view(110,30);

%title({'Combination of the calibration parameters','GPE model - 1^{st} Stage'});

subplot(1,3,2)
% scatter3(PD_Stage_02.Posterior_distribution(1,:)', PD_Stage_02.Posterior_distribution(2,:)',...
%     PD_Stage_02.Posterior_distribution(3,:)',Posterior_Likelihood_Stage_02*1e134,Posterior_Likelihood_Stage_02*100);

scatter3(Dist_S02(1,:)', Dist_S02(2,:)',...
    Dist_S02(3,:)',Likelihood_S02*1e134,Likelihood_S02);


colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\omega_{BeV}');
ylabel('\omega_{BeD}');
zlabel('\omega_{T_{OT}}');
ylabel(h,'Weight')
box on;
hold on;
view(110,30);
%title({'Combination of the calibration parameters','GPE model - 2^{nd} Stage'});


subplot(1,3,3)
% scatter3(PD_Stage_02.Posterior_distribution(1,:)', PD_Stage_02.Posterior_distribution(2,:)',...
%     PD_Stage_02.Posterior_distribution(3,:)',Posterior_Likelihood_Stage_02*1e134,Posterior_Likelihood_Stage_02*100);

scatter3(Dist_S03(1,:)', Dist_S03(2,:)',...
    Dist_S03(3,:)',Likelihood_S03*1e30,Likelihood_S03);


colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\omega_{BeV}');
ylabel('\omega_{BeD}');
zlabel('\omega_{T_{OT}}');
ylabel(h,'Weight')
box on;
hold on;
view(110,30);
%title({'Combination of the calibration parameters','GPE model - 2^{nd} Stage'});
print(gcf,'foo.png','-dpng','-r300'); 