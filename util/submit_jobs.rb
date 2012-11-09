script_dir = ARGV[0]

Dir["#{script_dir}/*.job*.sh"].each do |f|
  cmd = "qsub -v PATH #{f}"
  system  cmd
end
