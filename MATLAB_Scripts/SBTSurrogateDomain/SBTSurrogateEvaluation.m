%% Initialization
close all;
clear all;
clc;

%% Load parameters
load('HorizontalVelocitiesDomain'); % Horizontal Velocity Magnitude in the reservoir domain
load('D:\WAREM\Thesis\00_DELFT3D_Schwarzenbach\10_Models\002_StochasticCalibration\52_Run\BAL_Files\TrainingPoints') % Training points selected

%% Erase zeros
[Row, Col] = find(HORIZONTALVELOCITY==0);
[Row_2, Col_2] = find(HORIZONTALVELOCITY>0);
save('details.mat','Row','Col','Row_2','Col_2','-v7.3');
clear Row; clear Col; clear Row_2; clear Col_2;
HV=HORIZONTALVELOCITY;
clear HORIZONTALVELOCITY;
delete=find(HV(1,:)==0);
HV(:,delete)=[];

save('delete.mat','delete');
clear delete;

%% Physical model space and best model parameters selection
Size_HV=size(HV);
NumberOfMeasurments=Size_HV(2); %Number of Synthetic Measurments
MeasurmentSpace=struct('index', 1:NumberOfMeasurments); % Measurments location in Physical Space
MLTrainingPoints=[4.8305; 1.3774; 26.6346];

%% Computation of the multi-dimensional Response Surface     
for NofM=MeasurmentSpace.index;
    RS = fitrgp(TrainingPoints,HV(:,NofM),'Basis','constant','FitMethod','exact','PredictMethod','exact');             
    [ResponseSurface(NofM,:), ResponseSurface_Std(NofM,:)]= predict(RS,MLTrainingPoints');                      
end

save('SurrogateModelResults_2.mat','ResponseSurface','ResponseSurface_Std');


