#!/bin/bash

export PIPELINE_REPO="openproblems-bio/neurips2021_multimodal_viash"
export NXF_VER=21.04.1
export PIPELINE_VERSION=1.4.0
method_id=submission_170795
task_id=joint_embedding

# CITE GEX2ADT
dataset_id=openproblems_bmmc_cite_phase2_rna
dataset_path=output/datasets/$task_id/$dataset_id/$dataset_id.censor_dataset
pred_path=output/predictions/$task_id/$dataset_id/$dataset_id

target/docker/match_modality_methods/run/${method_id}_run \
  --input_mod1 ${dataset_path}.output_train_mod1.h5ad \
  --input_mod2 ${dataset_path}.output_train_mod2.h5ad \
  --output ${pred_path}.${method_id}_run.output.h5ad

# CITE ADT2GEX
dataset_id=openproblems_bmmc_cite_phase2_mod2
dataset_path=output/datasets/$task_id/$dataset_id/$dataset_id.censor_dataset
pred_path=output/predictions/$task_id/$dataset_id/$dataset_id

target/docker/match_modality_methods/run/${method_id}_run \
  --input_mod1 ${dataset_path}.output_train_mod1.h5ad \
  --input_mod2 ${dataset_path}.output_train_mod2.h5ad \
  --output ${pred_path}.${method_id}_run.output.h5ad

# MULTIOME GEX2ATAC
dataset_id=openproblems_bmmc_multiome_phase2_rna
dataset_path=output/datasets/$task_id/$dataset_id/$dataset_id.censor_dataset
pred_path=output/predictions/$task_id/$dataset_id/$dataset_id

target/docker/match_modality_methods/run/${method_id}_run \
  --input_mod1 ${dataset_path}.output_train_mod1.h5ad \
  --input_mod2 ${dataset_path}.output_train_mod2.h5ad \
  --output ${pred_path}.${method_id}_run.output.h5ad

# MULTIOME ATAC2GEX
dataset_id=openproblems_bmmc_multiome_phase2_mod2
dataset_path=output/datasets/$task_id/$dataset_id/$dataset_id.censor_dataset
pred_path=output/predictions/$task_id/$dataset_id/$dataset_id

target/docker/match_modality_methods/run/${method_id}_run \
  --input_mod1 ${dataset_path}.output_train_mod1.h5ad \
  --input_mod2 ${dataset_path}.output_train_mod2.h5ad \
  --output ${pred_path}.${method_id}_run.output.h5ad

# RUN EVALUATION
bin/nextflow run "$PIPELINE_REPO" \
  -r "$PIPELINE_VERSION" \
  -main-script "src/$task_id/workflows/evaluate_submission/main.nf" \
  --solutionDir "output/datasets/$task_id" \
  --predictions "output/predictions/$task_id/**.${method_id}_run.output.h5ad" \
  --publishDir "output/evaluation/$task_id/$method_id/" \
  -latest \
  -resume \
  -c "src/resources/nextflow_moremem.config"