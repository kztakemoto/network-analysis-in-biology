Network Data in Edgelist Format
# Gene Regulatory Network
* ecoli_regDB5.txt 
  * Escherichia coli
  * http://regulondb.ccg.unam.mx (version 5)
  * https://doi.org/10.1093/nar/gkj156

Protein contact networks
* protein_structure_1BKS_A.txt
  * TRYPTOPHAN SYNTHASE (E.C.4.2.1.20) FROM SALMONELLA TYPHIMURIUM
  * PDB: IBKS (chain A)
  * https://doi.org/10.2197/ipsjtbio.3.40
* protein_structure_1A6N_A.txt
  * DEOXY-MYOGLOBIN, ATOMIC RESOLUTION
  * PDB: 1A6N (chain A)
  * https://doi.org/10.2197/ipsjtbio.3.40
* protein_structure_2VIK_A.txt
  * REFINED STRUCTURE OF THE ACTIN-SEVERING DOMAIN VILLIN 14T, DETERMINED BY SOLUTION NMR, MINIMIZED AVERAGE STRUCTURE
  * PDB: 2VIK (chain A)
  * https://doi.org/10.2197/ipsjtbio.3.40

# Protein-Protein Interaction Networks
* ecoli_ppi_Hu_etal_2009.txt
  * Escherichia coli
  * https://doi.org/10.1371/journal.pbio.1000096
* yeast_ppi_Batada_etal_2006.txt
  * budding yeast (Saccharomyces cerevisiae)
  * https://doi.org/10.1371/journal.pbio.0040317
* human_ppi_hippie_v2.2.txt
  * Human
  * only used the interactions with confidence score >= 0.7
  * http://cbdm-01.zdv.uni-mainz.de/~mschaefer/hippie/ (version 2.2)
  * https://doi.org/10.1093/nar/gkw985
* breast_cancer_directed_ppi_Kanhaiya_etal_2017.csv
  * Human (with breast cancer)
  * https://doi.org/10.1038/s41598-017-10491-y
  * Metadata
    * drug_target_proteins.csv: list of drug targets
    * breast_cancer_essential_proteins.csv: list of essential genes

# Metabolic Networks (chemical networks)
* metabolic_ecoli.txt
  * Escherichia coli
  * https://www.kegg.jp
  * https://doi.org/10.1093/nar/gky962
* eco_EM+TCA.txt
  * Escherichia coli (Glycolysis / Gluconeogenesis and Citrate cycle (TCA cycle))
  * https://www.kegg.jp
  * https://doi.org/10.1093/nar/gky962
* metabolic_yeast.txt
  * budding yeast (Saccharomyces cerevisiae)
  * https://www.kegg.jp
  * https://doi.org/10.1093/nar/gky962
* metabolic_human.txt
  * Human
  * https://www.kegg.jp
  * https://doi.org/10.1093/nar/gky962

# Human Brain Networks
* human_structural_brain_network_Ardesch_2019.txt
  * Imaging modality: DTI (i.e., structural network)
  * https://doi.org/10.1073/pnas.1818512116
* human_functional_brain_network_1000_Functional_Connectomes.txt
  * Imaging modality: fMRI (i.e., functional network)
  * random matrix theory-based thresholding used
  * subject ID: Cambridge_Buckner_081028_YY28TK
  * https://doi.org/10.1073/pnas.0911855107

# Food-Web Networks
* marine_food_web_pnas_102_15_5443_01562.txt
  * marine food web
  * https://doi.org/10.1073/pnas.0501562102
* terrestrial_food_web_caribbean.txt
  * Terrestrial food web
  * https://www.globalwebdb.com
  * https://doi.org/10.1016/j.tree.2012.08.005
  * https://doi.org/10.2307/1940492
