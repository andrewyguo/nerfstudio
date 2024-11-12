#!/bin/bash


### Common variables ### 
SORT_TRANSFORMS_SCRIPT="/home/ykguo/Documents/colmap_experiments_low_light_nerf/sort_transforms_json.py" 
# Be sure to use the right distorted / undistorted folder. 
# ACE0: undistorted, COLMAP: distorted, 
REFERENCE_IMAGES="/home/ykguo/Documents/low_light_imaging_data/data_5170_1104_20mm/iso006400_s1_00013/downsampled_004/images_undistorted/" 

NERFSTUDIO_BASE="/home/ykguo/Documents/nerfstudio"

# Check if at least two arguments are provided
if [ "$#" -lt 3 ]; then
    echo "Error: Two arguments are required."
    echo "Usage: $0 <transform.json to be evaluated> <experiment_name> <method name>"
    exit 1
fi

input_transforms_json=$1
experiment_name=$2
method_name=$3


python $SORT_TRANSFORMS_SCRIPT $input_transforms_json \
--update_file_path $REFERENCE_IMAGES

# Train nerfacto model with the provided transforms.json file
# Only of the model does not already exist 
output_dir="${NERFSTUDIO_BASE}/outputs/${experiment_name}/nerfacto/${method_name}/nerfstudio_models"
if [ -d "$output_dir" ] && [ "$(ls -A $output_dir/*.ckpt 2>/dev/null)" ]; then
    echo "Checkpoint already exists in $output_dir. Skipping ns-train step."
else
    ns-train nerfacto --data  $input_transforms_json \
    --experiment-name $experiment_name \
    --timestamp "${method_name}" \
    --pipeline.model.camera-optimizer.mode off \
    --viewer.quit-on-train-completion True \
    --max-num-iterations 50000
fi 

# Render the images using the trained model
ns-render dataset \
--load-config "${NERFSTUDIO_BASE}/outputs/${experiment_name}/nerfacto/${method_name}/config.yml" \
--output_path "${NERFSTUDIO_BASE}/renders/${experiment_name}/nerfacto/${method_name}/"  \
--image-format png --split val --rendered-output-names rgb 

RENDER_IMAGES_PATH="${NERFSTUDIO_BASE}/renders/${experiment_name}/nerfacto/${method_name}/val/rgb"


# TODO: 
# instead of echo PSNR, save it into one comprehensive JSON organized by experiment_name and method name 
