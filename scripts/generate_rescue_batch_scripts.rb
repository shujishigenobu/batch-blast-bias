failed_script_list = "failed_batch_scripts.txt"
batch_script_dir = "batch_scripts"
new_q = "small,cat"
new_ncpu = 8

scripts = File.open(failed_script_list).read.strip.split(/\n/).map{|l| l.strip}

scripts.each do |s|
  txt = File.open("#{batch_script_dir}/#{s}").read
  txt.sub!(/^\#\$\s+\-q\s+.+/, "\#$ -q #{new_q}")
  txt.sub!(/^NCPU=\d+/, "NCPU=#{new_ncpu}")
  txt.sub!(/^(\#\$ .+)\n/, "\\1\n\#$ -pe smp #{new_ncpu}\n")
  File.open(s, "w"){|o|
    o.puts txt
    STDERR.puts "new #{s} generated in the current directory."
  }
end
