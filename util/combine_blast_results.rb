#=== config ===
#pattern = "Hsj_454isotigs.fna_*.fasta.vs.nr.blastp.fmt7c.txt"
#pattern = "Hsj_454singletons.lt100.fna_*.fasta.vs.nr.blastp.fmt7c.txt"
#pattern = "Rsp_454isotigs.fna_*.fasta.vs.nr.blastp.fmt7c.txt"
#pattern = "Nta_454isotigs.fna_*.fasta.vs.nr.blastp.fmt7c.txt"
#pattern = "Rsp_454singletons.lt100.fna_*.fasta.vs.nr.blastp.fmt7c.txt"
#pattern = "Nta_454singletons.lt100.fna_*.fasta.vs.nr.blastp.fmt7c.txt"
pattern = "Trinity_Nmon_2nd.cdest96.fa_*.fasta.vs.nr.blastx.fmt7c.txt"
#===

files  = Dir[pattern]


pattern_r = %r{#{pattern.sub(/\*/, '(\d+)')}}
 puts pattern_r



files_sorted =  files.select{|f| pattern_r.match(f)}.sort{|a, b| 
  ma = pattern_r.match(a)
  num_a = ma[1].to_i
  mb = pattern_r.match(b)
  num_b = mb[1].to_i
  num_a <=> num_b
}

puts "#{files_sorted.size} files found."
puts ""
files_sorted.each_with_index{|f, i|  puts [i + 1, f].join("\t")}

outf = pattern.sub(/\*/, 'ALL')
File.open(outf, "w") do |o|
  files_sorted.each do |f|
    o.puts File.open(f).read
  end
end

puts ""
puts "saved in #{outf}"
