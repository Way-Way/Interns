day=`date +%d%m%Y`

tar cvf listPhotos listPhotos.tar
mv listPhotos.tar listPhotos.$day.tar
gzip listPhotos.$day.tar
python /home/ubuntu/workarea/dev/python/python_aws/python/s3_archiving.py -help
python /home/ubuntu/workarea/dev/python/python_aws/python/s3_archiving.py --job=copy --file=listPhotos.$day.tar.gz  --root=/var/www/alpha.api/ --remoteFolder=export/photo/2013
python /home/ubuntu/workarea/dev/python/python_aws/python/s3_archiving.py --job=list --file=export/photo/2013


