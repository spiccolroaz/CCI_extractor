import numpy as np
import pandas as pd 
import netCDF4
import xarray as xr

path = "https://data.cci.ceda.ac.uk/thredds/dodsC/esacci/lakes/data/lake_products/L3S/v2.0/2016/01/ESACCI-LAKES-L3S-LK_PRODUCTS-MERGED-20160101-fv2.0.nc?lat[16251:1:16308],lon[22860:1:22906],time[0:1:0],lake_surface_water_temperature[0:1:0][16251:1:16308][22860:1:22906],lswt_quality_level[0:1:0][16251:1:16308][22860:1:22906]"
ver = '2.0'

start = "2016-01-01"
end = "2017-01-01"
date_range = pd.date_range(start = start , end = end, periods=100)

lat = np.array([45.43, 45.90])
lon = np.array([10.50, 10.89]) # Lake Garda

res = 1 / 120

lat_range = np.floor((90 + lat)/res).astype("int")
lat_range_str = str(lat_range).replace(" ", ":1:")

lon_range = np.floor((90 + lon)/res).astype("int")
lon_range_str = str(lon_range).replace(" ", ":1:")

year = list(map(str, date_range.year))
months = ['{:02d}'.format(month) for month in date_range.month]
days = ['{:02d}'.format(day) for day in date_range.day]

first= True
for date in range(0,len(date_range)):

    path = ('https://data.cci.ceda.ac.uk/thredds/dodsC/esacci/lakes/data/lake_products/L3S/v'+ ver+ '/'
        +year[date]+ '/'+ months[date]+ '/ESACCI-LAKES-L3S-LK_PRODUCTS-MERGED-'
        +year[date]+  months[date]+ days[date]+ '-fv'+ ver+ '.nc?'
        +'lat'+ lat_range_str+ ',lon'+ lon_range_str+ ',time[0:1:0],lake_surface_water_temperature[0:1:0]'
        +lat_range_str + lon_range_str + ','
        +'lswt_quality_level[0:1:0]'+ lat_range_str+ lon_range_str)
    dataset = xr.open_dataset(path)
    if first:
        combined_dataset = dataset
        first = False
    else: 
        combined_dataset = xr.combine_by_coords([combined_dataset, dataset], combine_attrs='override')

outfile = "CCI_v"+ver+"_"+year[0]+"-"+year[-1]+".nc"
nc = netCDF4.Dataset(outfile, mode="w", format='NETCDF4')
nc = dataset
nc.close()

    