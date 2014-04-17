function user_prefix() {
    local USERNAME=`whoami`
    if [[ "$USERNAME" == "anton" || "$USERNAME" == "antron" ]] ; then
        echo
    else
        echo "$USERNAME "
    fi
}

function repository_directory() {
    DIRECTORY=$(pwd)

    while [ "$DIRECTORY" != / ]
    do
        if [ -d "$DIRECTORY/.git" ]
        then
            echo "$DIRECTORY"
            return
        fi

        DIRECTORY=$(dirname "$DIRECTORY")
    done
}

function stash_name() {
    BRANCH=$(current_branch)
    REGEXP="^stash@\{[0-9]+\}: WIP on $BRANCH"
    echo "$(git stash list | egrep "$REGEXP" | head -n 1 | cut -f 1 -d :)"
}

function repository_affix() {
    REPO_DIRECTORY=$(repository_directory)
    if [ -z "$REPO_DIRECTORY" ]
    then
        return
    fi

    BRANCH=$(current_branch)

    STASH=$(stash_name)
    if [ -n "$STASH" ]
    then
        STASH=" $STASH"
    fi

    DIRTY=$(git status --porcelain)
    if [ -n "$DIRTY" ]
    then
        if [ "$BRANCH" = master ]
        then
            DIRTY=' %K{red}%B*%b%k'
        else
            DIRTY=' *'
        fi
    fi

    echo "$(basename $REPO_DIRECTORY):%B%U$BRANCH%b%u$STASH$DIRTY "
}

function popstash() {
    local REPO_DIRECTORY=$(repository_directory)
    if [ -z "$REPO_DIRECTORY" ]
    then
        return
    fi

    local STASH=$(stash_name)
    if [ -z "$STASH" ]
    then
        return
    fi

    git stash pop $STASH
}

function exit_code_if_not_zero() {
    EXIT_CODE=$?
    if [ $EXIT_CODE != 0 ] ; then
        echo $EXIT_CODE
    fi
}

PROMPT='%F{green}$(repository_affix)%f%F{yellow}%c%f '
RPROMPT='%{$fg[red]%}$(exit_code_if_not_zero)%{$reset_color%}'
