#!/bin/bash

while getopts "i:abrx" opt;
do
    case $opt in
        i) 
         image=$OPTARG;
        ;;
        a)
         allimages=1;
        ;;
        x)
         refreshfirst=1;
        ;;
        r)
         recursive=1;
         ;;
    esac
done

if [ ! $image ] && [ ! $allimages ]; then
    echo "either -a or -i must be supplied";
    exit 1;
fi

declare -a availableimages=(sjt-base sjt-cron sjt-azure sjt-pgsql);

declare -a imagesToInstall=();

if [ $allimages ]; then
    imagesToInstall=("${availableimages[@]}");
elif [ ! $recursive ]; then
    if [[ " ${availableimages[@]} " =~ " ${image} " ]]; then
        imagesToInstall[0]=$image;
    else
        echo "The image '$image' specified is not recognised";
        exit 2;
    fi
elif [[ $image = "sjt-azure" ]]; then
    imagesToInstall=(sjt-azure sjt-cron sjt-base);
elif [[ $image = "sjt-pgsql" ]]; then
    imagesToInstall=(sjt-pgsql sjt-cron sjt-base);
elif [[ $image = "sjt-cron" ]]; then
    imagesToInstall=(sjt-cron sjt-base);
elif [[ $image = "sjt-base" ]]; then
    imagesToInstall=(sjt-base);
else
    echo "The image specified is not recognised";
    exit 2;
fi

if [ $refreshfirst ]; then
    for image in "${imagesToInstall[@]}"
    do
        echo "Checking for containers running using $image";
        if [[ $(docker ps -aq -f "ancestor=$image" -f "status=running") ]]; then
            echo "one or more containers is running that relies on existing image, please stop this first";
            exit 3;
        fi

        if [[ $(docker ps -aq -f "ancestor=$image") ]]; then
            echo "Removing containers related to $image";
            docker rm $(docker ps -aq -f "ancestor=$image");
        fi

        if [[ $(docker images -aqf "reference=$image:latest") ]]; then
            echo "Images $image already exists - removing";
            docker rmi $image:latest;
        fi
    done
fi

if [[ $recursive ]] && [[ $(docker images -aqf "dangling=true") ]]; then
    echo "Dangling Images exists - removing";
    docker rmi $(docker images -aqf "dangling=true");
fi

for (( idx=${#imagesToInstall[@]}-1 ; idx>=0 ; idx-- )) ; do
    image="${imagesToInstall[idx]}";
    
    folder="${image:4}";
    cd $folder;
    docker build . -t $image;
    cd ..;
done