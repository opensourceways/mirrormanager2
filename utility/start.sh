#!/bin/sh

cd $(dirname $0)

###

f=config/mirrormanager2.cfg

prefix=$UMDL_PREFIX
if [ "$(basename $prefix)" != "openeuler" ]; then
    echo "invalid UMDL_PREFIX: $UMDL_PREFIX"
    exit 1
fi
prefix=$(dirname $prefix)

sed -i "s|{UMDL_PREFIX}|$prefix|"  $f
sed -i "s|{DB_URL}|$DB_URL|"  $f
sed -i "s|{SECRET_KEY}|$SECRET_KEY|"  $f
sed -i "s|{PASSWORD_SEED}|$PASSWORD_SEED|"  $f

mm_log_dir=$(pwd)/utility/logs
mkdir -p $mm_log_dir/crawler
sed -i "s|{MM_LOG_DIR}|$mm_log_dir|"  $f

###

while true
do
    ./mm2_update-master-directory-list -c ./config/mirrormanager2.cfg --logfile log --delete-directories > /dev/null 2>&1

    ./mm2_crawler -c config/mirrormanager2.cfg --include-private -t 10 --disable-fedmsg > /dev/null 2>&1

    # sleep 6 hours
    sleep 21600

    echo "run again after a short break"
done
