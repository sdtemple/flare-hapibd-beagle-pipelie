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
2. (Optional) Do a preliminary analysis to exclude markers or samples
    - Write these in files `excludemarkers.txt` and `excludesamples.txt`
    - They are by default empty 
3. Modify the `your.analysis.arguments.yaml` file
    - See the `change:` settings
4. `snakemake -c1 -n`
    - This is a dry run to see what will be run
5. `nohup snakemake -c1 --latency-wait 300 --keep-going --cluster " [your command]  " --configfile your.analysis.arguments.yaml --jobs XXX &`
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
6. Your LAI results in a `lai/` folder
7. Your IBD results in a `ibdsegs/` folder
    - By default, do not detect IBD segments

For reproducibility, the `arguments.yaml` in the main folder says what you ran. Don't change it ever!

For robustness, you can create different `*.yaml` settings and see how results change. Make sure to change the `your-analysis-folder` setting. 

### Contact

Seth D. Temple
sdtemple.github.io
sdtemple@uw.edu

### Citation

If we publish this pipeline somewhere, I will point out the paper.

For now, please acknowledge me in publication (smiley face)
