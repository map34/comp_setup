#!/bin/bash

# fab fetch_auth_dump -u platform
# mysqladmin -h mariadb drop auth -ppass -u root
# mysqladmin -h mariadb drop voxsupads -ppass -u root
# mysqladmin -h mariadb drop cross_service -ppass -u root
# mysqladmin -h mariadb drop tv_inventory -ppass -u root
# mysqladmin -h mariadb create auth -ppass -u root
# mysqladmin -h mariadb create voxsupads -ppass -u root
# mysqladmin -h mariadb create cross_service -ppass -u root
# mysqladmin -h mariadb create tv_inventory -ppass -u root
# mysql -h mariadb -u root -ppass auth < `ls -t *auth.sql | head -n 1`
# rm *auth.sql
# cd db_versioning && alembic upgrade head && cd ..
npm cache clean --force
rm -rf ${HOME}/voxsupFrontend2/node_modules/
rm -rf ${HOME}/.npm/

npm install d3-dsv

rm -rf ${HOME}/.npm/
npm cache clean --force
npm install
