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
   - Using BAM call
     - Using HaplotypeCaller `gatk HaplotypeCaller --input concat.bam --output HGDP00607_bam.vcf --reference /datastore/oli087/data/reference/ref.fa`
     - I had an error when using `picard ValidateSamFile I=concat.bam MODE=SUMMARY`
Error Type      Count
ERROR:MISSING_READ_GROUP        1
WARNING:MISSING_TAG_NM  787584260
WARNING:RECORD_MISSING_READ_GROUP       791377280
     - So I ran by doing samtools addreplacerg -r '@RG\tID:samplename\tSM:samplename' concat.bam -o concat_readgroup.bam
     - redo the haplotype and check



We could do like (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7115999/) and they used (from their SI):
GATK HaplotypeCaller (44) version 3.5.0, applying genotype priors without bias towards the reference allele through the
`--input_prior 0.001 --input_prior 0.4995` arguments, the `--pcr_indel_model NONE` argument for the PCR-free libraries 
and the `--includeNonVariantSites` argument to include monomorphic sites in the output VCF files.
We wished to apply filters that are equally stringent for variant sites as for non-variant sites.
Any filter that applies to variant sites but not to non-variant sites, e.g. GATK’s Variant
Quality Score Recalibration, comes with a risk of introducing a bias against variants and
thereby introduce skews into various population genetic analyses that rely on the balance
between these two classes of sites.

Send the 5 * 2 vcfs

Create the pipeline for the 40
