%% Visualization of posterior distributions
%% Initialization
clc; close all; clear all;
%% Loading BAL-GPE responses
% load prior distributions
load('Prior_distribution_2x10^6.mat');
% load data from model runs
load ('Posterior_Distributions_Run06-51-61.mat');
load ('Posterior_Distributions_Run05-50-51-60.mat');
load ('Posterior_Distributions_Run60_Temp.mat');

%% Visualization of posterior distributions version 01
figure (1)
set(gcf,'Position',[10  50 600  850]);
set(gcf,'Name','string')

% model run 05
subplot(6,3,1)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run05(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(6,3,2)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run05(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(6,3,3)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run05(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 06
subplot(6,3,4)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run06(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(6,3,5)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run06(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(6,3,6)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run06(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 50
subplot(6,3,7)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run50(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(6,3,8)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run50(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(6,3,9)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run50(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 51
subplot(6,3,10)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(6,3,11)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(6,3,12)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run51(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 60
subplot(6,3,13)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run60(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(6,3,14)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run60(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(6,3,15)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 250]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 61
subplot(6,3,16)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(6,3,17)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(6,3,18)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run61(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 250]);
grid on;
set(gca,'XTick',[0:5:30]);


print(gcf,'foo.png','-dpng','-r300');

%% Visualization of posterior distributions version 02
figure (1)
set(gcf,'Position',[10  50 600  850]);
set(gcf,'Name','string')

% model run 06
subplot(3,3,1)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run06(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(3,3,2)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run06(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(3,3,3)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run06(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 51
subplot(3,3,4)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(3,3,5)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(3,3,6)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run51(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);


% model run 61
subplot(3,3,7)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(3,3,8)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(3,3,9)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run61(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 250]);
grid on;
set(gca,'XTick',[0:5:30]);


print(gcf,'foo.png','-dpng','-r300');

%% Visualization of posterior distributions version 03
figure (1)
set(gcf,'Position',[10  50 600  850]);
set(gcf,'Name','string')

% model run 06
subplot(4,3,1)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run06(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(4,3,2)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run06(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeD} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(4,3,3)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run06(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 51
subplot(4,3,4)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(4,3,5)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeD} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(4,3,6)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run51(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 61
subplot(4,3,7)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(4,3,8)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeD} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(4,3,9)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run61(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 250]);
grid on;
set(gca,'XTick',[0:5:30]);

subplot(4,3,10)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
%ylim([0 250]);
grid on;

subplot(4,3,11)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeD} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
%ylim([0 250]);
grid on;

subplot(4,3,12)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
%ylim([0 250]);
grid on;
set(gca,'XTick',[0:5:30]);

print(gcf,'foo.png','-dpng','-r300');

%% Visualization of posterior distributions version 04
figure (1)
set(gcf,'Position',[10  50 600  850]);
set(gcf,'Name','string')

% model run 51
subplot(3,3,1)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(3,3,2)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run51(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeD} [m^2/s]');
%ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 25]);
grid on;

subplot(3,3,3)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run51(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
%ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 25]);
grid on;
set(gca,'XTick',[0:5:30]);

% model run 61
subplot(3,3,4)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(3,3,5)
edges=[0.1:0.1:5];
histogram(Posterior_distribution_Run61(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeD} [m^2/s]');
%ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
ylim([0 250]);
grid on;

subplot(3,3,6)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run61(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
%ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
ylim([0 250]);
grid on;
set(gca,'XTick',[0:5:30]);

subplot(3,3,7)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(1,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeV} [m^2/s]');
ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
%ylim([0 250]);
grid on;

subplot(3,3,8)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(2,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{BeD} [m^2/s]');
%ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([0.1 5]);
%ylim([0 250]);
grid on;

subplot(3,3,9)
edges=[5:0.5:30];
histogram(Posterior_distribution_Run60_Temp(3,:), 20, 'FaceColor',[17 17 17]/255)
xlabel('\omega_{T_{OT}} [°C]');
%ylabel('$\mathrm{Frequency}$','Interpreter','latex')
xlim([5 30]);
%ylim([0 250]);
grid on;
set(gca,'XTick',[0:5:30]);

print(gcf,'foo.png','-dpng','-r300');