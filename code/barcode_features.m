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
    filtration_size=16;
    max_filtration_value = filtration_size;
    %perform for each Betti+1=dimension+1=j=1,2,..
    for j = 1:(c/2)
            %length of intervals for each dimension
                len(:,j)=outmat(:,2*j)-outmat(:,2*j-1);
    end
    %the no. of atom is the number of betti0 bars
    natom=length(outmat(:,1));
%     betti0_len=len(:,1);
%     betti1_len=len(:,2);
%     betti2_len=len(:,3);
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
                [ordered_len,indices]=sort(len,'descend');
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
                %l9=find((outmat(:,3)>=4.5&outmat(:,4)<=5.5),length(outmat(:,3));
                %no_B1_4555=length(l);
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
                %each output in feature has one entry per dimension
                %ie concantate sum_len(dim0) sum_len(dim1)
                %mean_len(dim0)...
                features=[F_1,F_2,F_3,F_4,F_5,F_6,F_7,F_8,F_9,F_10,F_11,F_12,F_13];
end
%% manual testing for interval{1} only
%A is the length matrix corr to each interval in each dimension
%TRY is the original start end matrix for dim 0, dim1 and dim2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRY=barcodes_extract(intervals{1});
%A(:,3)=TRY(:,6)-TRY(:,5);%Betti 2 interval lengths
%A(:,2)=TRY(:,4)-TRY(:,3);%Betti 1 interval lengths
%A(:,1)=TRY(:,2)-TRY(:,1);% Betti 0 interval lengths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A(isinf(A))=NaN;
%computing F3, F4 manually-exlcude last row of the longest bar to Inf
%F3_1=sum(A(1:286,1);
%F4_1sum(A(1:286,1))/286;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[TMP_ordered_len_1,TMP_indice_1]=sort(A,'descend');
%F6_1=max(A(:,2));%OR
%based on the TMP_indice_1 ordering, it shows that indice/ interval 218
%gives the longest betti 1 bar
%F5_1=TRY(218,3);%corresponds to the onset of corr B1 bar( col 3 of TRY)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%l7_1=find(A(:,2)>1.5,length(A(:,2)))%returns indice of intervals with
%length >1.5 for Betti 1 bars  ie col 2 of A
%F7_1=min(TRY(l7_1,3))% subsets TRY with rows corr to entries/ indices
%smallest onset index is bar index 226 whose length is [4.39180000000000]
%and refering to TRY matrix,the 3rd column entry for row 226 is [3.85280000000000]
%in list l7_1 , choose only column 3 which corr to the onset of B1 bars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%l8_1=l7_1;   %find(len(:,2)>1.5,length(len(:,2))) 
%F8_1=mean(0.5*(TRY(l8_1,3)+TRY(l8_1,4)));
%should be the same as summing up the mid point values and divide by
%length(l8_1)=21( entries/indices)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%l9_1 returns the logical of indices satisfying the criteria of interval
%between [4.5,5.5]
%l9_1=(TRY(:,3)>=4.5)&(TRY(:,4)<=5.5);
% sum(l9_1);%132
% divide the sum by the number of atoms ie the number of betti 0 bars=length(TRY(:,1))
% sum(l9_1)/287;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%similar identify the indices satisfying the condition of Betti 1 intervals
%in [3.5,4.5) and (5.5,6.5]
%l10_1=(TRY(:,3)>=3.5&TRY(:,4)<4.5)|(TRY(:,3)>5.5&TRY(:,4)<=6.5);
%TRY(l10_1==1,4);  %check explicitly that indices satisfy criteria
%TRY(l10_1==1,4);  %check explicitly
%sum(l10_1);%there are only 12 bars satisfying: none in interval [3.5,4.5)
%sum(l10_1)/287;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%F11_1=sum(A(:,2));  %sum up all the B1 bar lengths
%F12_1=sum(A(:,2))./sum(A(:,2)~=0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find indices of intervals of Betti2 bars that ends after given number
%10:saved as l13_1
%identify the first(earliest end) bar that ends out of l13_1 : using min(TRY(l13_1,6))
%Find that bar's corresponding start/ onset: 
%TRY(TRY(:,6)==min(TRY(l13_1,6)),5);     %identify the row/ index with the
%earliest end in l12_1 list, output the start of this interval( col 5 of
%TRY)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXTRAS:
%sum(A,'omitnan')./sum(A~=0,1)% columnwise mean involving only non zero rows
%sum(A~=0,1) %gives 287   226 which is the number of non 0 rows for B0 and
%B1 respectively : col 1 and 2
%min(TRY(k,3))%output the corresponding start value in Betti1
%filter by length>1.5 and sort by ascending to find indice
%[ordered_A,indices]=sort(A(A(:,2)>1.5,2),'ascend')
%smallest_onet=A(indices(1));
% A_long=ordered_A((ordered_A>1.5))%filter only Betti1 lengths longer than 1.5A
%mean_len(j)=mean(length(length<max_filtration_value))
            %colMea(j)=sum(length(length<max_filtration_value),1)./sum(length(length<max_filtration_value)~=0,1)
            %second_max(j)=sort(length(j),'descend')
