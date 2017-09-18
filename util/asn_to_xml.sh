ASN=MEGCR_proteins400.pep.fasta.vs.Dmel_refseqp.fasta.blastp.asn

OUT=`basename $ASN .asn`.xml

blast_formatter  -archive $ASN -outfmt 5 > $OUT
