#=== conf ===
new_queue = "cat"
ncpu = 8
#===

ORIGINAL_SCRIPT_DIR = "batch_scripts"
# NEW_SCRIPT_DIR = "batch_scripts_rescue"
NEW_SCRIPT_DIR = "batch_scripts_rescue2"
BATCH_LOG_DIR = "batch_logs"

seqfiles = Dir["fasta_split/*.fasta"].map{|path| File.basename(path)}

seqf2resf = {}
seqfiles.each do |s|
  seqf2resf[s] = nil
end

p seqf2resf.keys.size

Dir["*.finished"].each do |f|
  queryf = f.split(/\.vs\./)[0]
  seqf2resf[queryf] = f
end

failed_queries = []
seqf2resf.each do |k, v|
  failed_queries << k unless v
end

failed_scripts = []
failed_queries.each do |f|
  cmd = "grep #{f} batch_scripts/*sh"
  IO.popen(cmd){|io| 
    res = io.read
    s = /batch_scripts\/(.+.sh):/.match(res)[1]
    failed_scripts << s
  }
end

puts failed_scripts
