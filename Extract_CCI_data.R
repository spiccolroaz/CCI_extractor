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

if (years[1] == 1992) {
  ntime = as.POSIXct(paste0(years[ny], "/12/31")) - as.POSIXct(paste0(years[1], "/01/01")) + 1
} else {
  ntime = as.POSIXct(paste0(years[ny], "/12/31")) - as.POSIXct(paste0(years[1], "/09/15")) + 1
}

ver <- '2.0'      # CCI version: 1.0, 1.1, 2.0

lat = c(45.43, 45.90)
lon = c(10.50, 10.89)
# Lake Garda
# Note: in this case, Lake Idro is also present

res = 1 / 120
# Resolution of the gridded dataset = 1/120°

lat_range <-
  floor((90 + lat) / res)
lat_range_str <- paste0('[', lat_range[1], ':1:', lat_range[2], ']')

lon_range <-
  floor((180 + lon) / res)
lon_range_str <- paste0('[', lon_range[1], ':1:', lon_range[2], ']')


cont = 1
for (y in 1:length(years)) {
  for(m in 1:12) {
    print(paste0('Year: ', years[y], ', month:', m))
    for(d in 1:31) {
      eom<-days_in_month(as.Date(paste(years[y], m, d,sep="-"),"%Y-%m-%d") )
      eom<-eom[[1]]
      if (d <= eom){
        
        url <- paste0('https://data.cci.ceda.ac.uk/thredds/dodsC/esacci/lakes/data/lake_products/L3S/v', ver, '/',
                     years[y], '/', sprintf("%02d", m), '/ESACCI-LAKES-L3S-LK_PRODUCTS-MERGED-',
                     years[y],  sprintf("%02d", m), sprintf("%02d", d), '-fv', ver, '.nc?',
                     'lat', lat_range_str, ',lon', lon_range_str, ',time[0:1:0],lake_surface_water_temperature[0:1:0]', lat_range_str, lon_range_str, ',',
                     'lswt_quality_level[0:1:0]', lat_range_str, lon_range_str)
        
        info  <- nc_open(url)

        
        # Create variables and write lat and lon
        if (cont == 1){
          variables <- names(info[['var']])
          dimensions <- names(info[['dim']])

          # Initialization
          output_time <- c()
          output_variable <- list()
          dim <-list()
        }
        
        # Time vector
        tmp<-ncvar_get(info,'time')
        output_time[cont] <- tmp
        
        # Variables
        for (variable in variables){
          tmp <-ncvar_get(info,variable)
          output_variable[[variable]][[cont]] <- (tmp)
        }
        
        cont=cont+1;
      }
    }
  }
}


# define dimensions and variables
dimension_list <- list()
dimension_list[["lon"]] <- ncdim_def("lon", info$dim[[3]][["units"]], ncvar_get(info,"lon") )
dimension_list[["lat"]] <- ncdim_def("lat", info$dim[[2]][["units"]], ncvar_get(info,"lat") )
dimension_list[["time"]] <- ncdim_def("time", info$dim[[1]][["units"]], output_time )

# I wanted to make this automatic as coded below but the order of the dimensions was not as required. To be improved.
# dimension_list <- list()
# for (j in 1:info$ndims){
#   dimension <- dimensions[j]
#   if (dimension == "time"){
#     tmp <- output_time 
#   } else {
#     tmp <- ncvar_get(info,dimension)
#   }
#   dimension_list[[dimension]] <- ncdim_def(dimension, info$dim[[j]][["units"]], tmp )
# }

fillvalue=-9999
variable_list <- list()
for (j in 1:info$nvars){
    variable_list[[variables[j]]] = ncvar_def(variables[j],info$var[[j]][["units"]],dimension_list,fillvalue,variables[j],prec="single")
}


# Create the netcdf file and add data to variables 
outfile <- paste0('CCI_v', ver, '_', years[1], '-',  years[ny], '.nc')
ncfile <- nc_create(outfile, variable_list, force_v4=TRUE)
for (j in 1:info$nvars){
  #tmp=array(unlist(output_variable[[variables[j]]]),dim=c(47,58,cont-1))
  tmp<-simplify2array(output_variable[[variables[j]]])
  ncvar_put(ncfile, variable_list[[variables[j]]],tmp)
}
nc_close(ncfile)
