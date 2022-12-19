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
fprintf('\n=> BAL-GPE Toolbox: Initialization ... \n');

%% User Specifications
Num_MD=50; %Number of Runs
ModelDirectory=strcat (sprintf('%02d', Num_MD),'_Run');
FP = 'D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration';

%% Initialization of Prior distribution
N=3; %Number of uncertain parameters
MCsize=2*10.^6; %Sample size of prior distribution

% Construction of the prior distribution

% Prior_distribution_HEV=random('unif',0.1,5,1,MCsize); % Horizontal Eddy Vicosity
% Prior_distribution_HED=random('unif',0.1,5,1,MCsize); % Horizontal Eddy Difussivity
% Prior_distribution_TempBC=random('unif',5,30,1,MCsize); % Temperature Boundary Conditions
% Prior_distribution=[Prior_distribution_HEV;Prior_distribution_HED;Prior_distribution_TempBC];

load('Prior_distribution_2x10^6.mat');

%% Initialization of Model Physical Space and Measurments location
NumberOfMeasurments=165; %Number of Synthetic Measurments
Time=0:1/(NumberOfMeasurments-1):1; %Synthetic Measurment Time Series
PhysicalSpace=struct('index', Time); %Physical Space: X,Y,Z and T
MeasurmentSpace=struct('index', 1:NumberOfMeasurments); % Measurments location in Physical Space

%% Load observations
SBTObs=load('ObservationsSBT');
Observation=SBTObs.Observ'; % 1-20(Temperature observations);
                            % 21-165(HorVel observations)
ObservationLimitTemperature=20;
ObservationLimitHorVel=165;

%% Initialization of Measurement Error and Covariance Error Matrix
MeasurementError_Temp=2; %Initialization of Measurement Error Temperature  
MeasurementError_HorVel=3; %Initialization of Measurement Error Horizontal Vel

CovarianceMatrix=eye(NumberOfMeasurments);
for i=1:NumberOfMeasurments
    % Temperature CovMat
    if(i>=1 && i<=ObservationLimitTemperature)
        CovarianceMatrix(i,i)=MeasurementError_Temp.^2;
    end
    % Horizontal Velocity CovMat
    if(i>=ObservationLimitTemperature+1 && i<=ObservationLimitHorVel)
        CovarianceMatrix(i,i)=MeasurementError_HorVel.^2;
    end
end

%% Initialization of Bayesian Active Learning 
NumberOfPreliminaryTrainings=1; %Number of Trainings prior to Bayesian Active Learning 
ActiveLearningLimit=50; %Number of Iterations for Bayesian Active Learning 
ActiveLearningStrategy='RelativeEntropy'; %Active Learning Strategy: 'BME' | 'RelativeEntropy' | 'Entropy' 
MCsize=10^4; % Re-inilialization of Bayesain sample size
MCsizeAL=10^3; %Active Learning sampling size
DsizeAL=10^3; %Number of Active Learning Sets
AdaptiveDsizeAL='No'; %Adaptive Increasing of Number of Active Learning Sets: 'Yes' | 'No'

%% Run the Bayesian Active Learning for GPE
tic
BALGPE
toc

%% Computation of Monte Carlo reference solution 
ReferenceSolution

%% Visualization of BME, IE and RE during Bayesian active learning
Visualization

fprintf('=> BAL-GPE Toolbox: Task has been successfully completed. \n'); 