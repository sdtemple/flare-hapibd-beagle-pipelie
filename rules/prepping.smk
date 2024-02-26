##### prepare the vcf files

### inputs, string management, count sample size, make mac
macro=str(config['change']['want-data']['your-analysis-folder'])
low=int(float(str(config['change']['want-data']['chr-low'])))
high=int(float(str(config['change']['want-data']['chr-high'])))
refgdsfolder=str(config['change']['existing-data']['ref-gds-folder'])
refgdsprefix=str(config['change']['existing-data']['ref-gds-prefix'])
refgdssuffix=str(config['change']['existing-data']['ref-gds-suffix'])
adxgdsfolder=str(config['change']['existing-data']['adx-gds-folder'])
adxgdsprefix=str(config['change']['existing-data']['adx-gds-prefix'])
adxgdssuffix=str(config['change']['existing-data']['adx-gds-suffix'])


### ln -s the gds files

# direct to the gds file for reference samples
rule copy_ln_gds_ref:
    input:
        refgds=refgdsfolder + '/' + refgdsprefix + '{num}' + refgdssuffix,
        maps='{study}/maps/chr{num}.map',
    output:
        refgds='{study}/gtdata/refpop/chr{num}.gds',
    shell:
        '''
        ln -s {input.refgds} {output.refgds}
        '''

# direct to the gds file for admixed samples
rule copy_ln_gds_adx:
    input:
        adxgds=adxgdsfolder + '/' + adxgdsprefix + '{num}' + adxgdssuffix,
        maps='{study}/maps/chr{num}.map',
    output:
        adxgds='{study}/gtdata/adxpop/chr{num}.gds',
    shell:
        '''
        ln -s {input.adxgds} {output.adxgds}
        '''

### convert gds to vcf

# convert gds to vcf for reference samples
rule gds_to_vcf_ref:
    input:
        refgds='{study}/gtdata/refpop/chr{num}.gds',
    output:
        refvcf='{study}/gtdata/refpop/chr{num}.vcf.gz',
    params:
        script=str(config['change']['pipe']['scripts'] + '/gds-to-vcf.R'),
    shell:
        '''
        Rscript --vanilla {params.script} {input.refgds} {output.refvcf}
        rm -f {input.refgds}.seq.gds
        '''

# convert gds to vcf for admixed samples
rule gds_to_vcf_adx:
    input:
        adxgds='{study}/gtdata/adxpop/chr{num}.gds',
    output:
        adxvcf='{study}/gtdata/adxpop/chr{num}.vcf.gz',
    params:
        script=str(config['change']['pipe']['scripts'] + '/gds-to-vcf.R'),
    shell:
        '''
        Rscript --vanilla {params.script} {input.adxgds} {output.adxvcf}
        rm -f {input.adxgds}.seq.gds
        '''

# filter vcf files by minimum allele count
rule shrink_vcf_adx:
    input:
        adxvcf='{study}/gtdata/adxpop/chr{num}.vcf.gz',
    output:
        adxvcfshrink='{study}/gtdata/adxpop/chr{num}.shrink.vcf.gz',
    params:
        minmac=str(config['change']['bcftools-parameters']['c-min-mac']),
    shell:
        '''
        tabix -fp vcf {input.adxvcf}
        bcftools view \
            -c {params.minmac}:nonmajor \
            -O z \
            -o {output.adxvcfshrink} \
            {input.adxvcf}
        '''

rule shrink_vcf_ref:
    input:
        refvcf='{study}/gtdata/refpop/chr{num}.vcf.gz',
    output:
        refvcfshrink='{study}/gtdata/refpop/chr{num}.shrink.vcf.gz',
    params:
        minmac=str(config['change']['bcftools-parameters']['c-min-mac']),
    shell:
        '''
        tabix -fp vcf {input.refvcf}
        bcftools view \
            -c {params.minmac}:nonmajor \
            -O z \
            -o {output.refvcfshrink} \
            {input.refvcf}
        '''

### write samples text file

# write the sample names for reference samples
rule write_ref_sample_names:
    input:
        refvcf='{study}/gtdata/refpop/chr{num}.vcf.gz',
    output:
        refsample='{study}/gtdata/refpop/chr{num}.sample.txt',
    shell:
        '''
        bcftools query -l {input.refvcf} > {output.refsample}
        '''

# write the sample names for admixed samples
rule write_adx_sample_names:
    input:
        adxvcf='{study}/gtdata/adxpop/chr{num}.vcf.gz',
    output:
        adxsample='{study}/gtdata/adxpop/chr{num}.sample.txt',
    shell:
        '''
        bcftools query -l {input.adxvcf} > {output.adxsample}
        '''