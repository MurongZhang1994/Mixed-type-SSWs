function [z_wave, A] = wave_analyze(z_ano, lon,lat,N)
%This function is used to do harmonic wave analysis
%  Input:
%   lon & lat : 1-D vector
%   z_ano: 2-D matrix, with lon in 1d and lat in 2d, the zonal mean has
%   been removed already
%   N: wave numbers 1 to N

%   Output:
%   z_wave: 3d matrix, with lon in 1d, lat in 2d, and wave number in 3d. 

for j=1:length(lat) 
       f=z_ano(:,j);
       for k=1:N %% get the first N waves
              a(k)=0; b(k)=0;
              for i=1:length(lon)
                     a(k)=a(k)+f(i)*cos(2*pi*k*i/length(lon));
                     b(k)=b(k)+f(i)*sin(2*pi*k*i/length(lon));
              end
              a(k)=2*a(k)/length(lon);
              b(k)=2*b(k)/length(lon);
              c(k)=sqrt(a(k)^2+b(k)^2);
	          s(k)=c(k)^2/2.0;
	          if (a(k) >0) 	
	                 phase(k)=atan(b(k)/a(k)); 
              elseif (a(k) < 0)
	                 phase(k)=pi+atan(b(k)/a(k));
              else
	          phase(k)=pi/2.0;
              end
       end
       for k=1:N
              for i=1:length(lon)
                   z_wave(i,j,k)=c(k)*cos(2.0*pi*(i*k)/length(lon)-phase(k));
              end
              A(j,k)=c(k)^2;
       end
       
       clear phase a b c
end
end

