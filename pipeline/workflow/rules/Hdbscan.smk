"""
Performs the HDBscan
"""

rule visual:
          input:
              "data/"
          
          output:
              "images/Hdbscan_output.png"
              
              
          threads: 16
              
          message: "Started with executing HDBscanner..."
            
          shell:
              "Rscript workflow/R/Hdbscan.R {input}"