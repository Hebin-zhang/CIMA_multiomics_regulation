rule all:
    input:
        "results/reports/project_initialized.txt"

rule init_flag:
    output:
        "results/reports/project_initialized.txt"
    shell:
        "mkdir -p results/reports && echo initialized > {output}"
