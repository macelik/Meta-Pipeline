#!/bin/bash
#tty -s; if [ $? -ne 0 ]; then gnome-terminal -e "$0"; exit; fi
#dir=$(pwd)
export PATH=$dir/installed_tools/kraken:$PATH
#export PATH=/home/celik/Bracken-2.5:$PATH
#export PATH=/home/celik/Bracken-2.5/src:$PATH
#export PATH=/home/celik/Downloads/ncbi-blast-2.9.0+/bin:$PATH
#export BLASTDB=/home/celik/databases/blast_db
#kraken2=$dir/installed_tools/kraken/kraken2
export PATH=$dir/installed_tools/Clark/exe:$PATH
export PATH=/$dir/installed_tools/Clark:$PATH
### Selection of Database
DataType="$(zenity --list --radiolist --text 'Selection of Database:' --column 'Select...' --column 'Database' FALSE '16SRNA' FALSE 'V3-V4 Hyper Variable Region' FALSE 'Complete Genom')"
zenity --info --width=400 --height=200 --text "Your have chosen $DataType"
zenity --info --title="Welcome" --text="Please Select Your Fastq/Fasta File"

### File Selection
r1=$(zenity --file-selection \
	--file-filter='fasta files | *.fa | *.fasta | *.fna | *.faa | *.fastq' \
	--title="Select Fasta file")
parent16s=$(dirname "$r1")
cd "$parent16s"
for file in "$r1"; do
    if [[ $file == *.fastq ]]; ## conversion of fastq file
    then
        zenity --info --width=400 --height=200 --text "You have chosen a FASTQ file type, It will be converted to FASTA file"
        name="$(basename -s .fastq $r1)"
        mkdir $name"_Results"
        cd $name"_Results"
        dir=$(pwd)
        fastq_to_fasta -i $r1 -o $name"_converted.fasta"
        r1=$name"_converted.fasta"
        zenity --info --width=400 --height=200 --text "Your process will start now, this might take awhile"
    elif [[ $file == *.fa ]];
    then
        name="$(basename -s .fa $r1)"  # creating a results directory
        mkdir $name"_Results"
        cd $name"_Results"
        dir1=$(pwd)
    elif [[ $file == *.fasta ]];
    then
        name="$(basename -s .fasta $r1)"
        mkdir $name"_Results"
        cd $name"_Results"
        dir1=$(pwd)
        zenity --info --width=400 --height=200 --text "Your process will start now, this might take awhile"
    elif [[ $file == *.fna ]];
    then
        name="$(basename -s .fasta $r1)"
        mkdir $name"_Results"
        cd $name"_Results"
        dir1=$(pwd)
        zenity --info --width=400 --height=200 --text "Your process will start now, this might take awhile"
    fi
done;

if [ "$DataType" = "Complete Genom" ]
then
    echo -e "\e[5m\e[31mKraken $DataType database is being loaded. Please wait... \e[25m\e[39m"
    kraken2 --db $KRAKEN2_DEFAULT_DB $r1 --output kraken.out --report krakreport &&
    #bracken -d /home/celik/databases/minikraken2_v2_8GB_201904_UPDATE/ -i krakreport -o Bracken_Results &&
    echo -e "\e[5m\e[31mCentrifuge is in Progress. Loading Database... \e[25m\e[39m"
    centrifuge -x $dir/Databases/Centrifuge_DB/p+h+v -f $r1 --report-file report.centrifuge.txt -S cent.results.txt &&
    centrifuge-kreport -x $dir/Databases/Centrifuge_DB/p+h+v cent.results.txt > cent.to.kreport.txt &&
    echo -e "\e[5m\e[31mClark is in Progress. Loading Database... \e[25m\e[39m"
    classify_metagenome.sh -O $r1 -R clark.results --light &&
    estimate_abundance.sh -F clark.results.csv -D $dir/Databases/Clark_DB/ > abundance.csv --krona
    ktImportTaxonomy -q 2 -t 3 kraken.out -o output.plot.html
elif [ "$DataType" = "16SRNA" ]
then
    echo -e "\e[5m\e[31mKraken $DataType database is being loaded. Please wait... \e[25m\e[39m"
    kraken2 --db /home/celik/databases/kraken16s/ $r1 --output kraken.out --report krakreport &&
    bracken -d /home/celik/databases/kraken16s/ -i krakreport -o Bracken_Results &&
    echo -e "\e[5m\e[31mCentrifuge is in Progress. Loading Database... \e[25m\e[39m"
    centrifuge -x /home/celik/databases/centrifuge16s/16s -f $r1 --report-file report.centrifuge.txt -S cent.results.txt &&
    centrifuge-kreport -x /home/celik/databases/centrifuge16s/16s cent.results.txt > cent.to.kreport.txt &&
    echo -e "\e[5m\e[31mClark is in Progress. Loading Database... \e[25m\e[39m"
    classify_metagenome.sh -O $r1 -R clark.results --light &&
    estimate_abundance.sh -F clark.results.csv -D /home/celik/databases/CLARKDB/ > abundance.csv --krona
    ktImportTaxonomy -q 2 -t 3 kraken.out -o output.plot.html
else
    echo -e "\e[5m\e[31mKraken $DataType database is being loaded. Please wait... \e[25m\e[39m"
    kraken2 --db home/celik/databases/krakenv3 $r1 --output kraken.out --report krakreport &&
    bracken -d /home/celik/databases/kraken16s/ -i krakreport -o Bracken_Results &&
    echo -e "\e[5m\e[31mCentrifuge is in Progress. Loading Database... \e[25m\e[39m"
    centrifuge -x /home/celik/databases/centrifugevregion/centv3 -f $r1 --report-file report.centrifuge.txt -S cent.results.txt &&
    centrifuge-kreport -x /home/celik/databases/centrifugevregion/centv3 cent.results.txt > cent.to.kreport.txt &&
    echo -e "\e[5m\e[31mClark is in Progress. Loading Database... \e[25m\e[39m"
    classify_metagenome.sh -O $r1 -R clark.results --light &&
    estimate_abundance.sh -F clark.results.csv -D /home/celik/databases/CLARKDB/ > abundance.csv --krona
    ktImportTaxonomy -q 2 -t 3 kraken.out -o output.plot.html
fi
if zenity --question --width=400 --height=100 --text="Do you want to blast your file (This will take longer)"; then
    blastn -query $r1 -db 16SMicrobial -max_target_seqs 1 -outfmt "6 qacc sacc slen staxids scomnames" -out updateblast.csv
else
    zenity --info --width=400 --height=100 --text="Your results are ready"
fi

level="$(zenity --list --radiolist --text 'Selection of Taxonomy Level:' --column 'Select...' --column 'Level' FALSE 'Species' FALSE 'Genus' FALSE 'Phylum')"

if [[ $level == 'Species' ]];
then
    level='S'
elif [[ $level == 'Genus' ]];
then
    level='G'
elif [[ $level == 'Phylum' ]];
then
    level='P'
fi

thold=$(zenity --entry --text "Please enter threshold value")

cd $dir
python graph_it.py -l $level -t $thold -i $dir1



if zenity --question --width=400 --height=100 --text="Would you like to view the Results"; then
        firefox report.html
else
    zenity --info --width=400 --height=100 --text="Your results are ready"
fi
