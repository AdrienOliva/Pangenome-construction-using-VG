# PIPELINE TO CREATE THE PANGENOME
1. Download the chromosome of the reference from here `https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/GCA_000001405.15_GRCh38_assembly_structure/Primary_Assembly/assembled_chromosomes/FASTA/`
2. Concat them by doing `zcat chr{1..22}.fna.gz chrX.fna.gz chrY.fna.gz | cat > concatenated_file.fna`
3. Download the VCF with all individuals from HGDP here `ftp://ngs.sanger.ac.uk/production/hgdp/hgdp_wgs.20190516/hgdp_wgs*`
4. Do the subset of variant in each VCF  ` bcftools view --force-samples -s HGDP01275,HGDP01282,HGDP01256,HGDP01263,HGDP01268,HGDP01270,HGDP01276,HGDP01257,HGDP01264,HGDP01272,HGDP01277,HGDP01258,HGDP01260,HGDP01265,HGDP01254,HGDP01259,HGDP01261,HGDP01266,HGDP01273,HGDP01280,HGDP01255,HGDP01262,HGDP01267,HGDP01279,HGDP01274 --regions chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY -i 'MAF > 0.01' hgdp_wgs.20190516.full.chr10.vcf.gz > bgzip > sub10.vcf.gz`
5. Merge all the VCF together  `bcftools concat sub1.vcf.gz sub2.vcf.gz sub3.vcf.gz sub4.vcf.gz sub5.vcf.gz sub6.vcf.gz sub7.vcf.gz sub8.vcf.gz sub9.vcf.gz sub10.vcf.gz sub11.vcf.gz sub12.vcf.gz sub13.vcf.gz sub14.vcf.gz sub15.vcf.gz sub16.vcf.gz sub17.vcf.gz sub18.vcf.gz sub19.vcf.gz sub20.vcf.gz sub21.vcf.gz sub22.vcf.gz subX.vcf.gz subY.vcf.gz -Oz -o merged.vcf.gz`

6. Then run one command to build the pangenome `vg autoindex --workflow map --prefix /path/to/output --ref-fasta reference.fasta --vcf variants.vcf.gz`





#All info about the analysis for the paper

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
     - So I ran by doing `samtools addreplacerg -r '@RG\tID:samplename\tSM:samplename' concat.bam -o concat_readgroup.bam`
     - Then need to sort using `samtools sort concat_readgroup.bam > concat_readgroup_sorted.bam`
     - Then index using `samtools index concat_readgroup_sorted.bam`
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
