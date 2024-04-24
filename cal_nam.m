%% calculate NAM index by projecting z_full ano (from Oct to May) onto EOF 1 from Nov to Apr
clear;clc;close all;
%% data import
load('eof_1979-2021_jfmand_new.mat');
load('pc_1979-2021_jfmand_new.mat');
load('z_full_ano_jfmamond.mat');
filepath='D:\Work\XMU\Research-XMU\Identify SPV\data\ERA5_daily_download\Z_full\';
lon=ncread([filepath 'era5_z_full_197901.nc'],'longitude');
lat=ncread([filepath 'era5_z_full_197901.nc'],'latitude');
level=ncread([filepath 'era5_z_full_197901.nc'],'level');
W=sqrt(cosd(lat));
% calculate the mean of var_ano during 11-04 (1:120 163:243)
var_temp=reshape(var_ano(:,:,[1:120 183:243],:),[29,37,181*43]); 
zm=mean(var_temp,3);
%%
for iy=1:size(var_ano,4)
    for id=1:size(var_ano,3)
        for ip=1:size(var_ano,2)
            y=var_ano(:,ip,id,iy)-zm(:,ip); %除去时间序列上的平均值
            y=y.*W;
            if eof_maps(1,ip)>eof_maps(29,ip)
                    eof_maps=-eof_maps;
            end
            x=eof_maps(:,ip);
            x=x.*W;
            p_temp=polyfit(x,y,1);
            p(id,iy,ip)=p_temp(1); clear x y p_temp
        end
    end
end
nam_temp=reshape(p,[243*43,37]);
p_nor=reshape(zscore(nam_temp,0,1),[243,43,37]);

 