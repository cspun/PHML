% This script prepares the javaplex library for use

clc; clear all; close all;

javaaddpath('./javaplex.jar');  %%%%%%%%%%% install path
import edu.stanford.math.plex4.*;

javaaddpath('./plex-viewer.jar'); %%%%%%%%%%% install path
import edu.stanford.math.plex_viewer.*;

% cd './utility';
% addpath(pwd);
% cd '..';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%preallocate 
pdbFiles = dir('CA_*.pdb'); %scan in for pdb files
filename = cell(length(pdbFiles),1); % preallocate
data = cell(length(pdbFiles),1); % preallocate

point_cloud = cell(length(pdbFiles),1); % preallocate
stream=cell(length(pdbFiles),1); % preallocate
persistence = cell(length(pdbFiles),1); % preallocate
intervals = cell(length(pdbFiles),1); % preallocate

for k = 1:length(pdbFiles)
  filename{k} = pdbFiles(k).name;
  scheck=dir(filename{k});
  if scheck.bytes > 0
    data{k} = importdata(filename{k});
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read in the PDB data
    data{k}=pdb2matE(filename{k});  
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

% create the set of points
point_cloud{k} = atom{k};

% create a Vietoris-Rips stream 
stream{k} = api.Plex4.createVietorisRipsStream(point_cloud{k}, max_dimension, max_filtration_value, num_divisions);

% get persistence algorithm over Z/2Z
persistence{k} = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);

% compute the intervals
intervals{k} = persistence{k}.computeIntervals(stream{k});

% plot barcodes
options.max_filtration_value = max_filtration_value;
options.max_dimension = max_dimension - 1;
plot_barcode(intervals{k},options);
% set(gcf,'Position',[200 200 800 650]);

% extract features from barcode intervals
barcodes_extract_tmp=barcodes_extract(intervals{k});%the intervals are not stored
barcode_features_index(k,:)=barcode_features(barcodes_extract_tmp);%store the features for each protein
end

% inserting labels as first column
labels=repelem(1,length(pdbFiles));
barcode_features_labelled=[labels' barcode_features_index];
csvwrite('HAE_Rform.csv',barcode_features_labelled);

