#!/bin/bash
# PURPOSE OF THE CODE
# Benjamin Bloomfield, McMaster University, DATE


# based on the argument letter, assign a string corresponding to the gender
setFullGender() {
    if [[ $GENDER =~ ^[mM]$ ]]
    then
        FULLGENDER="male"
    elif [[ $GENDER =~ ^[fF]$ ]]
    then
        FULLGENDER="female"
    fi
}

rank() {
    local FILE="yob${YEAR}.txt"
    local GENDER=$2
    local NAME=$1
    local TOTALNAMES

    if [[ "$GENDER" = "b" ]]
    then
        # runs all the following commands for male and female
        for GENDER in m f
        do
            setFullGender "$GENDER" # sets the gender for both iterations
            TOTALNAMES=$(cat $FILE | grep -P -i ",$GENDER" | wc -l) # find the total number of names for the given gender

            # checks to see if the name exists,
            CHECKNAME=$(cat $FILE | grep -P -i ",$GENDER" | grep -n -P "$NAME")
            if [[ -n $CHECKNAME ]]

            # if the name exists
            then
                    NAMERANKING=$(cat $FILE | grep -P -i ",$GENDER"| grep -n -P "$NAME" | grep -P "[0-9]{1,4}:$NAME," | grep -o -P '^[0-9]+')
                    echo "${YEAR}: $NAME ranked $NAMERANKING out of $TOTALNAMES $FULLGENDER names."    # print message at the end

            # if the name doesn't exist
            else
                echo "${YEAR}: $NAME not found among $FULLGENDER names"
            fi
        done

    # if the user inputted an m/M ir f/F
    else
        setFullGender "$GENDER" # sets the gender for both iterations
        TOTALNAMES=$(cat $FILE | grep -P -i ",$GENDER" | wc -l)

        # checks to see if the name exists,
        CHECKNAME=$(cat $FILE | grep -P -i ",$GENDER" | grep -n -P "$NAME")
        if [[ -n $CHECKNAME ]]

        # if the name exists
        then
                NAMERANKING=$(cat $FILE | grep -P -i ",$GENDER"| grep -n -P "$NAME" | grep -P "[0-9]{1,4}:$NAME," | grep -o -P '^[0-9]+')
                echo "${YEAR}: $NAME ranked $NAMERANKING out of $TOTALNAMES $FULLGENDER names."    # print message at the end

        # if the name doesn't exist
        else
            echo "${YEAR}: $NAME not found among $FULLGENDER names"
        fi
    fi
}

# variable initialization for the year and gender
YEAR=$1
GENDER=$2



# allows user to enter names for the computer to search for
read NAMES

# iterates through each name the user enteres, and call the function to get results
for NAME in $NAMES
do
    rank "$NAME" "$GENDER"
done








# exit code 1
if [[ $# != 2 ]]
then
    echo "bn <year> <assigned gender: f|F|m|M|b|B>" >&2
    exit 1

# exit code 2
elif [[ $2 =~ [^fFmMbB] ]]
then
    echo "Badly formatted assigned gender: $2"
    echo "bn <year> <assigned gender: f|F|m|M|b|B>" >&2
    exit 1
fi





