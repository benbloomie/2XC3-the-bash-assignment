#!/bin/bash
# this program is a command-line utility that allows users to search for the the ranking of 
# baby names from the United States Social Security Adminstration data, based on year and gender.
# users can continue to enter names until the program reaches EOF, or bad user input.
# Benjamin Bloomfield, McMaster University, October 24, 2024.


# Name of the function: help
#
# Function Description:
#   prints the help information which gives feedback of the usage, version and description.
#   it also provides details on how to use the utility, and describes the possible arguments
help() {
    echo "  bn - Baby Names Utility"
    echo "  Version: v1.0.0"
    echo "" 
    echo "  The bn is a command-line utility that allows users to search for the "
    echo "  ranking of baby names from the United States Social Security Adminstration's "
    echo "  baby names data. The user can search based on data from a specific year, and "
    echo "  the baby's gender."
    echo ""
    echo "  Usage: "
    echo "      bn <year> <assigned gender: f|F|m|M|b|B>"
    echo ""
    echo "  Arguments: "
    echo "      <year>              the year to search for the baby's name (1880-2022)"
    echo "      <assigned gender>   the gender to search for: "
    echo "                              - f or F: female names "
    echo "                              - m or M: male names "
    echo "                              - b or B: male and female names "

}


# Name of the function: usage
# 
# Paramaters:
#  $1 --> an error type string 
#  $2 --> an additional argument for the error message
# Function Description:
#   provides feedback corresponding the users usage error.
#       - "EXIT1": incorrect number of arguments
#       - "EXIT2": improperly formatted gender input
#       - "EXIT3": badly formatted name input
#       - "EXIT4": no data available for the specified year
#   it returns the corresponding exit code for each error type.
usage() {
    if [[ $1 = "EXIT1" ]]
    then
        echo "bn <year> <assigned gender: f|F|m|M|b|B>" >&2
        exit 1
    elif [[ $1 = "EXIT2" ]]
    then
        echo "Badly formatted assigned gender: $2" >&2
        echo "bn <year> <assigned gender: f|F|m|M|b|B>" >&2
        exit 2
    elif [[ $1 = "EXIT3" ]]
    then 
        echo "Badly formatted name: $2" >&2
        exit 3
    else
        echo "No data for $2" >&2
        exit 4
    fi
}


# Name of the function: setFullGender
#
# Function Description:
#   converts the character that represents the gender to a string, to be called and printed
#   in the main function for the outputted message
setFullGender() {
    if [[ $GENDER =~ ^[mM]$ ]]
    then
        FULLGENDER="male"
    elif [[ $GENDER =~ ^[fF]$ ]]
    then
        FULLGENDER="female"
    fi
}


# Name of the function: rankNames
#
# Parameters:
#  $1 --> the baby name to search for
#  $2 --> the gender of the baby name 
#  $3 --> the year to search in
# Function Description:
#   searches through the list of files to find the corresponding file to the specified year from the user, and then searches  
#   for the baby name within that year's ranking for the given gender. it then counts the total number of names for the specified gender
#   and retrives the rank of the input name 
rankNames () {
    local FOUNDNAME=$1
    local GENDER=$2
    local YEAR=$3
    local FILE="yob${YEAR}.txt"
    setFullGender "$GENDER" # sets the gender for both iterations

    TOTALNAMES=$(cat ./us_baby_names/$FILE | grep -P -i ",$GENDER" | wc -l) # find the total number of names for the given gender
    NAMERANKING=$(cat ./us_baby_names/$FILE | grep -P -i ",$GENDER"| grep -n -P -i "$FOUNDNAME" | grep -P -i "[0-9]{1,4}:$FOUNDNAME," | grep -o -P -i '^[0-9]+')   # extracts the ranking

    # checks to see if the name exists, and runs the correspond commands based on its existence
    if [[ -n $NAMERANKING ]]        
    then        
            echo "${YEAR}: $FOUNDNAME ranked $NAMERANKING out of $TOTALNAMES $FULLGENDER names."    # print message at the end
    else
        echo "${YEAR}: $FOUNDNAME not found among $FULLGENDER names."
    fi
}


# Name of the function: main
#
# Function Description:
#   processes input to handle the searching for the baby names based on the inputted gender. 
#   calls the rankNames method to handle all of the ranking for the specifc arguments
#   if 'b' or 'B' is entered, it searches for both male and female rankings, otherwise, seraches for the specified gender
main() {
    if [[ "$GENDER" =~ [bB] ]] 
    then    
        # runs all the following commands for male and female if b is entered 
        for CURRENT_GENDER in m f
        do
            rankNames "$BABYNAME" "$CURRENT_GENDER" "$YEAR"
        done

    # if the user inputted an m/M ir f/F
    else
        rankNames "$BABYNAME" "$GENDER" "$YEAR"
    fi
}


# variable initialization for the year and gender
YEAR=$1
GENDER=$2

if [[ "$1" = "--help" ]]
then 
    help
elif [[ $# != 2 ]]    # checks if the user passes the proper amount of arguments
then
    usage "EXIT1"
elif [[ $2 =~ [^fFmMbB] ]]  # checks if the user passes a proper gender type
then
    usage "EXIT2" "$2"
elif [[ ! -f "./us_baby_names/yob${YEAR}.txt" ]]    # checks if a file exists for the year the user enters
then 
    usage "EXIT4" "$YEAR"

# if no errors arise, run the following commands
else
    while true
    do
        # allows user to enter names for the computer to search for
        if read ALLNAMES
        then
            for BABYNAME in $ALLNAMES
            do
                # checks if each name is a valid string before calling the main function
                if ! [[ $BABYNAME =~ ^[a-zA-Z]+$ ]]
                then 
                    usage "EXIT3" "$BABYNAME" 
                    exit 1
                # if the name is accepted, call the main function to get results
                else
                    main "$BABYNAME" "$GENDER"
                fi
            done
        # if EOF is received, read will return 0, and will break out of the loop
        else
            break
        fi
    done
fi
