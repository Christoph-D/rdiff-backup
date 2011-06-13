#!/bin/bash

source_dir=rdiff_backup_test_source

run_test() {
    RDIFF_BACKUP=rdiff-backup
    if [[ ${1-} ]]; then
        RDIFF_BACKUP="rdiff-backup $1"
    fi
    rm -rf "$source_dir" "$source_dir"_rdiff_backup
    mkdir "$source_dir"
    touch "$source_dir/file"{0..1000} "$source_dir/empty"
    echo "Initial backup..."
    time $RDIFF_BACKUP "$source_dir" "$source_dir"_rdiff_backup
    rm "$source_dir/file"*
    sleep 1
    echo -e "\nIncremental backup after deleting all files..."
    time $RDIFF_BACKUP "$source_dir" "$source_dir"_rdiff_backup
    rm -rf "$source_dir" "$source_dir"_rdiff_backup
}

run_test
echo -e "\nNow without fsync."
run_test --no-fsync

exit 0

<<COMMENT
Expected result on a system with slow fsync():

$ ./fsync_test.sh
Initial backup...

real	0m1.155s
user	0m0.420s
sys	0m0.090s

Incremental backup after deleting all files...

real	2m5.187s
user	0m2.200s
sys	0m0.680s

Now without fsync.
Initial backup...

real	0m0.421s
user	0m0.320s
sys	0m0.090s

Incremental backup after deleting all files...

real	0m1.093s
user	0m0.620s
sys	0m0.100s
COMMENT
