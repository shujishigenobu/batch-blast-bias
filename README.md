batch-blast-bias
================

Convenient scripts for batch blast search on NIBB bias

Compatible with updated bias4 (April 1, 2014).

## Requrement

*  ruby
*  rake
*  NCBI blast+ (not classical blastall)

## Quick Start

### 1) Download software

Download `batch-blast-bias` package from https://github.com/shujishigenobu/batch-blast-bias/archive/1.0.tar.gz and then extract it.

Or you can clone the latest version of `batch-blast-bias` from github using `git` command.

```bash
$ git clone git://github.com/shujishigenobu/batch-blast-bias.git
```

You can also download `example.fasta` for practice from https://github.com/shujishigenobu/batch-blast-bias/downloads .

### 2) Prepare coniguration file, conf.yml

`batch-blast-bias` requires `conf.yml`, a configuration file. An example file is included in the package. It would be good idea to create your own `conf.yml` from `conf.yml.example`.

```bash
$ cp conf.yml.example conf.yml
```

Edit `conf.yml` using your favorite editor. An example is as follows:

```yaml
query: example.fasta
db:    /bio/db/blast/db/swissprot
num_fasta_per_subfile: 100

batch_script_template:     templates/run_blastx.sh.template
batch_script_template_sge: templates/sge.bias.small
```

### 3) 4 steps for starting batch jobs

```bash
$  rake build_batch_template
```
edit `build_batch_template` if needed.

```bash
$  rake split_query
$  rake generate_batch_jobs
$  rake sge_submit_jobs
```
Now your jobs are queued. Monitor your jobs by SGE command like `qstat`.

### 4) 3 steps for combine BLAST results

```bash
$ rake postchk_sge
$ rake combine_blast_results
$ rake finalize
```

## Tips

### Monitor progress

Use `scripts/monitor_progress.rb`

(example)
```bash
$ ruby scripts/monitor_progress.rb

ORF_Dpul_131012.pep_1.fasta     job1    100
ORF_Dpul_131012.pep_2.fasta     job112  100
...
ORF_Dpul_131012.pep_658.fasta	job621	100
ORF_Dpul_131012.pep_659.fasta	job622	60
# 64300 / 65860 (97.63%)
```
Columns are 1) query name, 2) job ID and 3) number of completed queries.

### Find/Rescue failed jobs

Useful scripts:
- `scripts/rescue_killed_jobs.rb`
- ``scripts/detect_failed_batch_scripts.rb`






## License

Copyright 2012 Shuji Shigenobu.

Licensed under the MIT License
