require 'bio'

include Bio

$fastaf = ARGV[0]
$num_entries = ARGV[1].to_i

container = []
i = 0
FlatFile.open(FastaFormat, ARGV[0]).each do |fas|
  container << fas
  if container.size == $num_entries
    outf = File.basename($fastaf) + "_#{i+=1}.fasta"
    STDERR.puts [outf, container.size].join("\t")
    File.open(outf, "w"){|o| o.puts container}
    container = []
  end
end

outf = File.basename($fastaf) + "_#{i+=1}.fasta"
File.open(outf, "w"){|o| o.puts container}
STDERR.puts [outf, container.size].join("\t")
