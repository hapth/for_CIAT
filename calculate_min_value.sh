nvar="skin_temperature"
#"skin_temperature t2m"
idir="/home/hatp/work/CIAT/PEPSI/DATA/ERA5-Land/raw_data"
for ivar in ${nvar}; do
    mkdir minimum_${ivar}
    for iyear in {1981..2018}; do
        cdo daymin ${idir}/${ivar}/${ivar}_${iyear}.nc ${idir}/minimum_${ivar}/minimum_${ivar}_${iyear}.nc
    done
done
