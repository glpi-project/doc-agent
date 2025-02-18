#! /bin/bash

let FORCE=0 REBASE=0 PUSH=1 NIGHTLY=0

while [ -n "$1" ]
do
    case "$1" in
        --help)
            echo "$0 [--help] [--force] [--rebase] [--no-push|--dry-run] nightly|<VERSION>"
            exit 0
            ;;
        --force)
            let FORCE=1
            ;;
        --rebase)
            let REBASE=1
            ;;
        --no-push|--dry-run)
            let PUSH=0
            ;;
        nightly)
            let NIGHTLY=1
            ;;
        *)
            VERSION="$1"
            ;;
    esac
    shift
done

set -e

if (( NIGHTLY )); then
    echo "Updating as nightly..."
elif [ -z "$VERSION" ]; then
    echo "No version provided" >&2
    exit 1
elif ! echo $VERSION | grep -q -E -e '^[0-9]+\.[0-9]+'; then
    echo "Not a valid version: $VERSION" >&2
    exit 1
fi

if git status -s | grep -q -E '^ ?M+ '; then
    echo "Some changes are still pending, please commit this changes before using this script" >&2
    exit 1
fi

BRANCH=$(git branch --show-current)

# Nightly means to only update master branch with nightly tag without version auto-update
if (( NIGHTLY )); then
    if [ "$BRANCH" != "master" ]; then
        echo "nightly can only be set on master branch" >&2
        exit 1
    fi
    (( PUSH )) && git push
    git tag -d nightly
    (( PUSH )) && git push --tags --prune
    git tag nightly
    (( PUSH )) && git push --tags
    exit 0
fi

# Check if --force option should be used
if !(( FORCE )); then
    if git tag -l | grep -q $VERSION; then
        echo "$VERSION still tagged, use --force to override" >&2
        exit 1
    fi
fi

# On master, still update version in source/conf.py
if [ "$BRANCH" == "master" ]; then
    # Fix version & release in conf.py
    sed -i -r \
        -e "s/^version = u'.*'.*/version = u'$VERSION'/" \
        -e "s/^release = u'.*'.*/release = u'$VERSION'/" \
        source/conf.py

    # Make commit, tag it as nightly & push it, tag will be published later in this script
    if git status -s | grep -q -E '^ ?M+ '; then
        git commit -a -m "Update version in conf"
        git tag -f nightly
        (( PUSH )) && git push
    fi
fi

# Check we are in a dedicated branch
case "$BRANCH" in
    "")
        echo "Not on a branch" >&2
        exit 1
        ;;
    version/$VERSION)
        # We are still on the expected branch
        ;;
    *)
        if git branch -l version/$VERSION | grep -q version/$VERSION; then
            # Switch to the branch to rebase if required
            if (( REBASE )); then
                git checkout version/$VERSION
                git rebase $BRANCH
            else
                echo "version/$VERSION branch still exists, use --rebase or work from that branch" >&2
                exit 1
            fi
        else
            # Checkout current branch to new dedicated branch
            git checkout -b version/$VERSION
        fi
        ;;
esac

# Update any |version| found
grep -lr '|version|' source | grep -v source/conf.py | \
while read file
do
    sed -i -e "s/|version|/$VERSION/g" $file
done

# Make a commit
if git status -s | grep -q -E '^ ?M+ '; then
    git commit -a -m "Update version to $VERSION"
fi

git tag -f $VERSION

if (( PUSH )); then
    git push -u origin version/$VERSION
    git push --tags --force
fi

# Checkout original branch
git checkout $BRANCH
