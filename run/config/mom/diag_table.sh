#!/bin/bash
# Required variables:
#  $fcst_len
#  $fcst_daily_mean
#  $fcst_otherfiles



# file header
#------------------------------------------------------------
cat <<EOF
OM4_SIS2_cgrid_025
1950 1 1 0 0 0

EOF




#------------------------------------------------------------
# Files needed for data assimilation
#------------------------------------------------------------
if [ "$fcst_dailymean" = 1 ]; then
cat <<EOF

"ocean_daily%4yr%2mo%2dy",     1,"days",1,"days","time",1,"days"
"ocean_daily_da%4yr%2mo%2dy",  1,"days",1,"days","time",1,"days"

'ocean_model', 'temp',     'temp',     'ocean_daily%4yr%2mo%2dy',    'all', 'mean','none',2
'ocean_model', 'salt',     'salt',     'ocean_daily%4yr%2mo%2dy',    'all', 'mean','none',2
'ocean_model', 'ssh',      'ssh',      'ocean_daily%4yr%2mo%2dy',    'all', 'mean','none',2

## TODO, U,V aren't needed by the DA right now, but they will be eventually
#'ocean_model', 'u',        'u',        'ocean_daily%4yr%2mo%2dy',   'all', 'mean','none',2
#'ocean_model', 'v',        'v',        'ocean_daily%4yr%2mo%2dy',   'all', 'mean','none',2

## TODO, just calculate rho from T/S in the DA code?
'ocean_model', 'rhopot0',  'rhopot0',  'ocean_daily_da%4yr%2mo%2dy', 'all', 'mean','none',2

EOF
fi




#------------------------------------------------------------
# other diagnostic files
#------------------------------------------------------------
#"ocean_pentad%4yr%2mo%2dy",    ${fcst_len}, "days", 1, "days", "time", ${fcst_len}, "days"

if [ "$fcst_otherfiles" = 1 ]; then
cat <<EOF

"ocean_pentad%4yr%2mo%2dy",    ${fcst_len}, "days", 1, "days", "time", ${fcst_len}, "days"

# For some weird reason it seems MOM is often putting zeros in for the entire field of
# the first time averaged variable defined in this file (for averaging periods > ~2 days).
#  As a work around I'm just defining a 2D field here that I don't care about, until the bug is fixed.
"ocean_model", "tosga", "ignore_this",  "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2


## state variables
#------------------------------------------------------------
"ocean_model", "u",      "u",        "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "v",      "v",        "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "salt",   "salt",     "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "temp",   "temp",     "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "ssh",    "ssh",      "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2


## wind stress
#------------------------------------------------------------
"ocean_model", "taux",     "taux",     "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "tauy",     "tauy",     "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2


## heat flux
#------------------------------------------------------------
"ocean_model", "sw",               "sw",               "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "lw",               "lw",               "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "latent",           "latent",           "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "sensible",         "sensible",         "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "net_heat_coupler", "net_heat_coupler", "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "heat_added",       "heat_added",       "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2


## salt flux
#------------------------------------------------------------
"ocean_model", "prcme",           "prcme",           "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "evap",            "evap",            "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "salt_flux_added", "salt_flux_added", "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2


## MLD
#------------------------------------------------------------
"ocean_model", "mld_003",   "mld_003",    "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "mld_0125",  "mld_0125",   "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2
"ocean_model", "epbl_h_ml", "epbl_h_ml",  "ocean_pentad%4yr%2mo%2dy",    "all", "mean", "none", 2

EOF
fi