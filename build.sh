#!/bin/bash

function usage {
    programname=$0;
    echo "usage: $programname ACTION [OPTIONS]"
    echo ""
    echo "Actions:"
    echo "   -a             build all images"
    echo "   -i [image]     build specific image"
    echo ""
    echo "Options:"
    echo "   -r             Recursively builds image and its ancestors starting from base upwards"
    echo "   -x             Destroy existing containers and images and rebuild"
    echo ""
    echo "Examples:"
    echo ""
    echo "  To build all images"
    echo "      $programname -a"
    echo ""
    echo "  To build a specific image"
    echo "      $programname -i sjt-pgsql"
    echo ""
    echo "  To build a specific image and its ancestors"
    echo "      $programname -i sjt-pgsql -r"
    echo ""
    echo "  To destroy any previous builds and build a specific image (for when"
    echo "  you've changed something on the base image)"
    echo "      $programname -i sjt-pgsql -x"
    echo ""
    echo "  To destroy any previous builds and build a specific image (for when"
    echo "  you've changed something on the base image)"
    echo "      $programname -i sjt-pgsql -xr"
    echo ""
}

while getopts "i:axr?" opt;
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
        \?)
         usage;
         exit;
         ;;
    esac
done

if [ ! $image ] && [ ! $allimages ]; then
    echo "either -a or -i must be supplied";
    exit 1;
elif [ $image ] && [ $allimages ]; then
    echo "-a or -i are mutually exclusive";
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