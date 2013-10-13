require 'yaml'

c = YAML.load(File.open("conf.yml"))

nseq = 0
q = c['query']
File.open(q).each do |l| 
  nseq += 1 if /^>/.match(l)
end

seq2job = {}
Dir["batch_scripts/run_blast_batch.job*.sh"].each do |f|
  jobid = /run_blast_batch\.(job\d+)\.sh/.match(f)[1]
  m = /^QUERY\=(.+\.fasta)/.match(File.open(f).read)
  seqname = File.basename(m[1])
  seq2job[seqname] = jobid
end

data = []
Dir["*.vs.nr.blast.fmt7.txt"].each do |f|
  counter = 0
  seqname = /.+\.fasta/.match(File.basename(f))[0]
  File.open(f).each do |l|
    counter += 1 if /^\# Query/.match(l)
  end
  data <<  [seqname, seq2job[seqname], counter ]
  [seqname, seq2job[seqname], counter ]

end

data.sort do |a, b| 
  num_a = /_(\d+)\.fasta/.match(a[0])[1].to_i
  num_b = /_(\d+)\.fasta/.match(b[0])[1].to_i
  num_a <=> num_b
end.each do |x|
  puts x.join("\t")
end

total = data.map{|d| d[2]}.inject(0){|i, j| j += i}
puts "# #{total} / #{nseq} (" + sprintf("%.2f%%", total.to_f / nseq * 100) + ")"
