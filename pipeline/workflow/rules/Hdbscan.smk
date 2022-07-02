"""
Performs the HDBscan algorithm
"""


rule HDBscanner:
            input:
                "checks/convert.done"

            params:
                expand("{sample}", sample = config["paths"])

            output:
                  touch("checks/scan.done")



            message: "Starting with executing HDBscan algorithm"

            shell:
                  "Rscript workflow/R/Hdbscan.R {params}"