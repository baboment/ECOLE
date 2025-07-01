#!/usr/bin/env bash
# indexing bam file
for filename in ./finetune_example_data/bams/*.bam; do
    echo "$filename"
    samtools index "$filename"

done

# create a folder for read depth data of the samples
mkdir -p read_depths

# generating the read depth data of the samples
for filename in ./finetune_example_data/bams/*.bam; do
    f="$(basename -- "$filename")"
    sambamba depth base -L hglft_genome_64dc_dcbaa0.bed "$filename" > "./read_depths/${f}.txt"

done

mkdir -p processed_finetuning_samples

# run the preprocess script preprocess_sample.py
python3 ./scripts/finetune_preprocess_sample.py \
  --readdepth ./read_depths \
  --output ./processed_finetuning_samples \
  --target hglft_genome_64dc_dcbaa0.bed
python3 ./scripts/create_dataset.py --input ./processed_finetuning_samples/
