ASN=%ASN%

OUT=`basename $ASN .asn`.xml
blast_formatter  -archive $ASN -outfmt 5 > $OUT

OUT=`basename $ASN .asn`.fmt7
blast_formatter  -archive $ASN -outfmt "7 std qlen slen stitle staxid ssciname sskingdom" > $OUT


