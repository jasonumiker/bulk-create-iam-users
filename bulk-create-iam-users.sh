#!/bin/bash
# Script to bulk create IAM Admin Users with random passwords written out
# to a CSV File
# By Jason Umiker jason.umiker@gmail.com

set -e

NumberOfUsers=20

# Create the Full Admins IAM Group
aws iam create-group --group-name FullAdmins
aws iam attach-group-policy \
    --group-name FullAdmins \
    --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# We want 30 IAM Users created - setting up the array
for (( c=1; c<=$NumberOfUsers; c++ ))
do
   Users[c-1]="user"$c
done

# We need 30 random passwords for those users - setting up the array
for (( c=1; c<=$NumberOfUsers; c++ ))
do
   Passwords[c-1]=$(./pwgen.py)
done

# The create_user function - we'll call this each time to create the user
create_user() {
  user=${1}
  password=${2}
  group=${3}

  aws iam create-user --user-name ${user}
  aws iam create-login-profile --user-name ${user} --password ${password}
  aws iam add-user-to-group --user-name ${user} --group-name ${group}
}

# The loop where we iterate through the job
for (( c=1; c<=NumberOfUsers; c++ ))
do
  # Create the User
  create_user ${Users[$c-1]} ${Passwords[$c-1]} FullAdmins
  # Append the username,password to the passwords.csv file
  echo ${Users[$c-1]},${Passwords[$c-1]} >> passwords.csv
done
