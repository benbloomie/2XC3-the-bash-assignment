# bn - Baby Names Utility
A command-line tool to find the popularity ranking of U.S. baby names by year and gender.

---

## Description
This bash utility lets users search the ranking of baby names based on data from the United States Social Security Administration. Users specify a year (1880–2022) and a gender (male, female, or both), then input baby names to see their popularity rankings. The program accepts multiple names continuously until it receives an EOF or invalid input. It validates inputs and provides helpful error messages to guide users.

---

## Getting Started

### Dependencies  
- Bash shell (Linux, macOS, WSL)  
- Social Security Administration baby names data files stored in `./us_baby_names/` directory 

### Installing  
1. Clone or download the repository:

    ```bash
    git clone https://github.com/benbloomie/2XC3-the-bash-assignment
    cd 2XC3-the-bash-assignment
    ```

2. Ensure the baby names data files are inside the folder `./us_baby_names/`.

3. Make the script executable:

    ```bash
    chmod 755 bn.sh
    ```

---

## Executing Program

Run the script with the year and gender as arguments:

```bash
./bn.sh <year> <assigned gender: f|F|m|M|b|B>
