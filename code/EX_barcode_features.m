    function[features]=barcode_features(outmat)
% INPUT:
%   intervals - the matrix with the start and end points for each dimension
% INTERMEDIATE:
%   length - length of intervals for each dimension: an nX(2*dim) array each 
%            appear as columns DIM0_START DIM1_END DIM1_START DIM_1_END
% OUTPUT: each with dim(2) entries each 
%   sum_len - sum up the length of intervals for each dimension
%   mean_len - mean of the intervals for each dimension
%   max1 - selects the longest Betti Bar for dim 0 and 1 ( note: for dim0, 
%          the longest is Inf=NaN
%   max2 - selects the second longest Betti Bar for dim 0 and 1
%   max3 - selects the third longest Betti Bar for dim 0 and 1

    [r,c]=size(outmat);
    filtration_size=14;
    max_filtration_value = filtration_size;
    %perform for each Betti+1=dimension+1=j=1,2,..
    for j = 1:(c/2)
            %length of intervals for each dimension
                len(:,j)=outmat(:,2*j)-outmat(:,2*j-1);
    end
    %the no. of atom is the number of betti0 bars
    natom=length(outmat(:,1));
    %Using len matrix (n by 2 if only dim0 and dim1)
            %Recode Inf as NaN
                len(isinf(len))=NaN;    
            %F3,F11 sum of intervals
                F_3=sum(len(:,1),'omitnan');
                F_11=sum(len(:,2),'omitnan');% max filtration dist is set as 14
            %F4,F12 mean of intervals
                F_4=sum(len(:,1),'omitnan')./sum(len(:,1)~=0,1);
                F_12=sum(len(:,2),'omitnan')./sum(len(:,2)~=0,1);
            %sort the interval lengths in order for each dimension
                [~,indices]=sort(len,'descend');
                %can do a for loop over the nuber of lengthsto identify longest
                %to shortest for each 
                %Assume longest to be INFINITY 
            %F1: second longest Betti 0 bar length
                F_1=max(len(:,1),[],'omitnan');
                %F_1= ordered_len(2,1);
            %F2: third longest Betti 0 bar length
                F_2=max(len(len(:,1)<F_1,1),[],'omitnan');
                %F_2= ordered_len(3,1);
            %F6:longest Betti 1 bar length
                F_6=max(len(:,2),[],'omitnan');
                %F_6=ordered_len(1,2);
            %use the indices from sorting to trace back to the longest
            %betti 1 bar
            %F5:onset value of longest betti 1 bar: row no. is indices(1,2)
                F_5=outmat(indices(1,2),3);
            %F7: smallest onset value of Betti1 bar longer than 1.5A
                l7=find(len(:,2)>1.5,length(len(:,2)));%returns indice of elements that satisfy condition
                F_7=min(outmat(l7,3));
            %F8: Average of middle point values of B1 barslonger than 1.5A
            %divided by number of such intervals
                l8=find(len(:,2)>1.5,length(len(:,2)));
                F_8=mean(0.5*(outmat(l8,3)+outmat(l8,4)));
            %F9:The no. of B1 bars locate at at [4.5,5.5]A
            %divided by number of atoms
                l9=(outmat(:,3)>=4.5)&(outmat(:,4)<=5.5);
                F_9=sum(l9)/natom;
            %F10:The no. of B1 bars locate at [3.5,4.5]A and [5.5,6.5]A
            %divided by no. of atoms
                l10=(outmat(:,3)>=3.5&outmat(:,4)<4.5)|(outmat(:,3)>5.5&outmat(:,4)<=6.5);
                F_10=sum(l10)/natom;
            %F13: The onset of first B2 bars(column 5 of outmat) that end after given
            %number: gives info about birth and deahth of cavities
                l13=find(outmat(:,6)>10,length(outmat(:,6)));
                F_13=outmat(outmat(:,6)==min(outmat(l13,6)),5);
            %Concantanate output features
                features=[F_1,F_2,F_3,F_4,F_5,F_6,F_7,F_8,F_9,F_10,F_11,F_12,F_13];
end
