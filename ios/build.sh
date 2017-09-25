set -ve
currentPath=$(pwd)
echo "Path:" $currentPath

if [ -f ../version.ver ]; then
    version=$(cat ../version.ver)
else
    version="1.0"
fi
echo "Version:" $version
d1=$(date +%s)
#25.05.2015 16:00 MSK
build=$(expr $d1 / 60 - 23875980)
echo "Build:" $build

sed -E -i .bak "s/\<string\>[0-9]+\.[0-9]+\<\/string\>/<string>$version.$build<\/string>/g" App-Info.plist

pluginVersion=$(cat ../plugin_version.txt)
_pluginVersion=$(echo "$pluginVersion" | sed "s/\./_/g")
sub="@\"$_pluginVersion\";//plugin version. Do not delete this comment"
sed -E -i .bak "s#@\"[0-9]+_[0-9]+_[0-9]+\";//plugin version. Do not delete this comment#$sub#g" Plugin/VungleAds.mm
rm Plugin/VungleAds.mm.bak

[ -f ./VungleCoronaTest.ipa ] && rm ./VungleCoronaTest.ipa

xcodebuild -target VungleCoronaTest -project VungleCoronaTest.xcodeproj clean build OTHER_LDFLAGS="-all_load -ObjC -lz -lobjc -lsqlite3 -lc++"  DEVELOPMENT_TEAM=GTA9LK7P23 PROVISIONING_PROFILE="57d2fc8b-a0f2-459e-90c4-dc697ec1eaa3" CODE_SIGN_IDENTITY="iPhone Distribution: Vungle, Inc." 
xcodebuild -project VungleCoronaTest.xcodeproj -scheme VungleCoronaTest OTHER_LDFLAGS="-all_load -ObjC -lz -lobjc -lsqlite3 -lc++" archive -archivePath ./VungleCoronaTest.xcarchive DEVELOPMENT_TEAM=GTA9LK7P23 PROVISIONING_PROFILE="57d2fc8b-a0f2-459e-90c4-dc697ec1eaa3" CODE_SIGN_IDENTITY="iPhone Distribution: Vungle, Inc." 
xcodebuild -exportArchive -archivePath "./VungleCoronaTest.xcarchive/" -exportPath "." -exportOptionsPlist "./exportOptions.plist" 

#puck -api_token=d6cb4cec883a44a5a39a0ed21a845ff3 -app_id=a63c146c01e7fd8eeebe15fad3dfc269 -submit=auto -download=true -notify=false -open=nothing VungleCoronaTest.ipa
