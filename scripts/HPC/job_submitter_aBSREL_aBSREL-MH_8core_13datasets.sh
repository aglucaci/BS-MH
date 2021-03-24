#!/bin/bash
#PBS -N aBSREL_aBSREL-MH_13datasets
#PBS -l nodes=1:ppn=8
#PBS -l walltime=999:00:00

#@Usage: qsub -V -q epyc job_submitter_aBSREL_aBSREL-MH_8core_13datasets.sh

BASEDIR="/home/aglucaci/aBSREL-MH"
DATADIR="/home/aglucaci/aBSREL-MH/data/13-datasets"

#Specifiy batch file
aBSREL=/home/aglucaci/hyphy-develop/res/TemplateBatchFiles/SelectionAnalyses/aBSREL.bf

#HyPhy location
#HYPHY = BASEDIR + "/scripts/hyphy-develop/HYPHYMP"
#HYPHYMPI=$BASEDIR"/scripts/hyphy-develop/HYPHYMPI"
HYPHYMPI=/home/aglucaci/hyphy-develop/HYPHYMPI

#HyPhy resource folder
#RES=$BASEDIR"/scripts/hyphy-develop/res"
RES=/home/aglucaci/hyphy-develop/res

#mkdir -p $BASEDIR"/analysis/UNMASKED_SELECTOME"
#mkdir -p $BASEDIR"/analysis/UNMASKED_SELECTOME/aBSREL"
#mkdir -p $BASEDIR"/analysis/UNMASKED_SELECTOME/aBSREL-MH"

mkdir -p "$BASEDIR"/analysis/13-datasets

OUTPUTDIR_aBSREL=$BASEDIR"/analysis/13-datasets/aBSREL"
OUTPUTDIR_aBSREL_MH=$BASEDIR"/analysis/13-datasets/aBSREL-MH"

mkdir -p $OUTPUTDIR_aBSREL
mkdir -p $OUTPUTDIR_aBSREL_MH

echo ""

echo "# #####################################################################"
echo "# Job Settings"
echo "# #####################################################################"
echo "Base Directory: "$BASEDIR
echo "Data Directory: "$DATADIR
echo "HYPHYMPI: "$HYPHYMPI
echo "Resources: "$RES
echo "OUTPUT Directory (aBSREL): "$OUTPUTDIR_aBSREL
echo "OUTPUT Directory (aBSREL-MH): "$OUTPUTDIR_aBSREL_MH
echo ""

FILES=$DATADIR"/*.nex"

# Debug above here
#exit 1

echo "# #####################################################################"
echo "# Computation (Model running)"
echo "# #####################################################################"


for f in $FILES; do
    echo "# Processing: "$f

    b="$(basename -- $f)"

    # aBSREL
    OUTPUT_aBSREL=$OUTPUTDIR_aBSREL"/"$b".aBSREL.json"
    if [ -f $OUTPUT_aBSREL ];
    then
        # Output File exists
        echo 1
    else
        if [ $b == "COXI.nex" ];
        then
            echo mpirun -np 8 $HYPHYMPI LIBPATH=$RES $aBSREL --alignment $f --output $OUTPUT_aBSREL --code Vertebrate-mtDNA
            mpirun -np 8 $HYPHYMPI LIBPATH=$RES $aBSREL --alignment $f --output $OUTPUT_aBSREL --code Vertebrate-mtDNA
        
        else
            echo mpirun -np 8 $HYPHYMPI LIBPATH=$RES $aBSREL --alignment $f --output $OUTPUT_aBSREL
            mpirun -np 8 $HYPHYMPI LIBPATH=$RES $aBSREL --alignment $f --output $OUTPUT_aBSREL
        fi
    fi
    
    # aBSREL-MH
    OUTPUT_aBSREL_MH=$OUTPUTDIR_aBSREL_MH"/"$b".aBSREL-MH.json"    
    if [ -f $OUTPUT_aBSREL_MH ];
    then
        # Output File exists
        echo 2
    else
        if [ $b == "COXI.nex" ];
        then
            echo mpirun -np 8 $HYPHYMPI LIBPATH=$RES $aBSREL --alignment $f --multiple-hits Double+Triple --output $OUTPUT_aBSREL_MH --code Vertebrate-mtDNA
            mpirun -np 8 $HYPHYMPI LIBPATH=$RES $aBSREL --alignment $f --multiple-hits Double+Triple --output $OUTPUT_aBSREL_MH --code Vertebrate-mtDNA
        else
            echo mpirun -np 8 $HYPHYMPI LIBPATH=$RES $aBSREL --alignment $f --multiple-hits Double+Triple --output $OUTPUT_aBSREL_MH
            mpirun -np 8 $HYPHYMPI LIBPATH=$RES $aBSREL --alignment $f --multiple-hits Double+Triple --output $OUTPUT_aBSREL_MH
        fi
    fi

    echo ""
done



echo "# #####################################################################"
echo "# Job submitter, complete!"
echo "# #####################################################################"




# END OF FILE
# #####################################################################
