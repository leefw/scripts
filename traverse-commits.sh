#!/bin/sh

if [ "$1" = "" ]; then
    echo "Missing input git commit range (i.e [HEAD~3..HEAD])"
    exit 1
fi

COMMITS=$(git log --format=%h --reverse $1)
CURRENT_BRANCH=$(git name-rev --name-only HEAD)

LOOP=true
INDEX=0
COMMITS_TOTAL=$(echo "$COMMITS" | wc -w | tr -d '[:space:]')

echo "Travsersing $COMMITS_TOTAL commits"

for COMMIT in $COMMITS 
do
    if [ $LOOP = false ]; then 
        echo "Terminating"
        exit 1
    fi
    
    INDEX=$(expr $INDEX + 1)
    
    echo "Checking out commit '$COMMIT' to new branch of same name ($INDEX/$COMMITS_TOTAL)"

    git checkout -b $COMMIT $COMMIT
    
    COMMIT_MSG=$(git log -1 --pretty=format:%s)
    
    echo "HEAD is at '$COMMIT_MSG'"
    
    read -p "Continue to next commit? [y/n] " input
        
    if [ "$input" = "y" ]; then
        LOOP=true
    else
        LOOP=false
    fi
            
    git checkout $CURRENT_BRANCH
    git branch -d $COMMIT
    
done