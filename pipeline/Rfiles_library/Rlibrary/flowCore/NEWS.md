# flowCore 1.15.2

* Modified the logicle and the inverse logicle transformation to make use of the
C++ library provided by Wayne Moore et al.

* Added a function estimateLogicle to automatically estimate the logicle
transformation parameters given a flowFrame and the channels to be transformed
as input.

* Modified the inverseLogicleTransfom function to take the output of a
logicleTransform function as input.

# flowCore 1.21.1

* add TEXT segment parser in readFCStext function for FCS3 when the delimiter characters existing inside of
keyword values. Note this parser require all keywords and their values to be non-empty, which conforms to FCS3 standard

# flowCore 1.21.5

* add .readFCSdataRaw routine to read FCS containing bit-packed integer data (with odd-bitwidth like 9,11 instead of 8,16,32,64)
.Currently the bit-wise manipulation is done within R,it can be moved to C if speed issue becomes a problem in the future.

# flowCore 1.23.2

* add new classes "filters", "filtersList" to allow flowViz to plot multiple filters/gates for one flowFrame

# flowCore 1.23.3

* add argument "emptyValue" to read.FCS API so that parser can still work correctly when either cases below occurs :
    1. there is double-delimiter in keyword values (sometime like \\c:\\path\\...)
    2. there is empty keyword value  (\\keyword1\\value1\\keyword2\\\\keyword3)

# flowCore 1.23.7

* fix the bug that malformed spillover matrix in write.FCS

# flowCore 1.29.25

* Copied 'featureSignif' and other required functions from the 'feature' package
into 'flowCore', to remove an undesired dependency on tcltk (caught in the
dependency chain from 'feature'). These functions have been collated into
'feature.R'.

# flowCore 1.31.15

* Deprecation
    + 'filterSet' and 'workFlow' are deprecated by 'flowWorkspace::GatingSet'
    + update vignette by using 'GatingSet'
* Enhancement
    + support 'SPILLOVER` in `read.FCS` besides the existing keywords ("SPILL", "spillover")
    + support reading(`read.FCS` ) bad FCS files exported by flowJo that do not follow standards strictly
    + support 'ncdfFlowList' in 'findTimeChannel' function

# flowCore 1.37.6

* read.FCS
    + supports FCS that has diverse bit widths across parameters/channels
    + supports FCS that uses big integer (i.e. uint32 > R's integer.max)
    write.FCS
    + Fixes several bugs so that this API is now more usable 

# flowCore 1.47.10

+ All documentation converted converted to roxygen2 with some additions and reorganization

# flowCore 1.53.x

+ 'workFlow' class and related classes and methods now defunct #148 -- superseded by flowWorkspace
+ Add support for multiple data segments in 'read.FCSheader'
+ Fixed some edge cases with 'read.FCS 'with column.pattern argument #157
+ Added 'transform_gate' methods for geometric transformations of gates
+ Added 'collapse_desc' for coercing keyword lists in to character
+ 'spillover' method for calculating compensation matrix from a 'flowSet' of controls moved to 'flowStats'
+ Added 'filter_keywords' for filtering lists of keywords
+ Deprecate `description` and `description<-` for `keyword` and `keyword<-` to reduce redundancy and give consistent behavior for `cytoframe` RGLab/flowWorkspace #311

# flowCore 2.0.0

+ keyword<- behaves now as normal replacement method, i.e. keyword(fr) <- list(name = value) will replace the entire keyword list instead of partial updating/inserting, to achieve latter, use keyword(fr)["name"] <- value
+ [ method (e.g. fr[, 1:4]) no longer deletes $PnX keywords automatically so that it is compatible with cytoframe