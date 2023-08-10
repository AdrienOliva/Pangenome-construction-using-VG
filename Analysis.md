# All info about the analysis for the paper

1. Start with 5 individuals (from here https://www.internationalgenome.org/data-portal/population/BedouinHGDP)
   - Get all the reads from one individual by downloading the tsv file.
     - Then run `awk '{print "wget " $1}' file.tsv` to recover all the file needed for one individual.
  *Don't forget to add header to the job*.

   OR
   - Download the CRAM file (if unmapped reads are in the file) and transform it in fasta using: `IDKIDKIDK`

  
  
produce gam / bam 

call using the same https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7115999/

Send the 5 * 2 vcfs

Create the pipeline for the 40

Redo it all
