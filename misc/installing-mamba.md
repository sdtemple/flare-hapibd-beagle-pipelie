Additional steps to run flare pipeline
Seth Temple
March 26, 2024

1. `wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh` 
2. `bash Miniforge3-Linux-x86_64.sh`
# exit out of the cluster
# sign back into the cluster
3. `mamba` # check that mamba works
4. `python` # check that python works
5. `exit()`
# move to the git repo folder
6. `mamba env create -f conda-env.yaml # make environment`
7. `conda activate flare24`
8. `bcftools`
9. `tabix`
10. `snakemake -c1 -n --configfile YOUR.yaml`

# this installed mamba and the environment for me for all
# orca0, orca29, wolf

