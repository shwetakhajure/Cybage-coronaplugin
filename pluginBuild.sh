set -ve

cd android
./build.plugin.sh ~/Desktop/Android/sdk/
cd ..
cd ios
./build.plugin.sh
cd ..
tar -zcvf plugins.tgz ./plugins
