# Meta-Pipeline
## A Galaxy workflow to do taxonomical classification.

Welcome to Meta-Pipeline!

Metagenomics has been increasingly becoming very important in studies of human and animal health. It has become clear that bacteria in and on our bodies are very signifcant. Thus there is a big boost in science society who are willling to study metagenomics. When we want to do downstream analysis in our microbial community, the first step is to find out about our community, what the community ultimately looks like. My idea is that compiling the state of the art tools (such as Kraken2, Centrifuge and CLARK) and create a single pipeline that will produce a visualized output file for each tool so the user can compare.

## Usage!
*************************
1- run install.sh with administrative privilages<br/>
    - This will install the Kraken2, Centrifuge and Clark as well as the necessary Databases<br/>
    - Please keep in mind downloading databases might take some time depending on your internet speed.<br/>
    - Clark requires the longest amount of time in order to download and build the DB.<br/>
    - It took nearly 48 hours with connection speed of 10 GBps as it needs to download all the bacterial genomes from NCBI<br/>
    - But do not worry, the script runs the light version of Clark which requires minimum of 4 GB RAM.<br/>

2- run main.sh
    - Select the fasta file you want to analyze.<br/>
    - Tools are going to run in serial method (not parallel)<br/>
    - Once the tools are done with the analysis, it will automatically ask for a threshold and the taxonomic level you want to visualize and compare<br/>
    - Outputs, a bar graph comparing 3 tools, as well as 2 tab-seperated text files<br/>
        - Comparsion_Table.txt is filtered results of percantages based on your threshold each column belonging to regarding tool, while rows represent taxonomical unit<br/>
        - Comparsion_Raw_Table is same as above without filteration.

************************

## How to get involved?

If you are interested and you can make a contribution to the project, please fork it.<br/>
If you find issues, please open an issue on GitHub, i will work on it as soon as possible.

***********************
