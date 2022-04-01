# CCI_extractor
A matlab script to extract CCI data using OPeNDAP access.

This is a simple matlab script based on the OPeNDAP data access protocol to extract and download data from the ESA Climate Change Initiative (CCI) dataset.
The user can define: 
- the period of interest (years)
- the lake/region of interest (lat/lon extent) 
- the variables of interest (see list below)

The script can be easily translated into other languages (e.g., Python, R). 
Scheduled to be done.

General notes:
- the use of quality flags and uncertainty estimates is always highly recommended
- it may be useful to save daily nc files (as in the original repository) if the region of interest is wide

Contact:
Sebastiano Piccolroaz
University of Trento (Italy)
s.piccolroaz@unitn.it

CCI dataset reference: Crétaux et al. (2020): ESA Lakes Climate Change Initiative (Lakes_cci): Lake products, Version 1.0. Centre for Environmental Data Analysis, 08 June 2020. doi:10.5285/3c324bb4ee394d0d876fe2e1db217378.

Available CCI variables:
- lat
- lon
- time
- lat_bounds
- lon_bounds
- chla_mean
- chla_uncertainty
- turbidity_mean
- turbidity_uncertainty
- lake_surface_water_temperature
- lswt_uncertainty
- lswt_quality_level
- lake_ice_cover
- lake_ice_cover_uncertainty
- water_surface_height_above_reference_datum
- water_surface_height_uncertainty
- lake_surface_water_extent
- lake_surface_water_extent_uncertainty
- Rw900
- Rw900_uncertainty_relative
- Rw900_uncertainty_relative_unbiased
- Rw620
- Rw620_uncertainty_relative
- Rw620_uncertainty_relative_unbiased
- Rw709
- Rw709_uncertainty_relative
- Rw709_uncertainty_relative_unbiased
- Rw885
- Rw885_uncertainty_relative
- Rw885_uncertainty_relative_unbiased
- Rw754
- Rw754_uncertainty_relative
- Rw754_uncertainty_relative_unbiased
- Rw443
- Rw443_uncertainty_relative
- Rw443_uncertainty_relative_unbiased
- Rw681
- Rw681_uncertainty_relative
- Rw681_uncertainty_relative_unbiased
- Rw665
- Rw665_uncertainty_relative
- Rw665_uncertainty_relative_unbiased
- Rw779
- Rw779_uncertainty_relative
- Rw779_uncertainty_relative_unbiased
- Rw560
- Rw560_uncertainty_relative
- Rw560_uncertainty_relative_unbiased
- Rw412
- Rw412_uncertainty_relative
- Rw412_uncertainty_relative_unbiased
- Rw510
- Rw510_uncertainty_relative
- Rw510_uncertainty_relative_unbiased
- Rw490
- Rw490_uncertainty_relative
- Rw490_uncertainty_relative_unbiased
