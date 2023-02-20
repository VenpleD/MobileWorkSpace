
NeedThinPath=("${PODS_ROOT}/BaijiaYun/frameworks/BJHLMediaPlayer.framework/")

function thinFileWithArch() {
    echo $1+$2
    if [[ -f $1 ]]
    then
        outputFile=$1$2
        lipo -extract $2 $1 -output $outputFile
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
        tempResultArch=$1$tempResultSuffix
        for arch in ${archs[@]}
        do
            echo "+$arch+$1"
            thinFileWithArch $1 $arch
            if [[ $? == 0 ]]
            then
                if [[ -f $resultArch ]]
                then
                    lipo -create $1$arch $resultArch -output $tempResultArch
                    rm -rf $1$arch
                    rm -rf $resultArch
                    mv $tempResultArch $resultArch
                else
                    mv $1$arch $resultArch
                fi
            fi
        done

        if [[ -f $resultArch ]]
        then
            rm -rf $filePath/$resultName
            mv $resultArch $filePath/$resultName
            backupFileDay=`stat -f %Sm -t %D $arg1`
            backupFileTime=`stat -f %Sm -t %T $arg1`
            setfile -m "$backupFileDay $backupFileTime" $filePath/$resultName
            echo $arg1+$backupFileTime+$backupFileDay
        fi
    else
        thinFileWithArch $1 $2
        if [[ -f $1$2 ]]
        then
            rm -rf $filePath/$resultName
            mv $1$2 $filePath/$resultName
        fi
        echo $2
    fi
}
for dirPath in ${NeedThinPath[@]}
do
echo "thinDirPath:$dirPath"
find $dirPath -type f -print0 | {
# 根据当前是iPhone还是simulator，来确定要瘦身的架构
if [[ ${PLATFORM_NAME} == "iphoneos" ]]
then
    needArch="armv7 arm64"
else
    needArch="i386"
fi
echo "thinArchs:$needArch--${PLATFORM_NAME}"
while read -d $'\0' file
do
    filetype=$(file $file -b)
    macho="Mach-O universal binary"
    result=$(echo $filetype | grep "${macho}")
    backupSuffix="_backup"
    #这里判断是macho文件，但是不是backup文件
    if [[ $filetype =~ $macho ]] && [[ ! $file =~ $backupSuffix ]]
    then
        fileArchs=`lipo -archs $file`
        #看文件是否等于所需要的架构
        if [[ $fileArchs == $needArch ]]
        then
            continue
        fi
        fileString=$file
        fileName=${fileString##*/}
        filePath=${fileString%/*}
        filebackup=$filePath$fileName$backupSuffix
        #是否有backup文件
        if [[ -f $filebackup ]]
        then
            fileBackupStat=`stat -s $filebackup`
            fileStat=`stat -s $file`
            subFileBackupStat=${fileBackupStat#*st_mtime=}
            fileBackupCtime=${subFileBackupStat% st_ctime*}
            subFileStat=${fileStat#*st_ctime=}
            fileCtime=${subFileStat% st_birthtime*}
            #根据文件的mtime来更新backup文件
            if [[ fileCtime -gt fileBackupCtime ]]
            then
                echo "remove backup"
                rm -rf $filebackup
                cp -v $file $filebackup
            fi
            #处理需要瘦身的macho文件
            handleMachOWithArchs $filebackup "$needArch"
        else
            cp -v $file $filebackup
            #处理需要瘦身的macho文件
            handleMachOWithArchs $filebackup "$needArch"
        fi
    fi
done
}
done


