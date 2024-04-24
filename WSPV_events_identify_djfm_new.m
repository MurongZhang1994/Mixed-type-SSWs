%% intro
clear;clc;close all;
%This script is used to identify the events with duration equal or greater
%than 5 days; If the distance between the two events is smaller than 5
%days, we'll take them as one.
% final output is the start/end date of each events, in the form of year
% index and day index.
%% data import
load('iday_iyr_90_new.mat');
matrix(121,42)=0;
%% identify by clustering
%-1-% make a 0-1 matrix
for i=1:length(iday_90_new)
    matrix(iday_90_new(i),iyr_90_new(i))=1;
end
%-2-% using bwconncomp for every single year
for i=1:size(matrix,2)
    conn1{i}=bwconncomp(matrix(:,i));
end
%-3-% check every struct in every year remove all the less than 4 days  event to 0
for i=1:size(matrix,2)
    n=length(conn1{i}.PixelIdxList); % number of clusters
    if n==0
        continue
    else
     for m=1:n
        p=length(conn1{i}.PixelIdxList{m});
        if p<5
            matrix(conn1{i}.PixelIdxList{m},i)=0;
        end
     end
    end
end
 %-4-% merging possible events
 for i=1:size(matrix,2)
    conn2{i}=bwconncomp(matrix(:,i));
 end
for i=1:size(matrix,2)
    n=length(conn2{i}.PixelIdxList); % number of clusters
    if n<=1
        continue
    else
      p1=conn2{i}.PixelIdxList{1};p2=conn2{i}.PixelIdxList{2};
      if p1(end)>p2(1)-6
         matrix(p1(end):p2(1),i)=1;
      end
    end
end
%-5-% derive the final matrix and its start and end date
k=0;yr=[];dy_st=[];dy_en=[];
 for i=1:size(matrix,2)
    conn3{i}=bwconncomp(matrix(:,i));
 end

 for i=1:size(matrix,2)
     n=length(conn3{i}.PixelIdxList); % number of clusters
     if n==0
        continue
     else
        for m=1:n
            k=k+1;
            yr=[yr i];
            dy_st=[dy_st conn3{i}.PixelIdxList{m}(1)];
            dy_en=[dy_en conn3{i}.PixelIdxList{m}(end)];
        end
     end
 end
 %% plot basic features of WSPV envents
 %histogram of duration
 duration=dy_en-dy_st+1;
 figure(1);
 set(gcf,'color','w');
 set(gcf,'position',[200,200,500,300])
 hist(duration,7.5:5:57.5); hold on;
 h = findobj(gca,'Type','patch');
 h.FaceColor = [0.5 0.5 0.5];
% h.EdgeColor = 'w';
 xlim([5 60]);  ylim([0 8]);
 xlabel('Duration/days');
 ylabel('Number of Events');
 grid on;
 set(gca,'FontSize',11);
 plot([mean(duration) mean(duration)],[0 8],'r-','LineWidth',2.0)
 text(20,6, num2str(mean(duration),'%.2f'),'FontSize',12)
 % year vs duration
 year=1980:2021;
 dur_tot(42)=0;
 for n=1:length(yr)     
     dur_tot(yr(n))=dy_en(n)-dy_st(n)+1;
 end

    