RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NOCOLOR='\033[0m'

function run_lab() {
    printf "${BLUE}Running Make${NOCOLOR}\n"

    if make all; then
        printf "${GREEN}Make completed successfully.${NOCOLOR}\n"
    else
        printf "${RED}Make error. Exiting function.${NOCOLOR}\n\n"
        return
    fi

    id=$(make run | grep 'Submitted' | cut -d ' ' -f4)

    printf "${BLUE}Submitted job to Delta - Job ID = $id${NOCOLOR}\n"

    squeue --job $id
    iteration=0

    while true; do
        squeue --job $id | tail -n 1 | grep -v $id && printf "${GREEN}Successfully ran job after $iteration seconds${NOCOLOR}\n" && break

        printf "waiting on job $id ($iteration seconds)\r"

        sleep 1
        ((iteration++))
    done
}

function run_project() {
    local binary_version 
    
    if [ -z "$1" ]; then
        binary_version=final
        printf "${GREEN}No milestone number provided. Defaulting to final${NOCOLOR}\n"
    else 
        binary_version=m$1
        printf "${GREEN}Running milestone $binary_version${NOCOLOR}\n"
    fi

    printf "${BLUE}Cleaning Workspace${NOCOLOR}\n"
    clean_project

    printf "${BLUE}Running CMake${NOCOLOR}\n"

    if cmake -DCMAKE_CXX_FLAGS=-pg ./project/ && make -j8; then
        printf "${GREEN}Make completed successfully.${NOCOLOR}\n"
    else
        printf "${RED}Make error. Exiting function.${NOCOLOR}\n\n"
        printf "${BLUE}Cleaning Workspace${NOCOLOR}\n"
        clean_project
        return
    fi
    
    printf "${BLUE}Cleaning ${NOCOLOR}\n"

    ./cleanfile.sh

    id=$(sbatch $binary_version.slurm | grep 'Submitted' | cut -d ' ' -f4)

    printf "${BLUE}Submitted job to Delta - Job ID = $id${NOCOLOR}\n"

    squeue --job $id
    iteration=1

    while true; do
        squeue --job $id | tail -n 1 | grep -v $id && printf "${GREEN}Successfully ran job after $iteration seconds${NOCOLOR}\n" && break

        if ((iteration >= 1200)); then
            printf "${RED}Waited on job $id for 20 minutes. No longer waiting. It may still be running on Delta${NOCOLOR}\n"
            return
        fi

        printf "waiting on job $id ($iteration seconds)\r"


        sleep 1
        ((iteration++))
    done
}

function clean_project() {
    ./run.sh clean
}


