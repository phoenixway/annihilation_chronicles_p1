#!/usr/bin/env bash

# зробити простий архів з датою і зберегти на флешку
# зробити клон git репозиторія на флешці або bundle
# зберегти туди ж пояснення що там що і як це використовувати, як ці архіви і бекапи відкривати

BLUE="\033[0;34m"
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"
LGREEN="\033[1;32m"

now=`date +"%m-%d-%Y"`
CURRENT_DIR=`pwd`
STUDIO_DIR=~/studio_luisa/

echo -e "${LGREEN}Roman Kozak's update to flashcard megascript!${NC}"


get_abs_filename() {
  # $1 : relative filename
  filename=$1
  parentdir=$(dirname "${filename}")

  if [ -d "${filename}" ]; then
      echo "$(cd "${filename}" && pwd)"
  elif [ -d "${parentdir}" ]; then
    echo "$(cd "${parentdir}" && pwd)/$(basename "${filename}")"
  fi
}

while getopts d:ab flag
do
    case $flag in
        d) DEST_ARG=${OPTARG} ;;
        b) IS_BUNDLE='true' ;;
        a) IS_ARCH='true' ;;
    esac
done

if [ -z "$IS_BUNDLE" ] && [ -z "$IS_ARCH" ]
then
    echo -e "${RED}Error: no action specified${NC}"
    exit 1
fi

echo -e "${BLUE}Studio source directory is '${STUDIO_DIR}'.${NC}"

if [ -z "$DEST_ARG" ]
then
      DESTINATION=/media/roman/39DCE6C60F6BEF72
else
      DESTINATION=$(get_abs_filename $DEST_ARG)
fi
if [ ! -d "$DESTINATION" ]; then
    echo -e "${RED}Studio destination directory is not exist.${NC}"
    exit 1
else
    echo -e "${BLUE}Studio destination directory is '${DESTINATION}'.${NC}"
fi

cd $STUDIO_DIR
OUTPUT_DIR=${DESTINATION}/studio/archives
if [ ! -d "${OUTPUT_DIR}" ]; then
    mkdir -p "${OUTPUT_DIR}"
fi

echo -e "${BLUE}Archives will be saved to '${OUTPUT_DIR}'.${NC}"

save_archive() {    
    local OUTPUT_NAME=${OUTPUT_DIR}/romankozak-archive-$now.zip 
    echo -e "${GREEN}Creating archive $OUTPUT_NAME...${NC}"
    git archive --format zip --output ${OUTPUT_NAME}  HEAD
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Archive created.${NC}"
    else
        echo -e "${RED}Archive creation failed.${NC}"
    fi
    if [[ -z ${OUTPUT_NAME} ]]; then
        echo -e "${RED}Error: no archive file${NC}"
        exit 1
    else
        echo -e "${GREEN}Archive file exists!${NC}"
    fi
}

save_git_bundle() {
    echo -e "${GREEN}Creating git bundle...${NC}"
    cd ${STUDIO_DIR}/..
    local TEMP_NAME=romankozak-gitbundle-$now
    local OUTPUT_DIR=${DESTINATION}/studio/archives/
    if [ -d "${TEMP_NAME}" ]; then
        rm -fR "${TEMP_NAME}"
    fi
    git clone $STUDIO_DIR ${OUTPUT_DIR}${TEMP_NAME}
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Git bundle created.${NC}"
    else
        echo -e "${RED}Git bundle creation failed.${NC}"
        exit 1
    fi
    if [[ -z "${OUTPUT_DIR}${TEMP_NAME}" ]]; then
        echo -e "${RED}Error: git bundle folder is missing${NC}"
        exit 11
    else
        echo -e "${GREEN}Git bundle exists!${NC}"
    fi
}

if [ -n "$IS_ARCH" ]; then
    save_archive
fi
if [ -n "$IS_BUNDLE" ]; then
    save_git_bundle
fi
cd ${CURRENT_DIR}
