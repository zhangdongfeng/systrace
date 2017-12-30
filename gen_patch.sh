#!/bin/bash

declare g_path
declare g_revision1
declare g_revision2

# check parameter
if [ $# -lt 4 ]; then
    echo "Usage:"
    echo "    gen_patch.sh xml-file1 xml-file2 repo_dir patch_dir"
    exit
fi

ROOT=$PWD

# ------------------------------------------------------------------------
# function: parse manifest xml
# param[2]: xml-file1, xml-file2
# output[3]: g_path,g_revision1,g_revision2
# ------------------------------------------------------------------------
function parse_manifest_xml()
{
    echo "parse start..."
    tmp=`sed -n 's/.*<project.*="\(.*\)".*revision="\(.*\)".*/\1 \2/p' $1`
    array=($(echo $tmp))
    
    tmp=`sed -n 's/.*<project.*="\(.*\)".*revision="\(.*\)".*/\1 \2/p' $2`
    array2=($(echo $tmp))
    
    echo "parse xml done."
    for ((i=0,j=0,m=0;i<${#array[*]};j++))
    do
        # save path & revision in xml1
        g_path[j]=${array[i++]}
        g_revision1[j]=${array[i++]}
        g_revision2[j]=${g_revision1[j]}
        
        # search last part
        for ((k=$m;k<${#array2[*]};k++))
        do
            if [ x"${g_path[j]}" = x"${array2[k++]}" ]; then
                g_revision2[j]=${array2[k]}
                m=$((k+1))
                break 1
            fi
        done
        
        # if not found, search first part
        if [ x"$k" = x"${#array2[*]}" ]; then
            for ((k=0;k<$m;k++))
            do
                if [ x"${g_path[j]}" = x"${array2[k++]}" ]; then
                    g_revision2[j]=${array2[k]}
                    m=$((k+1))
                    break 1
                fi
            done
        fi
        
        # fix index
        if [ x"$m" = x"${#array2[*]}" ]; then
            m=0
        fi
    done
    
    echo "parse revision done."
}

# ------------------------------------------------------------------------
# function: format patch for changed path
# param[2]: repo_dir, patch_dir
# ------------------------------------------------------------------------
function format_diff_patch()
{
    local repo_dir=$1
    local patch_dir=$2
    local format="\"%an\",\"%ai\",\"%H\",\"%s\""
    
    mkdir -p $patch_dir
    echo "Path,Author,Date,Commit,Subject" > $patch_dir/commits.csv
    
    for((k=0; k<${#g_path[*]}; k++)) 
    do
        if [ x"${g_revision1[k]}" != x"${g_revision2[k]}" ]; then
            mkdir -p $patch_dir/${g_path[k]}
            cd $repo_dir/${g_path[k]}
            git log --no-merges --pretty=${g_path[k]},$format ${g_revision1[k]}..${g_revision2[k]} >> $patch_dir/commits.csv
            git format-patch -o $patch_dir/${g_path[k]} ${g_revision1[k]}..${g_revision2[k]}            
        fi
    done
}

parse_manifest_xml $1 $2
format_diff_patch $ROOT/$3 $ROOT/$4/patches

cd $ROOT

