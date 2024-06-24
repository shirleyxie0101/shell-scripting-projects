#!/bin/bash

###############################
# About: Listing Users with Read Access on a Github Repo
# Export: USERNAME, TOKEN for Github Account
# Input: 1. repo owner
#        2. repo name
# 
# Owner: Shirley Xie
#
###############################

helper

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
# These are enbironment variables use EXPOSE to prase value on Linux terminal
USERNAME=$username
TOKEN=$token

# User and Repository information
# These are command line arguments
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    # defined funcfion arguments
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    # $(...) is a formate to exexute a command in script file
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    # When you use -z with a variable, it evaluates to true if the variable is an empty string, and false otherwise
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Helper function is used to remind executers information (checking arguments) before entring into functions
function helper {
    # if the list command-line argument is not equal to the expected number of arguments
    local expected_cmd_args=2
    if [[ $# -ne $expected_cmd_args]]; then
        echo "please execute the script with the required cmd args"
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
