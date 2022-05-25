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

tic

%% Checking the simples of Active Learning 
if (DsizeAL+ActiveLearningLimit)>MCsize %Checking Number of Active Learning Sets
    fprintf('   Warning: Number of Active Learning Sets is too large. \n');
    fprintf('   Action: Number of Active Learning Sets have been automatically decreased. \n');
    DsizeAL=MCsize-ActiveLearningLimit;
end
if MCsizeAL>MCsize %Checking Active Learning sampling size
    fprintf('   Warning: Active Learning sampling size is too small. \n');
    fprintf('   Action: Active Learning sampling size have been automatically decreased. \n');
    MCsizeAL=MCsize;
end

%% Allocatoin of Memory
ResponseSurface=zeros(NumberOfMeasurments,MCsize);
ResponseSurface_Std=zeros(NumberOfMeasurments,MCsize);
Deviation=zeros(NumberOfMeasurments,MCsize);
Weight=zeros(ActiveLearningLimit,MCsize);
BME=zeros(1,ActiveLearningLimit);
RE=zeros(1,ActiveLearningLimit);
IE=zeros(1,ActiveLearningLimit);
AL_ResponseSurface=zeros(1,MCsizeAL);
AL_Deviation=zeros(NumberOfMeasurments,MCsizeAL);
AL_Weight=zeros(1,MCsizeAL); 
AL_RejectionSampling=zeros(1,MCsizeAL);
AL_BME=zeros(1,DsizeAL);
AL_RE=zeros(1,DsizeAL);
AL_IE=zeros(1,DsizeAL);
AL_UniqueIndex=zeros(DsizeAL,1);
LimitDsizeAL=DsizeAL;
Prior_distribution=Prior_distribution(:,NumberOfPreliminaryTrainings+1:NumberOfPreliminaryTrainings+MCsize); 

