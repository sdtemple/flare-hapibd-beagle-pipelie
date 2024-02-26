import pandas as pd
import warnings
import sys
warnings.filterwarnings('ignore')

# inputs
filein1,filein2,fileout=sys.argv[1:]
table1=pd.read_csv(filein1,header=None)
table2=pd.read_csv(filein2,header=None)

# outputs
subtable=table1[table1[0].isin(table2[0])]
subtable=subtable[['CHROM','POS']]
subtable.columns=['CHROM','POS']
subtable.to_csv(fileout,sep='\t',header=False,index=False)

