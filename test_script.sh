#!/bin/bash
# A simple framework for testing the bn scripts
# Returns the number of failed test cases.
# The test function used in the script was taken the from week04 directory
#   Sam Scott, McMaster University, 2024.
#
# Format of a test:
#     test 'command' expected_return_value 'stdin text' 'expected stdout' 'expected stderr'
#
# Some example test cases are given. You should add more test cases.
#
# Benjamin Bloomfield, McMaster University, October 24, 2024


# GLOBALS: tc = test case number, fails = number of failed cases
declare -i tc=0
declare -i fails=0

############################################
# Run a single test. Runs a given command 3 times
# to check the return value, stdout, and stderr
#
# GLOBALS: tc, fails
# PARAMS: $1 = command
#         $2 = expected return value
#         $3 = standard input text to send
#         $4 = expected stdout
#         $5 = expected stderr
# RETURNS: 0 = success, 1 = bad return, 
#          2 = bad stdout, 3 = bad stderr
############################################
test() {
    tc=tc+1

    local COMMAND=$1
    local RETURN=$2
	local STDIN=$3
    local STDOUT=$4
    local STDERR=$5

    # CHECK RETURN VALUE
    $COMMAND <<< "$STDIN" >/dev/null 2>/dev/null
    local A_RETURN=$?

    if [[ "$A_RETURN" != "$RETURN" ]]; then
        echo "Test $tc Failed"
        echo "   $COMMAND"
        echo "   Expected Return: $RETURN"
        echo "   Actual Return: $A_RETURN"
        fails=$fails+1
        return 1
    fi

    # CHECK STDOUT
    local A_STDOUT=$($COMMAND <<< "$STDIN" 2>/dev/null)

    if [[ "$STDOUT" != "$A_STDOUT" ]]; then
        echo "Test $tc Failed"
        echo "   $COMMAND"
        echo "   Expected STDOUT: $STDOUT"
        echo "   Actual STDOUT: $A_STDOUT"
        fails=$fails+1
        return 2
    fi
    
    # CHECK STDERR
    local A_STDERR=$($COMMAND <<< "$STDIN" 2>&1 >/dev/null)

    if [[ "$STDERR" != "$A_STDERR" ]]; then
        echo "Test $tc Failed"
        echo "   $COMMAND"
        echo "   Expected STDERR: $STDERR"
        echo "   Actual STDERR: $A_STDERR"
        fails=$fails+1
        return 3
    fi
    
    # SUCCESS
    echo "Test $tc Passed"
    return 0
}

##########################################
# TEST CASES
##########################################

# simple success
test './bn.sh 1880 m' 0 'Wes' '1880: Wes ranked 1051 out of 1058 male names.' ''

# multi line success
test './bn.sh 1969 B' 0 'SCOTT' '1969: SCOTT ranked 12 out of 5042 male names.
1969: SCOTT ranked 983 out of 8708 female names.' ''

# error case
test './bn.sh 2022 F' 3 'benjamin91' '' 'Badly formatted name: benjamin91' ''  

# multi line error case #2
test './bn.sh 1111 X' 2 '' '' 'Badly formatted assigned gender: X
bn <year> <assigned gender: f|F|m|M|b|B>' ''

# invalid year input
test './bn.sh 3000 m' 4 '' '' 'No data for 3000' ''

# no input parameters
test './bn.sh' 1 '' '' 'bn <year> <assigned gender: f|F|m|M|b|B>' ''

# unranked name for given year
test './bn.sh 2000 m' 0 'Donkey' '2000: Donkey not found among male names.' ''

# boundary testing #1
test './bn.sh 1880 m' 0 'John' '1880: John ranked 1 out of 1058 male names.' ''

# boundary testing #2
test './bn.sh 1994 m' 0 'Zuhair' '1994: Zuhair ranked 10243 out of 10243 male names.' ''

# return code
exit $fails
