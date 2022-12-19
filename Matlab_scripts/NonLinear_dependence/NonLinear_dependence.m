%% Initialization
clear all;
close all;
clc;

%% load posterior distributions of the two stages of the GPE construction
% Scenario 00
load('Likelihood_scenario00');
load('PD_Scenario_00.mat');
load('Prior_distribution_2x10^6.mat');

[ii,jj]=ismember(PD_Scenario_00.Posterior_distribution(1,:),Prior_distribution(1,:)); 
Posterior_Likelihood_Scenario_00=Likelihood(jj(ii));

Lim_S00=1e-238;
[i00,j00]=find(Likelihood>Lim_S00);
Dist_S00 = Prior_distribution(:,j00);
Likelihood_S00 = Likelihood(j00);

% Scenario 01
load('Likelihood_scenario01');
load('PD_Scenario_01.mat');
[ii,jj]=ismember(PD_Scenario_01.Posterior_distribution(1,:),Prior_distribution(1,:)); 
Posterior_Likelihood_Scenario_01=Likelihood(jj(ii));

Lim_S01=1e-135;
[i01,j01]=find(Likelihood>Lim_S01);
Dist_S01 = Prior_distribution(:,j01);
Likelihood_S01 = Likelihood(j01);

% Scenario 02
load('Likelihood_scenario02');
load('PD_Scenario_02.mat');
[ii,jj]=ismember(PD_Scenario_02.Posterior_distribution(1,:),Prior_distribution(1,:)); 
Posterior_Likelihood_Scenario_02=Likelihood(jj(ii));

Lim_S02=1e-135;
[i02,j02]=find(Likelihood>Lim_S02);
Dist_S02 = Prior_distribution(:,j02);
Likelihood_S02 = Likelihood(j02);

%% Visualization of Likelihood values during Bayesian Active Learning
figure(3)
LFS=9; %Litle Font Size
BFS=10; %Big Font Size 
set(gca,'FontSize',BFS)
set(gca,'FontSize',LFS)
set(gca,'Color',[1 1 1])
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[100 100 1550 350]);

%%%%% Scenario 0 %%%%%
subplot(1,3,1)
scatter3(Dist_S00(1,:)',Dist_S00(2,:)',Dist_S00(3,:)',Likelihood_S00*1e234,Likelihood_S00);

colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\nu_{h}^{back}');
ylabel('\Delta_{h}^{back}');
zlabel('\omega_{T_{tow}}');
ylabel(h,'Weight','FontName', 'Arial', 'FontSize', 12)
box on;
hold on;
view(110,30);
set(gca,'FontName', 'Arial', 'FontSize', 12);

%%%%% Scenario 1 %%%%%
subplot(1,3,2)
scatter3(Dist_S01(1,:)', Dist_S01(2,:)',...
    Dist_S01(3,:)',Likelihood_S01*1e134,Likelihood_S01);


colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\nu_{h}^{back}');
ylabel('\Delta_{h}^{back}');
zlabel('\omega_{T_{tow}}');
ylabel(h,'Weight','FontName', 'Arial', 'FontSize', 12)
box on;
hold on;
view(110,30);
set(gca,'FontName', 'Arial', 'FontSize', 12);

%%%%% Scenario 2 %%%%%
subplot(1,3,3)
scatter3(Dist_S02(1,:)', Dist_S02(2,:)',...
    Dist_S02(3,:)',Likelihood_S02*1e29,Likelihood_S02);


colormap(jet); 
h = colorbar;
xlim([0.1 5]);
ylim([0.1 5]);
zlim([5 30]);
xlabel('\nu_{h}^{back}');
ylabel('\Delta_{h}^{back}');
zlabel('\omega_{T_{tow}}');
ylabel(h,'Weight','FontName', 'Arial', 'FontSize', 12)
box on;
hold on;
view(110,30);
set(gca,'FontName', 'Arial', 'FontSize', 12);
print(gcf,'foo.png','-dpng','-r600'); 
