%% Visualization of posterior distributions
clc; close all; clear all;

%% Loading BAL-GPE responses
% load data from model runs
load ('Posterior_distribution_Scenario00.mat');
load ('Posterior_distribution_Scenario01.mat');
load ('Posterior_distribution_Scenario02.mat');

%% Visualization of posterior distributions version 04
figure (1)
set(gcf,'Position',[0  0 750 1050]);
set(gcf,'Name','string')

% model run 51
subplot(3,3,1)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\nu_{h}^{back} (m^2/s)', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Frequency','FontName', 'Arial', 'FontSize', 12)
xlim([0.1 5]);
ylim([0 25]);
grid on;
set(gca,'FontName', 'Arial', 'FontSize', 12);

subplot(3,3,2)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\Delta_{h}^{back} (m^2/s)','FontName', 'Arial', 'FontSize', 12);
xlim([0.1 5]);
ylim([0 25]);
grid on;
set(gca,'FontName', 'Arial', 'FontSize', 12);

subplot(3,3,3)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run51(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{tow}} (°C)','FontName', 'Arial', 'FontSize', 12);
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30],'FontName', 'Arial', 'FontSize', 12);

% model run 61
subplot(3,3,4)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\nu_{h}^{back} (m^2/s)','FontName', 'Arial', 'FontSize', 12);
ylabel('Frequency','FontName', 'Arial', 'FontSize', 12)
xlim([0.1 5]);
ylim([0 250]);
grid on;
set(gca,'FontName', 'Arial', 'FontSize', 12);

subplot(3,3,5)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\Delta_{h}^{back} (m^2/s)','FontName', 'Arial', 'FontSize', 12);
xlim([0.1 5]);
ylim([0 250]);
grid on;
set(gca,'FontName', 'Arial', 'FontSize', 12);

subplot(3,3,6)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run61(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{tow}} (°C)','FontName', 'Arial', 'FontSize', 12);
xlim([5 30]);
ylim([0 250]);
grid on;
set(gca,'XTick',[0:5:30], 'FontName', 'Arial', 'FontSize', 12);

subplot(3,3,7)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\nu_{h}^{back} (m^2/s)');
ylabel('Frequency','FontName', 'Arial', 'FontSize', 12)
xlim([0.1 5]);
grid on;
set(gca,'FontName', 'Arial', 'FontSize', 12);

subplot(3,3,8)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\Delta_{h}^{back} (m^2/s)','FontName', 'Arial', 'FontSize', 12);
xlim([0.1 5]);
grid on;
set(gca,'FontName', 'Arial', 'FontSize', 12);

subplot(3,3,9)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{tow}} (°C)','FontName', 'Arial', 'FontSize', 12);
xlim([5 30]);
grid on;
set(gca,'XTick',[0:5:30],'FontName', 'Arial', 'FontSize', 12);

print(gcf,'Posteriors.png','-dpng','-r600');