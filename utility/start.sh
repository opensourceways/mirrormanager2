#!/usr/bin/bash

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

mm_log_dir=$(pwd)/logs
mkdir -p $mm_log_dir/crawler
sed -i "s|{MM_LOG_DIR}|$mm_log_dir|"  $f

###

log() {
    echo "$(date), $1"
}

secondsOf12h=43200

log "start"

set +e

while true
do
    ./mm2_update-master-directory-list -c ./config/mirrormanager2.cfg --logfile log --delete-directories > /dev/null 2>&1

    # adjust the threads num by env
    threads=${THREADS:-5}

    SECONDS=0

    # avoid the python threads to be blocked by timeout
    timeout -k 10 12h ./mm2_crawler -c config/mirrormanager2.cfg --include-private -t $threads --disable-fedmsg > /dev/null 2>&1

    seconds=$SECONDS
    log "mm2_crawler done after $seconds seconds"

    if [ $seconds -lt $secondsOf12h ]; then
        sleep $(($secondsOf12h - $seconds))
    fi

    log "run again after a short break"
done
