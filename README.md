## Pipeline for local ancestry & IBD inference, 

This pipeline performs phasing, IBD segment detection, and local ancestry inference for an analysis of target admixed samples.

You can look at `dag-240223.png` to see what the pipeline looks like.

### Installation

1. `git clone https://github.com/sdtemple/flare-hapibd-beagle-pipeline`
2. Install `java` so as to be able to run `java -jar` on terminal
3. `bash get-software.sh software` (requires `wget`)
4. `conda env create -f conda-env.yml`
    - I recommend using `mamba` of some sort (https://mamba.readthedocs.io/en/latest/index.html)
    - In which case, `mamba env create -f conda-env.yml`

### Requirements

- GDS files for each chromosome
    - Reference samples
    - Target admixed samples
- Map between reference sample IDs to their reference panel
    - Point to this file in your YAML settings

### Run the pipeline 

1. `conda activate flare24`
2. Modify the `your.analysis.arguments.yaml` file
    - See the `change:` settings
    - You need to choose a reference sample!
3. `snakemake -c1 -n`
    - This is a dry run to see what will be run
4. `nohup snakemake -c1 --latency-wait 300 --keep-going --cluster " [your command]  " --configfile your.analysis.arguments.yaml --jobs XXX &`
    - Other useful `snakemake` commands
        - `--rerun-incomplete`
        - `--rerun-triggers mtime`
        - `--force-all`
    - Commands for `qsub`
        - `--cluster "qsub -q your-queue.q -m e -M your.email@uni.edu -pe local XXX -l h_vmem=XXXG -V" `
        - "-V" is important to pass in your conda environment!
        - "-pe local XXX" is how many threads you will use
        - You don't have to send emails to yourself if you don't want to
    - Commands for `slurm`
        - TBD
    - You can sign out of cluster. `no hup ... &` will keep this as an ongoing process until complete
5. Your LAI results in a `lai/` folder
6. Your IBD results in a `ibdsegs/` folder
    - By default, do not detect IBD segments

For reproducibility, the `arguments.yaml` in the main folder says what you ran. Don't change it ever!

For robustness, you can create different `*.yaml` settings and see how results change. 

Make sure to change the `your-analysis-folder` setting.

### Other notes

There are two phasing strategies:
- Use the reference to phase the target sample (could introduce imputed values)
    - This will likely create more markers in the target sample data
- Rephase target and reference targets altogether
    - This will likely create fewer markers in reference and target sample data

You can call detect IBD segments by removing the comments in record_yaml rule.

Possible bugs:
- Names are difference in CHROM column between reference and target samples
- Running out of memory: increase cluster-resouces:xmxmem in yaml and terminal pass into `--cluster`
- Reference sample is not phased
- JAR file is corrupted: download a fresh version 

### Contact

Seth D. Temple

sdtemple.github.io

sdtemple@uw.edu

### Citation

If we publish this pipeline somewhere, I will point out the paper.

For now, please acknowledge me in publication (smiley face)

### Development

- This repo currently uses snakemake 7.25.2
    - May extend to version 8 as I develop familiarity in other repos
- Implement other local ancestry inference software
    - For example, MOSAIC from Salter-Townshend and Myers
- Impute other phasing software
    - For example, SHAPEIT
    - Add in flexibility of Beagle parameters
- Robustness to SNP GDS versus SEQ GDS formats
    - Currently assuming SEQ GDS
    - Had issues with SNP GDS