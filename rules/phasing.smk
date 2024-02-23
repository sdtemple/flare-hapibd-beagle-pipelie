##### haplotype phasing

# remove the phase in reference samples
rule unphase_ref:
    input:
        refvcf='{study}/gtdata/refpop/chr{num}.vcf.gz',
    output:
        refvcf='{study}/gtdata/refpop/chr{num}.unphased.vcf.gz',
    params:
        rmphase=str(config['fixed']['programs']['remove-phase']),
    shell:
        '''
        zcat {input.refvcf} | java -jar {params.rmphase} 100395 | gzip -c > {output.refvcf}
        '''

# remove phase in admixed samples
rule unphase_adx:
    input:
        adxvcf='{study}/gtdata/adxpop/chr{num}.vcf.gz',
    output:
        adxvcf='{study}/gtdata/adxpop/chr{num}.unphased.vcf.gz',
    params:
        rmphase=str(config['fixed']['programs']['remove-phase']),
    shell:
        '''
        zcat {input.adxvcf} | java -jar {params.rmphase} 100395 | gzip -c > {output.adxvcf}
        '''

# merge the unphased files

rule isec:
    input:
        adxvcf='{study}/gtdata/adxpop/chr{num}.unphased.vcf.gz',
        refvcf='{study}/gtdata/refpop/chr{num}.unphased.vcf.gz',
    output:
        intersection='{study}/gtdata/all/chr{num}.intersection.txt',
    shell:
        '''
        tabix -fp vcf {input.adxvcf}
        tabix -fp vcf {input.refvcf}
        bcftools isec -O z -o {output.intersection} {input.adxvcf} {input.refvcf}
        '''

rule merge_vcfs:
    input:
        adxvcf='{study}/gtdata/adxpop/chr{num}.unphased.vcf.gz',
        refvcf='{study}/gtdata/refpop/chr{num}.unphased.vcf.gz',
        intersection'{study}/gtdata/all/chr{num}.intersection.txt'
    output:
        allvcf='{study}/gtdata/all/chr{num}.unphased.vcf.gz',
    shell:
        '''
        tabix -fp vcf {input.adxvcf}
        tabix -fp vc {input.refvcf}
        bcftools merge -O z -R {input.intersection} -o {output.allvcf} {input.adxvcf} {input.refvcf}
        rm {input.adxvcf} {input.refvcf}
        rm {input.adxvcf}.tbi {input.refvcf}.tbi
        '''

# another phasing strategy
# phase using ref and admixs all together
# helps w/ phase consistency
# i reviewed a paper that says 
# this controls switch errors better
rule phase_all:
    input:
        allvcf='{study}/gtdata/all/chr{num}.unphased.vcf.gz',
        chrmap='{study}/maps/chr{num}.map',
    output:
        allvcf='{study}/gtdata/all/chr{num}.rephased.vcf.gz',
    params:
        phase=str(config['fixed']['programs']['beagle']),
        allvcfout='{study}/gtdata/all/chr{num}.rephased',
        xmx=config['change']['cluster-resources']['xmxmem'],
        thr=config['change']['cluster-resources']['threads'],
        excludesamples=str(config['change']['existing-data']['exclude-samples']),
    shell:
        '''
        java -Xmx{params.xmx}g -jar {params.phase} \
            gt={input.allvcf} \
            map={input.chrmap} \
            out={params.allvcfout} \
            nthreads={params.thr} \
            excludesamples={params.excludesamples}
        rm {input.allvcf}
        rm {input.allvcf}.tbi
        '''

# subset the phased files for admixed samples
rule subset_phased_adx:
    input:
        allvcf='{study}/gtdata/all/chr{num}.rephased.vcf.gz',
        adxsam='{study}/gtdata/adxpop/chr{num}.sample.txt'
    output:
        adxvcf='{study}/gtdata/adxpop/chr{num}.rephased.vcf.gz',
    shell:
        '''
        tabix -fp vcf {input.allvcf}
        bcftools view -S {input.adxsam} -O z -o {output.adxvcf} {input.allvcf}
        '''

# subset the phased files for reference samples
rule subset_phased_ref:
    input:
        allvcf='{study}/gtdata/all/chr{num}.rephased.vcf.gz',
        refsam='{study}/gtdata/refpop/chr{num}.sample.txt'
    output:
        refvcf='{study}/gtdata/refpop/chr{num}.rephased.vcf.gz',
    shell:
        '''
        tabix -fp vcf {input.allvcf}
        bcftools view -S {input.refsam} -O z -o {output.refvcf} {input.allvcf}
        '''