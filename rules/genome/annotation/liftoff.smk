rule liftoff: 
    input:
        ref="{ref}.fasta.gz",
        tgt="{tgt}.fasta.gz",
        ann="{ann}.gff.gz",
    output:
        main="{ref}_{ann}_{tgt}.gff3",
        unmapped="{ref}_{ann}_{tgt}.unmapped.txt",
    log:
        "logs/liftoff_{ref}_{ann}_{tgt}.log",
    params:
        extra="-polish",
    threads: 1
    wrapper:
        "v2.2.0/bio/liftoff"