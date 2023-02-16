% This script prepares the javaplex library for use

clc; clear all; close all;

cd './RDC-TDA-INTERVALS-RIPS20/'
files = dir('*.csv');
intervalFile = cell(numel(files),1);
 for i = 1:numel(files)  % Could be parfor
    intervalFile{i} = csvread(files(i).name, 1);
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%preallocate 
% files = dir('./RDC-TDA-INTERVALS-RIPS20/*.csv'); %scan in for interval file
% filename=sprintf('./RDC-TDA-INTERVALS-RIPS20/%s',files.name);
cd 'C:\Users\lees0159\Documents\Rfiles-SEQ-AB\stageII-similarity-computation\RDC-TDA_RIPS20-FEATURES-BN\RDC-TDA-INTERVALS-RIPS20'
files = dir('*.csv');
%initialise variables
intervalFile = cell(numel(files),1);
%barcode_features_index=cell(length(files),12);
barcode_features_index=[];% do not initialise as cell: output is double

for k = 1:numel(files)
    %read in Intervals
    %the 1 is to say skip reading in the first row of headers
    intervalFile{k} = csvread(files(k).name, 1);
end
cd '..'
parfor k=1:numel(files)
    interval_tmp=cell2mat(intervalFile(k));
    % extract features from barcode intervals
    % debugged: store the output doubles into the matrix for every row
    % k=1:450
    barcode_features_index(k,:)=barcode_features(interval_tmp);
    %barcode_features_index{k,:}=barcode_features(interval_tmp);%store the features for each protein
end
% %saving indexes of barcode plots to corresponding protein files
% filePh=fopen('CA_alpha_imglist1610.txt','w');
% fprintf(filePh,'%s\n',filename{:});
% fclose(filePh);

% labels=repelem(1,length(pdbFiles));
% barcode_features_labelled=[labels' barcode_features_index];
% 
% %creating sparse dataset: replace NaN with 0
% barcodes_0=barcode_features_index;
% barcodes_0(isnan(barcodes_0)==1)=0;
% barcode_0_labelled=[labels' barcodes_0];

%write into datafile
csvwrite('RDC_TDA_RIPS20_FEATURES.csv',barcode_features_index);
%write the filenames used for record purpose:
fid = fopen('RDC_TDA_RIPS20_FEATURES_FILENAMES.csv', 'w') ;
 if fid>0
     for k=1:size(files,1)
         fprintf(fid,'%s\n',files(k).name);
     end
     fclose(fid);
 end

fid = fopen('RDC_TDA_RIPS20_FEATURES_FILENAMES.csv', 'w') ;
 fprintf(fid, '%s,', file.name{1,1:end-1}) ;
 fprintf(fid, '%s\n', c{1,end}) ;
 fclose(fid) ;
csvwrite('RDC_TDA_RIPS20_FEATURES_FILENAMES.csv',files.name{:});


