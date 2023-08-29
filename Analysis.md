# All info about the analysis for the paper

1. Start with 5 individuals (from here https://www.internationalgenome.org/data-portal/population/BedouinHGDP)
   - Get all the reads from one individual by downloading the tsv file.
   - Create the folder for each individual and add the corresponding tsv file.
   - run the `dl.sh` script using the `loopDL.sh` script.
  *Don't forget to add header to the job*.

2. Merge all the forward reads together and all the reverse reads together `cat *1.fastq.gz > concatenated_1.fastq.gz`
3. Map it to the Pangenome
   - Create GAM
     - For now I map each reads separatly as I have an error when mapping paired-end
       `newvg map -x newxg.xg -g wg.gcsa -f HGDP00607/HGDP00607_2.fastq.gz > HGDP00607_2.gam`
     - Concatenate GAM with `cat *.gam > concat.gam`
   - Create BAM with `vg surject -x newxg.xg -b concat.gam > concat.bam`
4. Call variants
   - Using GAM
     - `newvg pack -x newxg.xg -g concat.gam -Q 1  -o concat.gam.pack`
     - `newvg call newxg.xg -k concat.gam.pack > HGDP00607.vcf`
   - Using BAM call using the same https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7115999/
   

Send the 5 * 2 vcfs

Create the pipeline for the 40
