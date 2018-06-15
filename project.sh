#!/usr/bin/env bash
set -euo pipefail

# Load constant
source .env

# Define output formats
question=$(tput bold)
error=$(tput setaf 1)
info=$(tput setaf 3)
success=$(tput setaf 4)
reset=$(tput sgr0)
qe=$(tput bold && tput setaf 1)
re=$(tput sgr0 && tput setaf 1)

############
# Function #
############
function new() {
    echo "${info}New started...${reset}"

    # Initialize project
    rm -rf $PROJECT_DIR
    git clone https://gitlab.omn.proximis.com/public-packages/change-new-project $PROJECT_DIR

    # Update composer
    composer self-update
    composer update --working-dir=$PROJECT_DIR --prefer-dist --ignore-platform-reqs

    echo "${info}Do not forget to launch init.sh script and to create the file project.local.json in App/Config before executing update.sh script${reset}"
}

function bootstrap() {
    echo "${info}Bootstrap started...${reset}"

    # Clone project
    rm -rf $PROJECT_DIR
    git clone ssh://git@gitlab.omn.proximis.com:10022/$INTEGRATOR/$PROJECT.git $PROJECT_DIR

    # Add forked remote
    git --git-dir=$GIT_DIR --work-tree=$GIT_WORK_TREE remote add composer ssh://git@gitlab.omn.proximis.com:10022/$REMOTE/$PROJECT.git
    git --git-dir=$GIT_DIR --work-tree=$GIT_WORK_TREE fetch composer

    # Add project.local.json in a better way
    cp project.local.json $PROJECT_DIR/App/Config/project.local.json

    # Adding the nginx configuration to the docker project
    NGINX_DIR="$PROJECT_DIR/nginx"
    NGINX_CONFIGS=$(ls $NGINX_DIR 2> /dev/null)
    if [[ ! -z $NGINX_CONFIGS ]]; then
        for NGINX_CONFIG in $NGINX_CONFIGS; do
            cp $NGINX_DIR/$NGINX_CONFIG ./nginx/site-available/$NGINX_CONFIG
        done 
    fi

    # Check if the project is a directory
    if [[ ! -d $PROJECT_DIR ]]; then
        echo "${error}The ${qe}project directory${re} does not exist.${reset}"
        exit 1
    else
        echo "${success}Bootstrap completed successfully.${reset}"
    fi

    update
}

function update() {
    echo "${info}Update started...${reset}"

    # Remove all plugins
    rm -rf $PROJECT_DIR/Plugins/*

    # Update composer
    docker-compose exec php sh -c "cd /var/www/html/$PROJECT && composer self-update"
    docker-compose exec php sh -c "cd /var/www/html/$PROJECT && composer update --prefer-dist"

    # Install all plugin from GitLab
    PLUGINS=$(find $PROJECT_DIR/Plugins/*/$REMOTE -type d -depth 1 2> /dev/null)
    if [[ ! -z $PLUGINS ]]; then
        for PLUGIN in $PLUGINS; do
            FORK_NAME=""

            # Check if the plugin is a Module or Theme
            case $PLUGIN in
                *Modules* )
                    FORK_NAME=$(echo "module-$(basename $PLUGIN)" | tr '[:upper:]' '[:lower:]')
                    ;;
                *Themes* )
                    FORK_NAME=$(echo "theme-$(basename $PLUGIN)" | tr '[:upper:]' '[:lower:]' | sed 's/-theme/-/g')
                    ;;
            esac

            if [[ -z $FORK_NAME ]]; then
                echo "${error}Unknown plugin type: ${qe}$PLUGIN${re}.${reset}"
                exit 1
            fi

            GIT_PLUGIN_DIR="$PLUGIN/.git"
            GIT_PLUGIN_WORK_TREE=$PLUGIN

            # Remove the plugin to install it from GitLab
            rm -rf $PLUGIN
            git clone ssh://git@gitlab.omn.proximis.com:10022/$INTEGRATOR/$FORK_NAME.git $PLUGIN
            git --git-dir=$GIT_PLUGIN_DIR --work-tree=$GIT_PLUGIN_WORK_TREE remote add composer ssh://git@gitlab.omn.proximis.com:10022/$REMOTE/$FORK_NAME.git
            git --git-dir=$GIT_PLUGIN_DIR --work-tree=$GIT_PLUGIN_WORK_TREE fetch composer
        done
    fi

    echo "${success}Update completed successfully${reset}"

    # Launch project installation
    install
}

function install() {
    echo -n "${question}Do you want to install the project now ? (y/n) : ${reset}"
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        # Check if we use update.sh or makfile
        if [[ -f $PROJECT_DIR/init.sh && -f $PROJECT_DIR/update.sh ]]; then
            docker-compose exec php sh -c "cd /var/www/html/$PROJECT && init.sh && update.sh"
        elif [[ -f $PROJECT_DIR/Makefile ]]; then
            docker-compose exec php sh -c "cd /var/www/html/$PROJECT && make start"
        else
            echo "${info}No install process found.${reset}"
        fi

        if [ "$?" = "0" ]; then
            echo "${success}Project $INTEGRATOR / $REMOTE was successfully installed.${reset}"
        else
            echo "${error}Something went wrong. Project installation may have failed.${reset}"
        fi
    elif echo "$answer" | grep -iq "^n" ;then
        echo "${info}Do not forget to run the Proximis update.sh script or the make command later.${reset}"
    else
        echo "${error}Invalid input.${reset}"
        exit 1
    fi
}

##########
# Script #
##########
BEHAVIOR="${1}"
PROJECT="${2}"
REMOTE="${3}"

# Check behavior
if [[ $BEHAVIOR != "new" && $BEHAVIOR != "bootstrap" && $BEHAVIOR != "update" ]]; then
    echo "${error}Please specify a valid behavior: ${qe}new${re}, ${qe}bootstrap${re}, ${qe}update${re}.${reset}"
    exit 1
fi

# Check project
if [[ -z $PROJECT ]]; then
    echo "${error}Please specify a valid ${qe}project name${re}.${reset}"
    exit 1
fi

# Check remote
if [[ -z $REMOTE ]]; then
    echo "${error}Please specify a valid ${qe}remote group name${re}.${reset}"
    exit 1
fi

PROJECT_DIR="$WEBSITES/$PROJECT"
GIT_DIR="$PROJECT_DIR/.git"
GIT_WORK_TREE=$PROJECT_DIR

if [[ $BEHAVIOR == "new" ]]; then
    new
elif [[ $BEHAVIOR == "bootstrap" ]]; then
    bootstrap
elif [[ $BEHAVIOR == "update" ]]; then
    update
fi
