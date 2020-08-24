nvar="maximum_t2m"

nvar="minimum_t2m maximum_t2m solar"
#station location
st_list="location_list.txt"
awk '{ print $1 }' ${st_list} > STATION_ID.txt
awk '{ print $2 }' ${st_list} > STATION_Province.txt
awk '{ print $3 }' ${st_list} > STATION_District.txt
awk '{ print $4 }' ${st_list} > STATION_Lat.txt
awk '{ print $5 }' ${st_list} > STATION_Lon.txt

f_sta_id='STATION_ID.txt'
nsta=1
while read line ; do
   stid[$nsta]="$line"
   nsta=$(($nsta+1))
done < $f_sta_id

#
f_sta_province='STATION_Province.txt'
nsta=1
while read line ; do
   stpr[$nsta]="$line"
   nsta=$(($nsta+1))
done < $f_sta_province

#
f_sta_district='STATION_District.txt'
nsta=1
while read line ; do
   stdis[$nsta]="$line"
   nsta=$(($nsta+1))
done < $f_sta_district

#
f_sta_lon='STATION_Lon.txt'
nsta=1
while read line ; do
   stlon[$nsta]="$line"
   nsta=$(($nsta+1))
done < $f_sta_lon

#
f_sta_lat='STATION_Lat.txt'
nsta=1
while read line ; do
   stlat[$nsta]="$line"
   nsta=$(($nsta+1))
done < $f_sta_lat

iend=$(($nsta))

for ivar in ${nvar}; do
    ista=1
    while [ $ista -le $iend ]; do
            STA_id=${stid[$ista]}
            STA_lon=${stlon[$ista]}
            STA_lat=${stlat[$ista]}
            STA_pr=${stpr[$ista]}
            STA_dis=${stdis[$ista]}
            cdo -outputtab,date,value -remapnn,lon=${STA_lon}_lat=${STA_lat} ${ivar}_1981_2019.nc  > output.${ivar}_st${STA_id}_${STA_pr}_${STA_dis}_1981_2019.txt
            sed -i "s|-|  |g" output.${ivar}_st${STA_id}_${STA_pr}_${STA_dis}_1981_2019.txt
            ista=$(($ista+1))
    done
done
