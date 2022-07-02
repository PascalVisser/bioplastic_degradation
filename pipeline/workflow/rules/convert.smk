"""
Downloads required packages and
converts fcs files to csv files
"""


rule download_packages:
                output:
                      touch("checks/download.done")

                message: "Starting with downloading packages"

                shell:
                      "Rscript workflow/R/library.R"



rule convert_to_csv:
          input:
                expand("{sample}", sample = config["paths"])
          
          output:
                touch("checks/convert.done")

          message: "Started with converting FCS file to CSV file"
            
          shell:
              "Rscript workflow/R/fsc_converter.R {input}"


