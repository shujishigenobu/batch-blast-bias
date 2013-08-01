#=== conf ===
new_queue = "medium"
#===

ORIGINAL_SCRIPT_DIR = "batch_scripts"
# NEW_SCRIPT_DIR = "batch_scripts_rescue"
NEW_SCRIPT_DIR = "batch_scripts_rescue2"
BATCH_LOG_DIR = "batch_logs"

failed_scripts = []

cmd = "grep Killed #{BATCH_LOG_DIR}/run_blast_batch.job*.sh.e*"
IO.popen(cmd){|io|
  io.each do |l|
    script = l.split(/:/)[0].sub(/\.e\d+$/, "")
    failed_scripts << script
  end
}

Dir.mkdir(NEW_SCRIPT_DIR)

failed_scripts.each do |f|
  ff = File.basename(f)
  path = "#{ORIGINAL_SCRIPT_DIR}/#{ff}"
  txt = File.open(path).read
  txt.sub!(/-q small/, "-q #{new_queue} ")
  txt.sub!(/^QUERY\=/, "QUERY=../")
  newscript = "#{NEW_SCRIPT_DIR}/#{ff}"
  File.open(newscript, "w"){|o| o.puts txt}
end

