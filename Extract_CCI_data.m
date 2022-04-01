% Aim: To extract remote sensing data from the CCI database according to
% user defined period, extent of the region and variables of interest.
% Reference: Crétaux et al. (2020): ESA Lakes Climate Change Initiative
% (Lakes_cci): Lake products, Version 1.0. Centre for Environmental Data
% Analysis, 08 June 2020. doi:10.5285/3c324bb4ee394d0d876fe2e1db217378.
%
% Created on 23/03/2022 by Sebastiano Piccolroaz, University of Trento
% (Italy)
% Contact: s.piccolroaz@unitn.it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

years=[2016:2016]; % full period 15/09/1992-31/12/2019
if years(1)~=1992
    ntime=datenum([years(end) 12 31]) - datenum([years(1) 1 1]) + 1;
else
    ntime=datenum([years(end) 12 31]) - datenum([1992 09 15]) + 1;
end

ver='2.0';      % CCI version: 1.0, 1.1, 2.0

lat=[45.43 45.90]; lon=[10.50 10.89]; % Lake Garda
% Note: in this case, Lake Idro is also present.

res=1/120;                            % Resolution of the gridded dataset = 1/120°

lat_range=floor((90+lat)/res); lat_range_str=['[',num2str(lat_range(1)),':1:',num2str(lat_range(2)),']'];
lon_range=floor((180+lon)/res); lon_range_str=['[',num2str(lon_range(1)),':1:',num2str(lon_range(2)),']'];

cont=1;
for y=1:length(years)
    for m=1:12
        disp(['Year: ' num2str(years(y)) ' , month:' num2str(m)])
        for d=1:31
            if d<=eomday(years(y),m)
                url=['https://data.cci.ceda.ac.uk/thredds/dodsC/esacci/lakes/data/lake_products/L3S/v' ver '/'...
                    num2str(years(y)) '/' num2str(m,'%02u') '/ESACCI-LAKES-L3S-LK_PRODUCTS-MERGED-' ...
                    num2str(years(y)) num2str(m,'%02u') num2str(d,'%02u') '-fv' ver '.nc?'...
                    'lat' lat_range_str ',lon' lon_range_str ',time[0:1:0],lake_surface_water_temperature[0:1:0]' lat_range_str lon_range_str ','...
                    'lswt_quality_level[0:1:0]' lat_range_str lon_range_str];
                info = ncinfo(url);
                               
                % Create variables and write lat and lon
                if cont==1
                    outfile=['CCI_v' ver '_' num2str(years(1)) '-'  num2str(years(end)) '.nc'];
                    for i=1:3
                        tmp = ncread(url, info.Dimensions(i).Name);
                        if strcmp(info.Dimensions(i).Name,'time')
                            nccreate(outfile,info.Dimensions(i).Name,'Dimensions',{info.Dimensions(i).Name,1,ntime,},'DeflateLevel',7) ;
                        else
                            nccreate(outfile,info.Dimensions(i).Name,'Dimensions',{info.Dimensions(i).Name,1,info.Dimensions(i).Length,},'DeflateLevel',7) ;
                            ncwrite(outfile,info.Dimensions(i).Name,tmp) ;
                        end
                    end
                    
                    for i=4:length(info.Variables)
                        nccreate(outfile,info.Variables(i).Name,'Dimensions',{'lon','lat','time'},'DeflateLevel',7) ;
                    end
                end
                
                % Define the time
                time(cont)=datenum([years(y) m d]);
                
                ncwrite(outfile,'time',time(cont),cont); % time in matlab format datenum (original in seconds since 1970-01-01
                
                % Write the selected variables
                for i=4:length(info.Variables)
                    tmp = ncread(url, info.Variables(i).Name);
                    ncwrite(outfile,info.Variables(i).Name,tmp,[1 1 cont]) ;
                end
                
                cont=cont+1;
            end
        end
    end
end
