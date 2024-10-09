#!/bin/bash
# PURPOSE OF THE CODE
# Benjamin Bloomfield, McMaster University, DATE

### FUNCTION DECLERATION ###

# FUNCTION PURPOSE
help() {
    echo "This is my help function!"
    echo "I dont know what to write yet..."
}

# FUNCTION PURPOSE
usage() {
    if [[ $1 = "EXIT1" ]]
    then
        echo "bn <year> <assigned gender: f|F|m|M|b|B>" >&2
        exit 1
    elif [[ $1 = "EXIT2" ]]
    then
        echo "Badly formatted assigned gender: $2"
        echo "bn <year> <assigned gender: f|F|m|M|b|B>" >&2
        exit 1
    elif [[ $1 = "EXIT3" ]]
    then 
        echo "Badly formatted name: $2" >&2
        exit 1
    else
        echo "No data for $2" >&2
        exit 1
    fi
}

# FUNCTION PURPOSE
setFullGender() {
    if [[ $GENDER =~ ^[mM]$ ]]
    then
        FULLGENDER="male"
    elif [[ $GENDER =~ ^[fF]$ ]]
    then
        FULLGENDER="female"
    fi
}

# FUNCTION PURPOSE
rankNames () {
    local NAME=$1
    local GENDER=$2
    local YEAR=$3
    local FILE="yob${YEAR}.txt"
    setFullGender "$GENDER" # sets the gender for both iterations

    TOTALNAMES=$(cat $FILE | grep -P -i ",$GENDER" | wc -l) # find the total number of names for the given gender
    NAMERANKING=$(cat $FILE | grep -P -i ",$GENDER"| grep -n -P -i "$NAME" | grep -P -i "[0-9]{1,4}:$NAME," | grep -o -P -i '^[0-9]+')   # extracts the ranking

    # checks to see if the name exists, and runs the correspond commands based on its existence
    if [[ -n $NAMERANKING ]]        
    then        
            echo "${YEAR}: $NAME ranked $NAMERANKING out of $TOTALNAMES $FULLGENDER names."    # print message at the end
    else
        echo "${YEAR}: $NAME not found among $FULLGENDER names"
    fi
}

# FUNCTION PURPOSE
main() {
    if [[ "$GENDER" = "b" ]]
    then    
        # runs all the following commands for male and female if b is entered 
        for CURRENT_GENDER in m f
        do
            rankNames "$NAME" "$CURRENT_GENDER" "$YEAR"
        done

    # if the user inputted an m/M ir f/F
    else
        rankNames "$NAME" "$GENDER" "$YEAR"
    fi
}

### MAIN SCRIPT ###

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
    usage "EXIT2"
elif [[ ! -f "yob${YEAR}.txt" ]]    # checks if a file exists for the year the user enters
then 
    usage "EXIT4" "$YEAR"

# if no errors arise, run the following commands
else
    while true
    do
        # allows user to enter names for the computer to search for
        if read NAMES
        then
            for NAME in $NAMES
            do
                # checks if each name is a valid string before calling the main function
                if ! [[ $NAME =~ ^[a-zA-Z]+$ ]]
                then 
                    usage "EXIT3" "$NAME" 
                    exit 1
                # if the name is accepted, call the main function to get results
                else
                    main "$NAME" "$GENDER"
                fi
            done
        # if EOF is received, read will return 0, and will break out of the loop
        else
            break
        fi
    done
fi

