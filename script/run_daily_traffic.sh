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

if [ "$region" == "amr" ]; then
  profile=$amr_profile
  echo "Profile: $profile"
elif [ "$region" == "emea" ]; then
  profile=$emea_profile
  echo "Profile: $profile"
elif [ "$region" == "apj" ]; then
  profile=$apj_profile
  echo "Profile: $profile"
elif [ "$region" == "us" ]; then
  profile=$us_profile
  echo "Profile: $profile"
elif [ "$region" == "nl" ]; then
  profile=$nl_profile
  echo "Profile: $profile"
else
  echo "ERROR: Please Input Correct Regional Value amr/emea/apj"
fi

#echo ruby $appdir/lib/run_wt_daily_traffic.rb "$region" "$month" "$profile"

ruby $appdir/lib/run_wt_daily_traffic.rb "$region" "$month" "$profile"


exit
