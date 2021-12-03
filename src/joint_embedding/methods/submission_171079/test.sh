#!/bin/bash

export PIPELINE_REPO="openproblems-bio/neurips2021_multimodal_viash"
export NXF_VER=21.04.1
export PIPELINE_VERSION=1.4.0
method_id=submission_171079
task_id=joint_embedding

# CITE
dataset_id=openproblems_bmmc_cite_phase2_rna
dataset_path=output/datasets/$task_id/$dataset_id/$dataset_id.censor_dataset
pretrain_path=output/pretrain/$task_id/$method_id/$dataset_id.${method_id}_train.output_pretrain/
pred_path=output/predictions/$task_id/$dataset_id/$dataset_id

target/docker/match_modality_methods/train/${method_id}_train \
  --input_mod1 ${dataset_path}.output_mod1.h5ad \
  --input_mod2 ${dataset_path}.output_mod2.h5ad \
  --input_sol ${dataset_path}.output_sol.h5ad \
  --output_pretrain ${pretrain_path}

target/docker/match_modality_methods/run/${method_id}_run \
  --input_mod1 ${dataset_path}.output_mod1.h5ad \
  --input_mod2 ${dataset_path}.output_mod2.h5ad \
  --input_pretrain ${pretrain_path} \
  --output ${pred_path}.${method_id}_run.output.h5ad

# MULTIOME
dataset_id=openproblems_bmmc_multiome_phase2_rna
dataset_path=output/datasets/$task_id/$dataset_id/$dataset_id.censor_dataset
pretrain_path=output/pretrain/$task_id/$method_id/$dataset_id.${method_id}_train.output_pretrain/
pred_path=output/predictions/$task_id/$dataset_id/$dataset_id

target/docker/match_modality_methods/train/${method_id}_train \
  --input_mod1 ${dataset_path}.output_mod1.h5ad \
  --input_mod2 ${dataset_path}.output_mod2.h5ad \
  --input_sol ${dataset_path}.output_sol.h5ad \
  --output_pretrain ${pretrain_path}

target/docker/match_modality_methods/run/${method_id}_run \
  --input_mod1 ${dataset_path}.output_mod1.h5ad \
  --input_mod2 ${dataset_path}.output_mod2.h5ad \
  --input_pretrain ${pretrain_path} \
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

cat "output/evaluation/$task_id/$method_id/output.final_scores.output_json.json"