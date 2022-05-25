%% Initialization
close all; clear all; clc;

%% Load data and get zero indexes
load('HorizontalVelocitiesDomain'); % Horizontal Velocity Magnitude in the reservoir domain
HV_Domain=HORIZONTALVELOCITY(1,:);
HV_Domain_length=length(HV_Domain);
% Get indexes of 0's and HV values
index_zeros=fnd(HV_Domain==0);
index_vals=find(HV_Domain>0);

clear HORIZONTALVELOCITY;

%% Reconstruction of Matrix
% Reconstruction of vector 1: HV values and zeros
load('SurrogateModelResults_2');
HV_RS=zeros(1,HV_Domain_length);
HV_RS_Std=zeros(1,HV_Domain_length);
HV_RS(1,index_vals)=ResponseSurface';
HV_RS_Std(1,index_vals)=ResponseSurface_Std';
clear ResponseSurface; clear ResponseSurface_Std;
% Reconstruction of vector 2 (TotalVector): Vector 1 and NaN
load('LengthTotalVector');
load('HV_TotalVector_Index');
HV_TotalVectorIndex=HV_index(1,:);
clear HV_index;
RS_TotalVector=NaN(1,Length_HVvector);
RS_TotalVector_Std=NaN(1,Length_HVvector);
RS_TotalVector(HV_TotalVectorIndex)=HV_RS;%Vector to be converted in matrix [145 86 146 27]
RS_TotalVector_Std(HV_TotalVectorIndex)=HV_RS_Std;%Vector to be converted in matrix [193 86 146 27]

% Reconstruction of Matrix 1: time (145h) x HV in vector 
load('HVvector_time');
HVvector_time_size=size(HVvector_time);
M_RS_Vectortime = reshape(RS_TotalVector,HVvector_time_size(1),HVvector_time_size(2));
M_RS_Vectortime_Std = reshape(RS_TotalVector_Std,HVvector_time_size(1),HVvector_time_size(2));

clear RS_TotalVector; clear RS_TotalVector_Std;

%Recosntrunction of total matrix
for i=1:145
    HV_RSMatrix(i,:,:,:)=reshape(M_RS_Vectortime(:,i),86,146,27);
    HV_RSMatrix_Std(i,:,:,:)=reshape(M_RS_Vectortime_Std(:,i),86,146,27);
end

save('SurrogateMatrix_2.mat','HV_RSMatrix','HV_RSMatrix_Std');



