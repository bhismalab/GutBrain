#Carolyn McNabb 
#November 2021
#GBGABA STUDY ANALYSIS 
#3.4.2_fix_stage2.sh will run the second stage of FSL's FIX for those subjects with resting-state fMRI data. Make sure you define the threshold before running!
#!/bin/bash


bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed


#DEFINE THRESHOLD FOR FIX
thres=20 #change this to an appropriate threshold based on the output from the FIX classifier


#Make sure threshold has been defined before continuing

read -p "HAVE YOU DEFINED THE THRESHOLD FOR FIX? (Y/N): " userinput
       
if [ ${userinput} == "Y" ] || [ ${userinput} == "y" ]; then

    cd $bids_path
    subjects=( $(ls -d sub-* )) 

    for sub in ${!subjects[@]}; do 
        i=${subjects[$sub]}
        s=${i//$"sub-"/}
    
        cd ${derivative_path}/${i}
        sessions=( $(ls -d ses-*))
    
        for visit in ${!sessions[@]}; do
            ses=${sessions[$visit]}

            if [ -d ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat ]; then
        
                echo "Running FIX stage 2 for ${i} ${ses}"
            
                fix -c ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/ ${derivative_path}/FIX.RData ${thres}
            
            else
                echo "Resting state fMRI data do not exist for ${i} ${ses}"
            fi
        done
    done

else
    echo "Go back and define the threshold in the script 3.4.2_fix_stage2.sh"

fi
