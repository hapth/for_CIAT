nvar="skin_temperature t2m"
idir="/home/hatp/work/CIAT/PEPSI/DATA/ERA5-Land/raw_data"  # change your directory
for ivar in ${nvar}; do
    mkdir maximum_${ivar}
    for iyear in {2019..2019}; do
        cdo daymax ${idir}/${ivar}/${ivar}_${iyear}.nc ${idir}/maximum_${ivar}/maximum_${ivar}_${iyear}.nc
    done
done
