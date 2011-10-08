#! /bin/sh
. ../profile/.profile

while getopts r:m:h option
do   case $option in 
     r)  region="$OPTARG";;
     m)  month="$OPTARG";;
     h)  echo "Usage: $0 -r [amr/emea/apj] -m [YYYYmMM] ..." 
         exit 1;;
     esac
done

echo "Region: $region"

if [ "$region" == "amr" ]; then
  profile=$amr_profile
elif [ "$region" == "global" ]; then
  profile=$global_profile
elif [ "$region" == "emea" ]; then
  profile=$emea_profile
elif [ "$region" == "apj" ]; then
  profile=$apj_profile
elif [ "$region" == "us" ]; then
  profile=$us_profile
elif [ "$region" == "nl" ]; then
  profile=$nl_profile
else
  echo "ERROR: Please Input Correct Regional Value amr/emea/apj"
fi

echo "Profile: $profile"
echo "Month: $month"
echo ruby $appdir/lib/run_wt_daily_sem_engine.rb "$region" "$month" "$profile"

ruby $appdir/lib/run_wt_daily_sem_engine.rb "$region" "$month" "$profile"


exit
