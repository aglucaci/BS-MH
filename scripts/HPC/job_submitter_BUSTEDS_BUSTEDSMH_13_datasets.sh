#!/bin/bash
#PBS -N 13-datasets_BUSTEDS_and_SMH
#PBS -l nodes=1:ppn=8

#@Usage: qsub -V -q epyc job_submitter_BUSTEDS_BUSTEDSMH_13_datasets.sh


BASEDIR="/home/aglucaci/BUSTEDS-MH"
DATADIR="/home/aglucaci/BUSTEDS-MH/data/13-datasets"

#Specifiy batch file
BUSTEDSMH=/home/aglucaci/hyphy-analyses/BUSTED-MH/BUSTED-MH.bf
BUSTEDS=/home/aglucaci/hyphy-develop/res/TemplateBatchFiles/SelectionAnalyses/BUSTED.bf

#HyPhy location
#HYPHY = BASEDIR + "/scripts/hyphy-develop/HYPHYMP"
#HYPHYMPI=$BASEDIR"/scripts/hyphy-develop/HYPHYMPI"
HYPHYMPI=/home/aglucaci/hyphy-develop/HYPHYMPI


#HyPhy resource folder
#RES=$BASEDIR"/scripts/hyphy-develop/res"
RES=/home/aglucaci/hyphy-develop/res

mkdir -p "$BASEDIR"/analysis/13-datasets

OUTPUTDIR_BUSTEDS=$BASEDIR"/analysis/13-datasets/BUSTEDS"
OUTPUTDIR_BUSTEDS_MH=$BASEDIR"/analysis/13-datasets/BUSTEDS-MH"

mkdir -p $OUTPUTDIR_BUSTEDS
mkdir -p $OUTPUTDIR_BUSTEDS_MH

echo ""

echo "# #####################################################################"
echo "Settings"
echo "# #####################################################################"
echo "Base Directory: "$BASEDIR
echo "Data Directory: "$DATADIR
echo "HYPHYMPI: "$HYPHYMPI
echo "Resources: "$RES
echo ""  
        
FILES="$DATADIR"/*.nex
             
for f in $FILES; do
    echo "Processing: "$f
    b="$(basename -- $f)" 
    
    # BUSTED-S
    OUTPUT_BUSTEDS=$OUTPUTDIR_BUSTEDS"/"$b".BUSTEDS.json"
    if [ -f $OUTPUT_BUSTEDS ];
    then
        echo 1
    else
        if [ $b == "COXI.nex" ]; 
        then
            echo mpirun -np 8 $HYPHYMPI LIBPATH=$RES $BUSTEDS --alignment $f --output $OUTPUT_BUSTEDS --starting-points 10 --code Vertebrate-mtDNA
            mpirun -np 8 $HYPHYMPI LIBPATH=$RES $BUSTEDS --alignment $f --output $OUTPUT_BUSTEDS --starting-points 10 --code Vertebrate-mtDNA
        else
            echo mpirun -np 8 $HYPHYMPI LIBPATH=$RES $BUSTEDS --alignment $f --output $OUTPUT_BUSTEDS --starting-points 10
            mpirun -np 8 $HYPHYMPI LIBPATH=$RES $BUSTEDS --alignment $f --output $OUTPUT_BUSTEDS --starting-points 10
        fi
     fi


    # BUSTEDS-MH
    OUTPUT_BUSTEDS_MH=$OUTPUTDIR_BUSTEDS_MH"/"$b".BUSTEDS-MH.json"
    if [ -f $OUTPUT_BUSTEDS_MH ];
    then
        echo 2
    else
        if [ $b == "COXI.nex" ];
        then
            echo mpirun -np 8 $HYPHYMPI LIBPATH=$RES $BUSTEDSMH --alignment $f --code Vertebrate-mtDNA --starting-points 10 --output $OUTPUT_BUSTEDS_MH
            mpirun -np 8 $HYPHYMPI LIBPATH=$RES $BUSTEDSMH --alignment $f --code Vertebrate-mtDNA --starting-points 10 --output $OUTPUT_BUSTEDS_MH
        else
            echo mpirun -np 8 $HYPHYMPI LIBPATH=$RES $BUSTEDSMH --alignment $f --starting-points 10 --output $OUTPUT_BUSTEDS_MH
            mpirun -np 8 $HYPHYMPI LIBPATH=$RES $BUSTEDSMH --alignment $f --starting-points 10 --output $OUTPUT_BUSTEDS_MH
        fi
    fi

    echo ""
done








# END OF FILE
# #####################################################################
                                                                            
