import gzip
import sys

newfile = sys.argv[2]
g = gzip.open(newfile,'wb')

with gzip.open(sys.argv[1],'rb') as f:
    for line in f:
        if line[:2] == '##':
            g.write(line)
        elif line[:2] == '#C':
            g.write(line)
        else:
            full_row = line.split()
            info_data = full_row[:9]
            geno_data = full_row[9:]
            geno_data = [geno.replace(b'|',b'/') for geno in geno_data]
            g.write(b'\t'.join(info_data))
            g.write(b'\t')
            g.write(b'\t'.join(geno_data))
            g.write(b'\n')
            
g.close()