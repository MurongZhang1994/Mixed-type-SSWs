function WAFz= WAFz_cal(z_ano, t_ano, v_ano, t, z, lon, lat, level)
%This function is used to calculate the vertical component of the plumb
%flux
%   z(geopotential), t (K),v(m/s)_ano are 3-D matrix for zonal mean based ano.
%   while t and z are raw data
%   lon(degree), lat(degree), level(hPa) are 1-D 
%% constant
kapa=0.286;
omega=7.292e-5;
a=6371000;
g0=9.80665;

%% calculate different variables
T_avg=squeeze(nanmean(nanmean(t(:,1:find(lat==20),:)))); % Plumb 1985
Z_avg=squeeze(nanmean(nanmean(z(:,1:find(lat==20),:))))/g0;
for ip=1:length(level)
    S1= dTdz(T_avg,Z_avg); % Z_avg or Z?
    S2=kapa*T_avg(ip)/(-Z_avg(ip)/log(double(level(ip))/1000.0)); % lnp in Pa or hPa % for specifc level
    for j=1:length(lat)
        A1=2*omega*sind(lat(j))/(S1(ip)+S2);
        A3=t_ano(:,j,ip).*z_ano(:,j,ip);
        grdA3lon = dAdlon(A3,lon); % for specifc latitude and level
        A4=1/(2*omega*a*sind(2*lat(j)));
        A2=v_ano(:,j,ip).*t_ano(:,j,ip);
        for i=1:length(lon)
            WAFz(i,j,ip)=double(level(ip))/1000*cosd(lat(j))*A1*(A2(i)-A4*grdA3lon(i));
        end
        clear A1 A2 A3 A4 grdA3lon
    end
    clear S1 S2
end

end

