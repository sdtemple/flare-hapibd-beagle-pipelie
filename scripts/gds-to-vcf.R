library(SeqArray)
args=commandArgs(trailingOnly=TRUE)

# via SeqArray
filein=seqOpen(args[1])
fileout=args[2]
seqGDS2VCF(filein, fileout)

# library(gdsfmt)
# library(SNPRelate)
# # via SNPRelate
# snpgdsGDS2VCF(gds.fn=filein,vcf.fn=fileout,method=args[4],ignore.chr.prefix=args[3])