#!/bin/bash

# Project
# Topic: List all the user have read access of provided repository in Github.
#######
####
###
###
####
#######
#
#
# Instructions==>
#
# Make sure jq module is installed in your system.
# Before running the script make sure that username (your github username) and token (a classic token) is exported in terminal like----
#                                  $ export username=<username>
#                                  $ export token=<token>
# And the expression to run the script should be look like ----
#                                  $ ./script.sh <repo_owner_name> <repo_name>
#                                          or
#                                  $ bash script.sh <repo_owner_name> <repo_name>
#
#
# Important *******
# Here this script can only list the collaborators of repository which have access to user.
#
#
#
#
# GitHub API URL
API_URL="https://api.github.com"

# Github username and personal access token
USERNAME=$username
TOKEN=$token

# Check username exist or not.
if [[ ${#USERNAME} -eq 0 ]] 
then
	echo "[WARNING]: Please export username"
	echo "[COMMAND]: export username=<username>"
	exit 1
fi


# Check token exist or not.
if [[ ${#TOKEN} -eq 0 ]]
then
	echo "Token not found!"
	echo "[WARNING]: Please export token"
	echo "[COMMAND]: export token=<token>"
	exit 1
fi


# Check weather user provide repository owner name and repository name  or not.
if [[ $# -ne 2 ]]
then
	echo "Please provide repository owner name"
	echo "Also provide repository name"
	echo "[GUIDE]: ./script.sh <repo_owner_name> <repo_name>"
	exit 1
fi

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the Github API
function github_api_get {
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"

	# Send a GET request to the GITHUB API with Authentication
	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repositry
function list_users_with_read_access {
	local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

	# Fetch the list of collaborators on the repository
	collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"


	# Display the list of collaborators with read access
	if [[ -z "$collaborators" ]] 
	then
		echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
	else
		echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
		echo "$collaborators"
	fi

}

# Main script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."

#calling listUserWithReadAccess function..
list_users_with_read_access

