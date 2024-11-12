ns-train nerfacto   --data /home/ykguo/Documents/colmap_experiments_low_light_nerf/experiments/data_5170_1104_20mm/noisy_ds004_iso006400_s1_00013/transforms.json   \
--pipeline.datamanager.train-num-images-to-sample-from -1   --pipeline.datamanager.eval-num-images-to-sample-from -1 \
--experiment-name 
--pipeline.model.camera-optimizer.mode off 



ns-train nerfacto --data ../low_light_imaging_data/data_5170_1104_20mm/iso006400_s1_00013/downsampled_004/transforms_optimized.json \
--experiment-name 1108_test_optimized_poses \
--pipeline.model.camera-optimizer.mode off \
--max-num-iterations 60000


ns-render camera-path \
--load-config outputs/1108_test_optimized_poses/nerfacto/2024-11-08_102208/config.yml \
--camera-path-filename /scratch/local3/2024/ykguo/Documents/nerfstudio/../low_light_imaging_data/data_5170_1104_20mm/iso006400_s1_00013/downsampled_004/camera_paths/2024-11-08-10-22-18.json \
--rendered-output-names depth rgb \
--output-path renders/1108_test_optimized_poses/2024-11-08-10-22-18_rgb_depth.mp4

ns-render camera-path \
--load-config outputs/1108_test_optimized_poses/nerfacto/2024-11-08_102208/config.yml \
--camera-path-filename /scratch/local3/2024/ykguo/Documents/nerfstudio/../low_light_imaging_data/data_5170_1104_20mm/iso006400_s1_00013/downsampled_004/camera_paths/2024-11-08-10-22-18.json \
--output-path renders/1108_test_optimized_poses/2024-11-08-10-22-18_depth.mp4 \
--rendered-output-names depth \
--colormap-options.colormap gray



ns-train nerfacto --data /home/ykguo/Documents/acezero/results_andrew/test_nov_11/nerf_data/transforms.json \
--experiment-name test_ace0_poses_nov_11 \
--pipeline.model.camera-optimizer.mode off \
--max-num-iterations 30000


ns-eval --load-config /home/ykguo/Documents/nerfstudio/outputs/noisy_ds004_iso006400_s1_00013/nerfacto/2024-11-07_134136/config.yml \
--output-path /home/ykguo/Documents/nerfstudio/outputs/noisy_ds004_iso006400_s1_00013/nerfacto/2024-11-07_134136/output.json  \
--render-output-path /home/ykguo/Documents/nerfstudio/outputs/noisy_ds004_iso006400_s1_00013/nerfacto/2024-11-07_134136/rendered_images

export CUDA_VISIBLE_DEVICES=1
ns-render dataset --load-config /home/ykguo/Documents/nerfstudio/outputs/noisy_ds004_iso006400_s1_00013/nerfacto/2024-11-07_134136/config.yml \
--output_path /home/ykguo/Documents/nerfstudio/renders/noisy_ds004_iso006400_s1_00013/nerfacto/ \
--image-format png --split val --rendered-output-names rgb 
