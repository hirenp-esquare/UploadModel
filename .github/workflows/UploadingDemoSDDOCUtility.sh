INPUT_SOURCE_FILE=$1
INPUT_DESTINATION_REPO=$2
INPUT_DESTINATION_BRANCH=$3
INPUT_DESTINATION_FOLDER=$4
INPUT_USER_EMAIL=$5
INPUT_USER_NAME=$6
INPUT_COMMIT_MESSAGE=$7
API_TOKEN_GITHUB=$8

if [ -z "$INPUT_SOURCE_FILE" ]
then
  echo "Source file must be defined"
  return -1
fi

if [ -z "$INPUT_DESTINATION_BRANCH" ]
then
  INPUT_DESTINATION_BRANCH=master
fi
OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH"

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email $INPUT_USER_EMAIL
git config --global user.name $INPUT_USER_NAME
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://x-access-token:$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"

if [ ! -z "$INPUT_DESTINATION_BRANCH_CREATE" ]
then
  git checkout -b "$INPUT_DESTINATION_BRANCH_CREATE"
  OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH_CREATE"
fi

echo "Copying contents to git repo"
mkdir -p "$CLONE_DIR/TempSDMDOC"
cp -R $INPUT_SOURCE_FILE "$CLONE_DIR/TempSDMDOC"
cd "$CLONE_DIR"
#mkdir -p $CLONE_DIR/INPUT_DESTINATION_FOLDER
#cp -R $INPUT_SOURCE_FILE "$CLONE_DIR/$INPUT_DESTINATION_FOLDER"
#cd "$CLONE_DIR"

#echo "Before move"
#ls TempSDMDOC

# "Start Rename file for forio model"
#cd "$CLONE_DIR/$INPUT_DESTINATION_FOLDER"
mv TempSDMDOC/cc_*.html $INPUT_DESTINATION_FOLDER/ccsdmdoc.html
mv TempSDMDOC/mm_*.html $INPUT_DESTINATION_FOLDER/mmsdmdoc.html
mv TempSDMDOC/psy_*.html $INPUT_DESTINATION_FOLDER/psysdmdoc.html
mv TempSDMDOC/agg_*.html $INPUT_DESTINATION_FOLDER/aggsdmdoc.html
mv TempSDMDOC/sp_*.html $INPUT_DESTINATION_FOLDER/spsdmdoc.html
#End Rename file for forio model

#echo "Before remove"
#ls TempSDMDOC

# "remove directory"
rm -r TempSDMDOC

#echo "after remove"
#ls TempSDMDOC



if [ -z "$INPUT_COMMIT_MESSAGE" ]
then
  INPUT_COMMIT_MESSAGE="Update from https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}"
fi

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MESSAGE"
  echo "Pushing git commit"
  git push -u origin HEAD:$OUTPUT_BRANCH
else
  echo "No changes detected"
fi
