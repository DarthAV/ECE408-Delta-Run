<div align="center">

# ECE408 Delta Run

[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge&color=blue)](LICENSE.txt)

</div>

## About



This repository contains the code for the ECE408 Delta Run project. The provided bash script `delta_run.sh` defines functions that can be used to automate the process of compiling, submitting, and running the jobs on Delta. Here is a short video demontrating the usage of the script:

[![asciicast](
https://github.com/DarthAV/ECE408-Delta-Run/assets/29022142/07aaab99-e85a-44b9-afac-02efb700a692
)](
https://github.com/DarthAV/ECE408-Delta-Run/assets/29022142/07aaab99-e85a-44b9-afac-02efb700a692
)

I have only tested this script on the UIUC Delta GPU cluster with ECE 408 in Spring 2024. If the course or the cluster changes, the script may not work as intended.

## Usage

Before you can use the script, you will need to "source" the script in your terminal instance. You can do this by running the following command:

```bash
source delta_run.sh
```

If you want the script to be sourced every time you open a new terminal instance, you can add the above command to your `~/.bashrc` file.

```bash
source /path/to/delta_run.sh
```

### Lab

To run the lab, navigate to the lab directory and run the following command:

```bash
run_lab
```

### Project

To run the project milestones, navigate to the project directory and run the following command:

```bash
run_project <milestone_number>
```

To run the final milestone, simply run the function without any arguments:

```bash
run_project
```

#### Notes on `run_project`

- Running this command with arguments other than those specified above will lead to undefined behavior and may cause it to wait infinitely on a nonexistent/failed Delta job. (You will need to send a `SIGINT` with `Ctrl/Cmd+C`)
- It is possible that your job will timeout on Delta if it takes too long to run. If the script hits 20 minutes of waiting, it will exit, though the job may still be running. You can manually check the status of all your jobs by running `squeue --user=<Delta username>`. If you don't see any running jobs, you can check `.err` file to see if it timed out.
