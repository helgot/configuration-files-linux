#!/bin/bash

# Check for required utilities
if ! command -v nvidia-smi &>/dev/null || ! command -v nvidia-settings &>/dev/null; then
    echo "This script requires 'nvidia-smi' and 'nvidia-settings' to be installed."
    exit 1
fi

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "Please run as root (e.g., sudo ./script.sh)"
    exit 1
fi

# Check for NVIDIA GPU model
GPU_MODEL=$(nvidia-smi --query-gpu=name --format=csv,noheader -i 0)
# You can query your GPU model string by running 'nvidia-smi --query-gpu=name --format=csv,noheader -i 0' on the command line.
EXPECTED_GPU_MODEL="NVIDIA GeForce RTX 2070 SUPER"

if [[ "$GPU_MODEL" == "$EXPECTED_GPU_MODEL" ]]; then
    # Set your desired overclock values
    CORE_CLOCK=70 # Increase in MHz
    MEMORY_CLOCK=850 # Increase in MHz
    POWER_LIMIT=250  # Power limit in Watts
else
	echo "The retrieved GPU model ('$GPU_MODEL') did not match the expected GPU model ('$EXPECTED_GPU_MODEL')."
	exit 1
fi

# Validate overclock values (example ranges; adjust according to safe limits for your GPU)
if ((CORE_CLOCK < 0 || CORE_CLOCK > 500)); then
    echo "Core clock offset is out of safe range!"
    exit 1
fi

if ((MEMORY_CLOCK < 0 || MEMORY_CLOCK > 1500)); then
    echo "Memory clock offset is out of safe range!"
    exit 1
fi

if ((POWER_LIMIT < 100 || POWER_LIMIT > 600)); then
    echo "Power limit is out of safe range!"
    exit 1
fi

# Enable persistence mode
nvidia-smi -pm 1

# Apply power limit
nvidia-smi -i 0 -pl $POWER_LIMIT

# Apply overclock settings
nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=1"  # Set performance mode
nvidia-settings -a "[gpu:0]/GPUGraphicsClockOffset[4]=$CORE_CLOCK"  # Core clock
nvidia-settings -a "[gpu:0]/GPUMemoryTransferRateOffset[4]=$MEMORY_CLOCK"  # Memory clock

echo "Overclocking applied: Core +$CORE_CLOCK MHz, Memory +$MEMORY_CLOCK MHz"
echo "Power limit set to $POWER_LIMIT W"

