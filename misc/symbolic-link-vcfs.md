If you don't want to rewrite VCF files that exist
You should run this

1. Make your analysis folder
- `mkdir your-analysis`
- `cd your-analysis`
-` mkdir gtdata`
- `cd gtdata`
- `mkdir refpop`
- `cd refpop`
2. Make symbolic links
- `ln -s /nfs/orca0_home6/reference_files/1KG_from_pearson/1kGP_high_coverage_Illumina.chr22.filtered.SNV_INDEL_SV_phased_panel.vcf.gz chr22.vcf.gz`
- `for j in $(seq 21 -1 1); do ln -s /nfs/orca0_home6/reference_files/1KG_from_pearson/1kGP_high_coverage_Illumina.chr$j.filtered.SNV_INDEL_SV_phased_panel.vcf.gz chr$j.vcf.gz; done;`

# first go to your analysis folder
# ln -s /nfs/orca0_home6/reference_files/1KG_from_pearson/1kGP_high_coverage_Illumina.chr22.filtered.SNV_INDEL_SV_phased_panel.vcf.gz chr22.vcf.gz

