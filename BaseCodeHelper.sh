#!/bin/bash

# Set default values
DEFAULT_NUM_THREADS=24

# Function to prompt with default
prompt_with_default() {
    local var_name=$1
    local prompt_text=$2
    local default_val=$3
    read -p "$prompt_text [$default_val]: " input
    eval $var_name=\"\${input:-$default_val}\"
}

# Function to prompt with default
prompt_no_default() {
    local var_name=$1
    local prompt_text=$2
    read -p "$prompt_text" input
    eval $var_name=\"\${input}\"
}

# Prompt the user
prompt_no_default a_dir "Enter path for results directory (host): " 
prompt_no_default b_dir "Enter path for configuration directory (host): " 
prompt_no_default c_dir "Enter path for FASTQ directory (host): " 
prompt_no_default d_dir "Enter path for resources directory (host): " 
prompt_with_default num_threads "Enter number of threads (default 24)" "$DEFAULT_NUM_THREADS"
prompt_with_default software "Specify deployment software (default docker)" "docker"

# Display the inputs
echo ""
echo "Summary of Inputs:"
echo "Path for results directory (host): $a_dir"
echo "Path for configuration directory (host): $b_dir"
echo "Path for FASTQ directory (host): $c_dir"
echo "Path for resources directory (host): $d_dir"
echo "Number of Threads: $num_threads"
echo "Deployment software: $software"
echo ""

# Define Docker container paths
mnt_a="/usr/local/BaseCode/results/"
mnt_b="/usr/local/BaseCode/config/"
mnt_d="/usr/local/app/resources/"
mnt_c="/usr/local/BaseCode/fastq/"

# Construct the Docker command
docker_cmd=(
	$software
	run 
	--mount type=bind,src="$a_dir",dst="$mnt_a" 
	--mount type=bind,src="$b_dir",dst="$mnt_b"  
	--mount type=bind,src="$c_dir",dst="$mnt_c"  
	--mount type=bind,src="$d_dir",dst="$mnt_d"  
	basicgenomics/basecode:latest 
	--threads "$num_threads"
)

# Print the Docker command
echo "Running the following command:"
printf '%q ' "${docker_cmd[@]}"
echo ""
echo ""

# Execute the Docker command
"${docker_cmd[@]}"
