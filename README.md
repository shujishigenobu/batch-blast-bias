batch-blast-bias
================

convenient scripts for batch blast search on NIBB bias

## Requrement

*  ruby
*  rake
*  NCBI blast+ (not classical blastall)

## Quick Start

### 1) Download software

Download `batch-blast-bias` package from https://github.com/downloads/shujishigenobu/batch-blast-bias/batch-blast-bias-r0.1.1.tar.gz and then extract it.

```bash
$ wget https://github.com/downloads/shujishigenobu/batch-blast-bias/batch-blast-bias-r0.1.1.tar.gz
$ tar xzvf batch-blast-bias-r0.1.1.tar.gz
$ cd batch-blast-bias-r0.1.1  # move to the program directory
```
Alternatively you can download the latest source code from github as follows:

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

If you run `conf.yml.example`, the BLAST result, XXX, should be obtained.


## License

Copyright 2012 Shuji Shigenobu.

Licensed under the MIT License
