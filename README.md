# Meta-Pipeline
## A single-pipeline constituted to do taxonomical classification on a regular laptop.

Welcome to Meta-Pipeline!

Metagenomics has been increasingly becoming very important in studies of human and animal health. It has become clear that bacteria in and on our bodies are very signifcant. Thus there is a big boost in science society who are willling to study metagenomics. When we want to do downstream analysis in our microbial community, the first step is to find out about our community, what the community ultimately looks like. My idea is that compiling the state of the art tools (such as Kraken2, Centrifuge and CLARK) and create a single pipeline that will produce a visualized output file for each tool so the user can compare.

## Usage!
*************************
#### 1- run install.sh with administrative privilages
    - This will install the Kraken2, Centrifuge and Clark as well as the necessary Databases
    - Please keep in mind downloading databases might take some time depending on your internet speed.
    - Clark requires the longest amount of time in order to download and build the DB.
    - It took nearly 48 hours with connection speed of 10 GBps as it needs to download all the bacterial genomes from NCBI
    - But do not worry, the script runs the light version of Clark which requires minimum of 4 GB RAM.

#### 2- run main.sh
    - Select the fasta file you want to analyze.
    - Tools are going to run in serial method (not parallel)
    - Once the tools are done with the analysis, it will automatically ask for a threshold and the taxonomic level you want to visualize and compare
    - Outputs, a bar graph comparing 3 tools, as well as 2 tab-seperated text files
        - Comparsion_Table.txt is filtered results of percantages based on your threshold each column belonging to regarding tool, while rows represent taxonomical unit
        - Comparsion_Raw_Table is same as above without filteration.

************************
## Sample Output
![Comparison of outputs in a bar plot](/sample/bar_grouped.png)

### Sample Output of CSV files.
There are two csv files produced filtered one includes only the user defined taxonomy level (Pyhlum, Genus or Species) above a threshold set by the user while raw csv files includes everything. Below is the sample of filtered csv file at Pyhlum level, threshold is set to 5 percent. 

![image](https://user-images.githubusercontent.com/41537897/132210950-d7f0f1ef-2f14-4bbc-9e7e-dd28fe97239e.png)


************************
## How to get involved?

If you are interested and you can make a contribution to the project, please fork it.
If you find issues, please open an issue on GitHub, i will work on it as soon as possible.

***********************
