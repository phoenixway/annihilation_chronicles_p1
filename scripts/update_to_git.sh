#!/usr/bin/env bash

STUDIO_DIR=~/studio_luisa/

LGREEN="\033[1;32m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${LGREEN}Roman Kozak's adding to git megascript!${NC}"
echo -e "${BLUE}Here we will update already added files in git repository. \nIf u want adding new files, make 'git add blabla' manually before running this script.${NC}"
echo -e "${GREEN}Staging updated indexed files to git...${NC}"
cd $STUDIO_DIR
echo -e "${BLUE}Studio dir is $(pwd)${NC}"
git add -u .
if [ $? != 0 ]
then
    echo -e "${RED}Error: git add failed${NC}"
    exit 1
fi
echo -e "${GREEN}Making commit to git...${NC}"
echo -e "${BLUE}Please, enter commit message: ${NC}\c"
read -e -p "" -i "minor" COMMIT_MESSAGE

git commit -m "${COMMIT_MESSAGE}"
if [ $? != 0 ]
then
    echo -e "${RED}Error: git commit failed${NC}"
    exit 1
fi
echo -e "${GREEN}Trying to git push into remote repository...${NC}"
git push
if [ $? != 0 ]
then
    echo -e "${RED}Error: git push failed${NC}"
    exit 1
else
    echo -e "${GREEN}Git update is successful!${NC}"
fi


