# All info about the analysis for the paper

1. Start with 5 individuals (from here https://www.internationalgenome.org/data-portal/population/BedouinHGDP)
   - Get all the reads from one individual by downloading the tsv file.
   - Create the folder for each individual and add the corresponding tsv file.
   - run the `dl.sh` script using the `loopDL.sh` script.
  *Don't forget to add header to the job*.

2. Merge all the forward reads together and all the reverse reads together `cat *1.fastq.gz > concatenated_1.fastq.gz`
3. Map it to the Pangenome
   - Create GAM
   - Create BAM 

call using the same https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7115999/

Send the 5 * 2 vcfs

Create the pipeline for the 40

Redo it all
