require 'rake/clean'

query = "example.fasta"
num_per_subfasta = 100

CLOBBER.include(:default)

DIR_FASTA_SPLIT = "fasta_split"
directory DIR_FASTA_SPLIT

DIR_BATCH_SCRIPTS = "batch_scripts"
directory DIR_BATCH_SCRIPTS

DIR_SGE_LOGS = "batch_logs"
directory DIR_SGE_LOGS

BATCH_SCRIPT_TEMPLATE = "run_blastx_nr_example.template.sh"

# $blast_result_combined = nil

task :default => :generate_batch_jobs

desc "split query fasta files"
task :split_query do 
  puts "split_query"

  sh "ruby util/split_fasta.rb #{query} #{num_per_subfasta} #{DIR_FASTA_SPLIT}"
end

desc "generate scripts for batch BLAST searches"
file :generate_batch_jobs => FileList["#{DIR_FASTA_SPLIT}/*[0-9].fasta"] do |t|
  target_list = File.basename(BATCH_SCRIPT_TEMPLATE, ".template.sh") + ".list"
  sh "touch #{target_list}"
  sh "echo '#FASTAF' > #{target_list}"
  sh "ls -1 #{DIR_FASTA_SPLIT}/*[0-9].fasta >> #{target_list}"
  sh "ruby util/generate_batch_jobs.rb #{BATCH_SCRIPT_TEMPLATE} #{target_list} #{DIR_BATCH_SCRIPTS}"
end

desc "submit job scripts to SGE"
task :sge_submit_jobs do 
  FileList["#{DIR_BATCH_SCRIPTS}/*.job*.sh"].each do |f|
    sh "qsub -v PATH #{f}"
  end
end


desc "SGE result checking"
task :postchk_sge => DIR_SGE_LOGS do |t|
  suffix = ".vs.swissprot.blastx.fmt7.txt"
  result_files = FileList["fasta_split/*[0-9].fasta"].map{|f| File.basename(f) + suffix}
  result_files.each do |f|
    unless File.exists?("#{f}.finished")
      raise "ERROR: the following job has not been completed. \n#{f} "
    end
  end

  FileList["#{DIR_BATCH_SCRIPTS}/*.job*.sh"].each do |f|
    logs = FileList["#{File.basename(f)}.*"]
    sh "mv #{logs.join(' ')}  #{DIR_SGE_LOGS}"
  end
end


desc "combine blast job results into a single file"
task :combine_blast_results do
  suffix = ".vs.swissprot.blastx.fmt7.txt"
  result_files = FileList["fasta_split/*[0-9].fasta"].map{|f| File.basename(f) + suffix}
  result_files_sorted = result_files.sort{|a, b| 
    ma = /\d+\.fasta#{suffix}/.match(a)
    num_a = ma[1].to_i
    mb = /\d+\.fasta#{suffix}/.match(b)
    num_b = mb[1].to_i
    num_a <=> num_b
  }
#  p result_files_sorted
  puts "#{result_files_sorted.size} files found."

  outf = result_files_sorted[0].dup.sub(/_1.fasta/, '_ALL.fasta')

  File.open(outf, "w") do |o|
    result_files_sorted.each do |f|
      o.puts File.open(f).read
    end
  end
  puts "saved in #{outf}"
end

desc "Final check and cleaning"
task :finalize do |t|
  blast_results_combined = FileList["*_ALL.fasta.vs.*blast*.txt"].first

  unless blast_results_combined
    raise "combined blast result file has not been generated."
  end
  num_records = 0
  File.open(blast_results_combined).each do |l|
    num_records += 1 if /^\# T*BLAST[NXP] \d/.match(l)
  end

  num_fasta = 0
  File.open(query).each do |l|
    num_fasta += 1 if /^>/.match(l)
  end
  
  if  num_fasta == num_records
    sh "rm #{query}_[0-9]*.txt"
    sh "rm #{query}_[0-9]*.txt.finished"
    puts "#{blast_results_combined} looks good. BLAST search and post-processing completed."
  else
    raise "ERROR: the number of records is inconsistent between  #{blast_results_combined} and #{query}."
  end
    

end
