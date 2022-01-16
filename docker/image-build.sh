#/bin/sh
imagewithtag=$1 #Image and with tag argument. eg: mongo:latest
dockerFilePath=$2
image_id=$(docker image inspect $imagewithtag --format={{.Id}})

# Build image if not exists
if [$image_id != '']
then
    docker build -f $dockerFilePath -t $imagewithtag --rm=true .
fi