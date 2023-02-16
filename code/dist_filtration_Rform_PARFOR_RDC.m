% This script prepares the javaplex library for use

clc; clear all; close all;


% cd './utility';
% addpath(pwd);
% cd '..';

clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%preallocate 
pdbFiles = dir('CA_*.pdb'); %scan in for pdb files
filename = cell(length(pdbFiles),1); % preallocate
data = cell(length(pdbFiles),1); % preallocate
atom=cell(length(pdbFiles),1);
point_cloud = cell(length(pdbFiles),1); % preallocate
stream=cell(length(pdbFiles),1); % preallocate
persistence = cell(length(pdbFiles),1); % preallocate
intervals = cell(length(pdbFiles),1); % preallocate
barcodes_extract_tmp=cell([],6);
barcode_features_index=cell(length(pdbFiles),13);

%JAR1 = 'C:\Users\lees0159\Documents\MATLAB\PARFOR_testing\javaplex.jar';
%JAR2 ='C:\Users\lees0159\Documents\MATLAB\PARFOR_testing\plex-viewer.jar';

pctRunOnAll javaaddpath({'C:\Users\lees0159\Documents\MATLAB\PARFOR_testing\javaplex.jar'})
%javaaddpath('C:\Users\lees0159\Documents\MATLAB\PARFOR_testing\javaplex.jar');  %%%%%%%%%%% install path
import edu.stanford.math.plex4.api.Plex4;
%javaaddpath('C:\Users\lees0159\Documents\MATLAB\PARFOR_testing\plex-viewer.jar'); %%%%%%%%%%% install path
import edu.stanford.math.plex_viewer.*;
%import edu.stanford.math.plex4.*;
parfor k = 1:length(pdbFiles)
  
  filename{k} = pdbFiles(k).name;
  scheck=dir(filename{k});
  if scheck.bytes > 0
    data{k} = importdata(filename{k});
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read in the PDB data
    data{k}=pdb2matE(filename{k});  
    %atom{k}=data{k}.atom{k};
    %options.filename = 'filename{k}';
    [dim,num]=size(data{k}.X);
    atom{k}(:,1)=data{k}.X;
    atom{k}(:,2)=data{k}.Y;
    atom{k}(:,3)=data{k}.Z;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% initialising values for streams, persistence, intervals    

filtration_size=14;
min_dimension=1;
max_dimension = 3;
max_filtration_value = filtration_size;
num_divisions = 10000;

% create the set of point
point_cloud{k} = atom{k};

%%up to this line is fine!
 
% create a Vietoris-Rips stream ( list out full name: resolved error of
% ambigious api variable name)
stream{k} = edu.stanford.math.plex4.api.Plex4.createVietorisRipsStream( ...
     point_cloud{k}, max_dimension, max_filtration_value, num_divisions);
end 
% % get persistence algorithm over Z/2Z
% persistence{k} = edu.stanford.math.plex4.api.Plex4.getModularSimplicialAlgorithm( ...
%     max_dimension, 2);
% %  
% % % compute the intervals
% intervals{k} = persistence{k}.computeIntervals(stream{k});
% % 
% % % extract features from barcode intervals
% barcodes_extract_tmp=barcodes_extract(intervals{k});%the intervals are not stored
% barcode_features_index(k,:)=barcode_features(barcodes_extract_tmp);%store the features for each protein
% end
% %csvwrite('HAE_Rform_featuresE.csv',barcode_features_index);
%  labels=repelem(1,length(pdbFiles));
%  barcode_features_labelled=[labels' barcode_features_index];
%  csvwrite('HAE_Rform_PARFOR_test.csv',barcode_features_labelled);
% %code to append labels as first column to csv file
% % SPECTF = csvread('HAE_Rform.csv'); % read a csv file
% % labels = SPECTF(:, 1); % labels from the 1st column
% % features = SPECTF(:, 2:end); 
% % features_sparse = sparse(features); % features must be in a sparse matrix
% % libsvmwrite('SPECTFlibsvm.train', labels, features_sparse);
% 
% % for k=1:length(pdbFiles)
% %     barcodes_extract_tmp=TMP_barcodes_extract(intervals{k});
% %     barcode_features_tmp=TMP_barcode_features(barcodes_extract_tmp);
% %     barcode_extract_index(k)=barcodes_extract_tmp;
% %     barcode_features_index(k)=barcode_features_tmp;
% % end
% 
% %  fid = fopen('pdbFilenames.csv','wt');
% %  if fid>0
% %      for k=1:size(newdata,1)
% %          fprintf(fid,'%s,%f\n',newdata{k,:});
% %      end
% %      fclose(fid);
% %  end