%% Initialization of Training Points prior to Bayesian Active Learning 
if NumberOfPreliminaryTrainings==1
    TrainingPoints(1,:)=mean(Prior_distribution'); %Training Point
else
    TrainingPoints=Prior_distribution(:,1:NumberOfPreliminaryTrainings)'; %Training Points
end
P=size(TrainingPoints,1); %Initial number of training points

% Save training Points (SCM)
%save(fullfile(FP,ModelDirectory,'BAL_Files','TrainingPoints'),'TrainingPoints');

%% Evaluation of the original physical model and reading of corresponding model outputs
P_total=P; %Current number of training points
ModelOutput=load(fullfile(FP,ModelDirectory,'BAL_Files','Stochastic_ModelObs.mat'));
for i=1:1:P_total
    Output(i,:,:,:,:)=[ModelOutput.Temp_Profile(1:20)', ModelOutput.M_HorVel];
    %Output(i,:,:,:,:)=PhysicalModel(PhysicalSpace,TrainingPoints(i,:));
end

P_total=48;

Num_MD=Num_MD+1;
ModelDirectory=strcat (sprintf('%02d', Num_MD),'_Run');
%ModelOutput=load(fullfile(FP,ModelDirectory,'BAL_Files','Stochastic_ModelObs.mat'));
%Output(P_total+1,:,:,:,:)=[ModelOutput.Temp_Profile(1:20)', ModelOutput.M_HorVel];
load(fullfile(FP,ModelDirectory,'BAL_Files','ModelOutput.mat'))
Output=Output(1:49,:);
A=load(fullfile(FP,ModelDirectory,'BAL_Files','TrainingPoints.mat'));
TrainingPoints=A.TrainingPoints;
%% BAL-GPE Active Learning
%for iteration=P:NumberOfPreliminaryTrainings+ActiveLearningLimit
for iteration=49:NumberOfPreliminaryTrainings+ActiveLearningLimit
   
    %Updating values of current number of training points
    P_total=size(TrainingPoints,1);
    
    %Adaptive increasing of Number of Active Learning Sets
    if strcmp(AdaptiveDsizeAL,'Yes') && iteration<LimitDsizeAL
        DsizeAL=iteration;
    end
    
    %% Computation of the multi-dimensional Response Surface     
    for NofM=MeasurmentSpace.index;
        RS = fitrgp(TrainingPoints,Output(:,NofM),'Basis','constant','FitMethod','exact','PredictMethod','exact');             
        [ResponseSurface(NofM,:), ResponseSurface_Std(NofM,:)]= predict(RS,Prior_distribution');                      
    end
    
    %Save surrogate model results
    save(fullfile(FP,ModelDirectory,'BAL_Files','SurrogateModelResults'),'ResponseSurface','ResponseSurface_Std');
    
    %% Bayesian Updating
    %Deviation of Model from Measurments
    for NofM=MeasurmentSpace.index
        Deviation(NofM,:)=Observation(NofM)-ResponseSurface(NofM,:);
    end
    save(fullfile(FP,ModelDirectory,'BAL_Files','Deviation'),'Deviation');
    %Computation of Likelihood according to the Deviation  
    for i=1:1:MCsize     
        Weight(iteration,i)=1/(sqrt(2*pi)*MeasurementError_Temp*MeasurementError_HorVel)...
            ^NumberOfMeasurments*exp(-0.5*Deviation(:,i)'*inv(CovarianceMatrix)*Deviation(:,i));
    end
    save(fullfile(FP,ModelDirectory,'BAL_Files','Weight'),'Weight');
    %Computation of Bayesian Model Evidence based on RS only  
    BME(iteration)=mean(Weight(iteration,:));
    
    %% Computation of Bayesain Quantities of Interest
    [value, ipost]=find(Weight(iteration,:)/max(Weight(iteration,:))>random('unif',0,1,1,MCsize)); %Rejection Sampling
    CrossEntropy=- mean(log(Weight(iteration,ipost))); %Cross Entropy
    RE(iteration)=-CrossEntropy-log(BME(iteration)); %Bayesian experimental design
    IE(iteration)= - mean(log((1/4.9)*(1/4.9)*(1/25))) - RE(iteration); % Information entropy for uniform prior
    %DensityPriorPost=mvksdensity(Prior_distribution',Prior_distribution(:,ipost)','Bandwidth',0.8); %Density for Cross Entropy of Prior over Posterior
    %IE(iteration)= - mean(log(DensityPriorPost)) - RE(iteration); % Information entropy for uniform prior
    save (fullfile(FP,ModelDirectory,'BAL_Files','BayesianQuantities'),'BME','RE','IE');
    
    %% Bayesain Active Learning: Training Point Selection
    AL_UniqueIndex=find(ismember(Prior_distribution(:,1:DsizeAL+iteration-NumberOfPreliminaryTrainings)',TrainingPoints,'rows')==0);  %Identification of unique design points
    for iAL=1:length(AL_UniqueIndex)                             
        AL_RejectionSampling=random('unif',0,1,1,MCsizeAL); %Sample for Rejection Sampling
        %AL Deviation of Model from Measurments
        MultiGauss=1;
        for NofM=MeasurmentSpace.index; 
            AL_ResponseSurface=random('norm',ResponseSurface(NofM,AL_UniqueIndex(iAL)),ResponseSurface_Std(NofM,AL_UniqueIndex(iAL)),1,MCsizeAL);
            AL_Deviation(NofM,:)=Observation(NofM)-AL_ResponseSurface;            
            MultiGauss=MultiGauss.*normpdf(AL_ResponseSurface,ResponseSurface(NofM,AL_UniqueIndex(iAL)),ResponseSurface_Std(NofM,AL_UniqueIndex(iAL)));
        end
        %AL Likelihood
        for i=1:MCsizeAL     
            AL_Weight(i)=1/(sqrt(2*pi)*MeasurementError_Temp*MeasurementError_HorVel)...
                ^NumberOfMeasurments*exp(-0.5*AL_Deviation(:,i)'*inv(CovarianceMatrix)*AL_Deviation(:,i));
        end
        
        %Active Learning Strategy: 'BME'
        AL_BME(iAL)=mean(AL_Weight); %Computation of AL Bayesian Model Evidence:  
        %Active Learning Strategy: 'RelativeEntropy' or 'Entropy'  
        if strcmp(ActiveLearningStrategy,'RelativeEntropy') || strcmp(ActiveLearningStrategy,'Entropy') 
            [value, ipostal]=find(AL_Weight/max(AL_Weight)>AL_RejectionSampling); %Rejection Sampling
            %Computation of Cross entropy: excluding trivial solution with probablity of 0 
            AL_CrossEntropy=- mean(log(0)); 
            if ~isempty(ipostal)
                AL_CrossEntropy=- mean(log(AL_Weight(ipostal))); %AL Cross Entropy
            end
            %Computation of Relative entropy: excluding trivial solution with probablity of 0 and BME=0
            AL_RE(iAL)=0; 
            if AL_BME(iAL)>0 && ~isempty(ipostal)
                AL_RE(iAL)=-AL_CrossEntropy-log(AL_BME(iAL)); % AL Relative entropy 
            end
        end
        %Active Learning Strategy: 'Entropy'  
        if strcmp(ActiveLearningStrategy,'Entropy')
            %Computation of Information entropy: excluding trivial solution with probablity of 0
            AL_IE(iAL)= - mean(log(0)) - AL_RE(iAL); 
            if ~isempty(ipostal)
                AL_IE(iAL)= - mean(log(MultiGauss(ipostal))) - AL_RE(iAL); % AL Information entropy 
            end
        end
        
    end
    
    %% Active Learning Strategy: 'BME' | 'RelativeEntropy' | 'Entropy'  
    switch ActiveLearningStrategy
        case 'BME'
            [Value,index_AL]=max(AL_BME); %Bayesian model selection: Max BME 
            if max(AL_BME)==0
                fprintf('   Warning Active Learning: all values of Bayesian model evidences equal to 0. \n');        
                fprintf('   Active Learning Action: training point have been selected randomly. \n');
            end
        case 'RelativeEntropy'
            [Value,index_AL]=max(AL_RE); %Bayesian experimental design: Max RE
            if max(AL_RE)==0 %Non Infromative Case
                [Value,index_AL]=max(AL_BME); %Bayesian model selection: Max BME 
                fprintf('   Warning Active Learning: all values of Relative entropies equal to 0. \n');
                fprintf('   Active Learning Action: training point have been selected according Bayesian model evidences. \n');
            end
        case 'Entropy'
            [Value,index_AL]=min(AL_IE); % Information entropy: Min H
            if min(AL_IE)==Inf %Non Infromative Case
                [Value,index_AL]=max(AL_RE); %Bayesian experimental design: Max RE
                fprintf('   Warning Active Learning: all values of Information entropies equal to 0. \n');
                fprintf('   Active Learning Action: training point have been selected according Relative entropy. \n');
            end
            if isinf(min(AL_IE))&& max(AL_RE)==0 %Non Infromative Case
                [Value,index_AL]=max(AL_BME); %Bayesian model selection: Max BME 
                fprintf('   Warning Active Learning: all values of Information and Relative entropies equal to 0. \n');
                fprintf('   Active Learning Action: training point have been selected according Bayesian model evidences. \n');
            end
    end     
    %Selection of new Training Point according Active Learning Criteria
    TrainingPoints(P_total+1,:)=Prior_distribution(:,AL_UniqueIndex(index_AL))';
    
    % Create new directory for the next run
    Num_MD=Num_MD+1;
    ModelDirectory=strcat (sprintf('%02d', Num_MD),'_Run');
    mkdir(fullfile(FP),ModelDirectory);
    mkdir(fullfile(FP,ModelDirectory),'BAL_Files');
    save(fullfile(FP,ModelDirectory,'BAL_Files','TrainingPoints'),'TrainingPoints');
    save(fullfile(FP,ModelDirectory,'BAL_Files','ActiveLearning'),'Value','index_AL');
    %% Evaluation of the original physical model in the new Training point
    ModelOutput=load(fullfile(FP,ModelDirectory,'BAL_Files','Stochastic_ModelObs.mat'));
    Output(P_total+1,:,:,:,:)=[ModelOutput.Temp_Profile(1:20)', ModelOutput.M_HorVel];
    %Output(P_total+1,:,:,:,:)=PhysicalModel(PhysicalSpace,TrainingPoints(P_total+1,:));

    %Progress report 
    fprintf('=> BAL-GPE Toolbox: Active Learning ... '); disp([datestr(now) ' - ' num2str(round(100*(iteration-NumberOfPreliminaryTrainings)/ActiveLearningLimit)) '% completed']);
end

save('BALGPE.mat');