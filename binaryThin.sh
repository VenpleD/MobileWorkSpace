
#${PODS_ROOT}
#
NeedThinPath=("./" "hello")

#array=$(find ${NeedThinPath[0]} -type f)
#
#echo "-----"
#find ${NeedThinPath[0]} -type f | xargs file -m -i
echo ${PLATFORM_NAME}
echo

function thinFileWithArch() {
    echo $1+$2
    if [[ -f $1 ]]
    then
        outputFile=$1$2
        lipo -extract $2 $1 -output $outputFile
        if [[ ! -f $1 ]]
        then
            echo "wu back"
        fi
        return 0
    else
        return -1
    fi
}

function handleMachOWithArchs() {
    arg1=$1
    fileName=${arg1##*/}
    filePath=${arg1%/*}
    resultName=${fileName%_*}
    if [[ $2 =~ ' ' ]]
    then
        archs=($2)
        resultSuffix="result"
        tempResultSuffix="temp"
        resultArch=$1$resultSuffix
        tempResultArch=$1$resultTempSuffix
        for arch in ${archs[@]}
        do
            thinFileWithArch $1 $arch
            if [[ $? == 0 ]]
            then
                if [[ -f $resultArch ]]
                then
                    echo "有result+$1$arch"
                    lipo -create $1$arch $resultArch -output $tempResultArch
                    rm -rf $1$arch
                    mv $tempResultArch $resultArch
                else
                    echo "无result+$1$arch"
                    mv $1$arch $resultArch
                fi
            fi
        done
        if [[ -f $resultArch ]]
        then
#            rm -rf $filePath//$resultName
#            mv $resultArch $filePath/$resultName
            backupFileDay=`stat -f %Sm -t %D $arg1`
            backupFileTime=`stat -f %Sm -t %T $arg1`
            
            echo $arg1+$backupFileTime+$backupFileDay
        fi
    else
        thinFileWithArch $1 $2
        if [[ -f $1$2 ]]
        then
            rm -rf $filePath//$resultName
            mv $1$1 $filePath//$resultName
        fi
        echo $2
    fi
}

currentMachoDir=()
find ${NeedThinPath[0]} -type f -print0 | {
    needArch="armv7 arm64"
#if [[ ${PLATFORM_NAME} -eq "iphoneos" ]]
#then
#    needArch="armv7 arm64"
#else
#    needArch="i386"
#fi
while read -d $'\0' file
do
    filetype=$(file $file -b)
    macho="Mach-O universal binary"
    result=$(echo $filetype | grep "${macho}")
    backupSuffix="_backup"
    
    if [[ $filetype =~ $macho ]] && [[ ! $file =~ $backupSuffix ]]
    then
        fileArchs=`lipo -archs $file`
        if [[ $fileArchs == $needArch ]]
        then
            continue
        fi
        fileString=$file
        fileName=${fileString##*/}
        filePath=${fileString%/*}
        filebackup=$filePath$fileName$backupSuffix
        if [[ -f $filebackup ]]
        then
            fileBackupStat=`stat -s $filebackup`
            fileStat=`stat -s $file`
            subFileBackupStat=${fileBackupStat#*st_mtime=}
            fileBackupCtime=${subFileBackupStat% st_ctime*}
            subFileStat=${fileStat#*st_ctime=}
            fileCtime=${subFileStat% st_birthtime*}
            if [[ fileCtime -gt fileBackupCtime ]]
            then
                echo "remove backup"
                rm -rf $filebackup
                cp -v $file $filebackup
            fi
            handleMachOWithArchs $filebackup "$needArch"
        else
            cp -v $file $filebackup
            handleMachOWithArchs $filebackup "$needArch"
        fi
#        backupCTime=`stat -f ${filebackup}`
#        echo $backupCTime

        currentMachoDir+=($file)
#        echo "--$file--$filePath--$fileName"
    fi
done
#for machFile in $currentMachoDir
#do
#
#    echo "--$machFile"
#done
#echo "----${currentMachoDir[*]}"
}
echo ${NeedThinPath[0]}

