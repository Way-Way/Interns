scp -i ../../WayWayKeys/ec2/key.pem     -rp  alpha.api ubuntu@dev.omblabs.org:/var/www/
scp -i ../../WayWayKeys/ec2/key.pem alpha.api/menu.php ubuntu@dev.omblabs.org:/var/www/alpha.api
scp -i ../../WayWayKeys/ec2/key.pem alpha.api/check.php ubuntu@dev.omblabs.org:/var/www/alpha.api
scp -i ../../WayWayKeys/ec2/key.pem alpha.api/metrics.php ubuntu@dev.omblabs.org:/var/www/alpha.api
scp -i ../../WayWayKeys/ec2/key.pem -rp  alpha.api/city.php ubuntu@dev.omblabs.org:/var/www/alpha.api
scp -i ../../WayWayKeys/ec2/key.pem -rp  alpha.api/query.php ubuntu@dev.omblabs.org:/var/www/alpha.api
scp -i ../../WayWayKeys/ec2/key.pem alpha.api/troubleshooting_all.php ubuntu@dev.omblabs.org:/var/www/alpha.api
scp -i ../../WayWayKeys/ec2/key.pem -rp  alpha.api/process ubuntu@dev.omblabs.org:/var/www/alpha.api

