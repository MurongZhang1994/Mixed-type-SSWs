%% Intro
clear;clc;close all;
% this script is used to calculate the polar cap height (PCH) over poleward
% of 65N
%% data import
datapath='D:\Work\XMU\Research-XMU\Identify SPV\data\ERA5_daily_download\Z10_ano_ndjfma\';
yr=1979:2021;

g0=9.80665;                                                                                                                                                  
% lon and lat
lon=ncread('D:\Work\XMU\Research-XMU\Identify SPV\data\ERA5_daily_download\Z10\geopotential_101980_01.nc','lon');
lat=ncread('D:\Work\XMU\Research-XMU\Identify SPV\data\ERA5_daily_download\Z10\geopotential_101980_01.nc','lat');
nlat=find(lat==65);
for iy=2:length(yr)
    for nd=1:181 % 11(-1) 12(-1) 01 02 03 04
        if nd<=61 % nov & dec
            id=nd+120;
            if id<100
                load ([datapath 'z10_ano_' num2str(yr(iy-1))  '0' num2str(id) '.mat']); 
            else
                load ([datapath 'z10_ano_' num2str(yr(iy-1))  num2str(id) '.mat']); 
            end
        else
            id=nd-61;
            if id<10
                load ([datapath 'z10_ano_' num2str(yr(iy)) '00' num2str(id) '.mat']);
            elseif id<100
                load ([datapath 'z10_ano_' num2str(yr(iy))  '0' num2str(id) '.mat']); 
            else
                load ([datapath 'z10_ano_' num2str(yr(iy))  num2str(id) '.mat']); 
            end
        end
        pch(nd,iy-1)=sum(var_daily_ano(:,nlat:end)*cosd(lat(nlat:end)))/sum(cosd(lat(nlat:end)))/1440;
    end
    disp(num2str(yr(iy)))
end
pch=pch/g0;

