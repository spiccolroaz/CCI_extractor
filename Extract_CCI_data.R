# Aim: To extract remote sensing data from the CCI database according to
# user defined period, extent of the region and variables of interest.
# Reference: Crétaux et al. (2020): ESA Lakes Climate Change Initiative
# (Lakes_cci): Lake products, Version 1.0. Centre for Environmental Data
# Analysis, 08 June 2020. doi:10.5285/3c324bb4ee394d0d876fe2e1db217378.
#
# Created on 01/04/2022 by Sebastiano Piccolroaz, University of Trento
# (Italy)
# Contact: s.piccolroaz@unitn.it
###############################################################################

rm(list = ls(all = T))
graphics.off()

if (!require("zoo")) install.packages("zoo")
if (!require("ncdf4")) install.packages("ncdf4")
if (!require("lubridate")) install.packages("lubridate")
library(zoo)
library(ncdf4)
library(lubridate)


years <- seq(2016, 2016) # full period 15/09/1992-
ny <- length(years)

if (years[1] = 1992) {
  ntime = as.POSIXct(paste0(years[ny], "/12/31")) - as.POSIXct(paste0(years[1], "/01/01")) + 1
} else {
  ntime = as.POSIXct(paste0(years[ny], "/12/31")) - as.POSIXct(paste0(years[1], "/09/15")) + 1
}

ver <- '2.0'      # CCI version: 1.0, 1.1, 2.0

lat = c(45.43, 45.90)
lon = c(10.50, 10.89)
# Lake Garda
# Note: in this case, Lake Idro is also present.

res = 1 / 120
# Resolution of the gridded dataset = 1/120°

lat_range <-
  floor((90 + lat) / res)
lat_range_str <- paste0('[', lat_range[1], ':1:', lat_range[2], ']')

lon_range <-
  floor((180 + lon) / res)
lon_range_str <- paste0('[', lon_range[1], ':1:', lon_range[2], ']')

dimensions=c('time','lat','lon')

cont = 1


for (y in 1:length(years)) {
  for(m in 1:12) {
    print(paste0('Year: ', years[y], ', month:', m))
    for(d in 1:31) {
      eom<-days_in_month(as.Date(paste(years[y], m, d,sep="-"),"%Y-%m-%d") )
      eom<-eom[[1]]
      if (d <= eom){
        
        url = paste0('https://data.cci.ceda.ac.uk/thredds/dodsC/esacci/lakes/data/lake_products/L3S/v', ver, '/',
                     years[y], '/', sprintf("%02d", m), '/ESACCI-LAKES-L3S-LK_PRODUCTS-MERGED-',
                     years[y],  sprintf("%02d", m), sprintf("%02d", d), '-fv', ver, '.nc?',
                     'lat', lat_range_str, ',lon', lon_range_str, ',time[0:1:0],lake_surface_water_temperature[0:1:0]', lat_range_str, lon_range_str, ',',
                     'lswt_quality_level[0:1:0]', lat_range_str, lon_range_str)
        
        info  <- nc_open(url)
        names(info$var)
        
        
        # Create variables and write lat and lon
        if (cont == 1){
          outfile <- paste0('CCI_v', ver, '_', years[1], '-',  years[ny], '.nc')
        }
        
        # Extract the information and write to a netcdf
        # Work in progress...
        
      }
    }
  }
}
