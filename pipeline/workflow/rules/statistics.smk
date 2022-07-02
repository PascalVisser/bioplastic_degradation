"""
Calculate statistics for the two comparing files
"""

rule statistics:
            input:
                "checks/scan.done"
            params:
                expand("{sample}",sample=config["files_to_compare"])
            output:
                  touch("checks/stat.done")

            message: "Starting with calculating statistics"

            shell:
                  "Rscript workflow/R/statistics.R {params}"