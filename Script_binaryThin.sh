echo $(date "+%Y-%m-%d %H:%M:%S")
#默认需要瘦身的framework
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
PROJECT_ROOT=${SHELL_FOLDER%/*}
PODSPATH=${SHELL_FOLDER%/*}/Pods
NeedThinPath=("${PODSPATH}/BaijiaYun" "${PODSPATH}/XMIJKMediaPlayer" "${PODSPATH}/YZAppSDK")
PLATFORM_NAME="iphoneos"
echoPrefix="binaryThin's log:"

#瘦身架构文件，$1是文件，$2是架构
function thinFileWithArch() {
    if [[ -f $1 ]]
    then
        outputFile=$1$2
        lipo -extract $2 $1 -output $outputFile
        return 0
    else
        return -1
    fi
}

#处理macho文件架构，设计到架构合并，$1是文件路径，$2是架构：例如 "armv7 arm64"
function handleMachOWithArchs() {
    arg1=$1
    fileName=${arg1##*/}
    filePath=${arg1%/*}
    resultName=${fileName%.*}
    if [[ $2 =~ ' ' ]]
    then
        archs=($2)
        resultSuffix="result"
        tempResultSuffix="temp"
        resultArch=$1$resultSuffix
        tempResultArch=$1$tempResultSuffix
        for arch in ${archs[@]}
        do
            thinFileWithArch $1 $arch
            #对二进制文件执行thin是否成功
            if [[ $? == 0 ]]
            then
                #如果没有result文件，就直接把第一次生成架构文件作为第二次的result文件
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
            rm -rf $arg1
        fi
    else
        thinFileWithArch $1 $2
        if [[ -f $1$2 ]]
        then
            rm -rf $filePath/$resultName
            mv $1$2 $filePath/$resultName
            rm -rf $arg1
        fi
        echo $2
    fi
}

#处理frameworks文件夹
function handleFrameworks() {
    if [[ $# == 0 ]]
    then
        return
    fi
    frameworkDir=$1
    find $frameworkDir -type f -print0 | {
        # 根据当前是iPhone还是simulator，来确定要瘦身的架构
        if [[ ${PLATFORM_NAME} == "iphoneos" ]]
        then
            needArch="armv7 arm64"
        else
            needArch="i386"
        fi
        while read -r -d $'\0' file
        do
            filetype=$(file $file -b)
            macho="Mach-O universal binary"
            result=$(echo $filetype | grep "${macho}")
            backupSuffix=".backup"
            #这里判断是macho文件，但是不是backup文件
            if [[ $filetype =~ $macho ]] && [[ ! $file =~ $backupSuffix ]]
            then
                echo "thinFile:$file"
                thinFileCount+=1
                fileArchs=`lipo -archs $file`
                #看文件是否等于所需要的架构
                if [[ $fileArchs == $needArch ]]
                then
                    continue
                fi
                fileString=$file
                fileName=${fileString##*/}
                filePath=${fileString%/*}
                filebackup=$filePath/$fileName$backupSuffix
                #是否有backup文件
                if [[ -f $filebackup ]]
                then
                    rm -rf $filebackup
                fi
                cp -v $file $filebackup
                #处理需要瘦身的macho文件
                handleMachOWithArchs $filebackup "$needArch"
            fi
        done
    }
}

function beginThin() {
    frameWorkBackup="backupDir"
    frameWorkTemp="Temp"
    if [[ $# == 0 ]]
    then
        return
    fi
    for dirPath in "$@"
    do
        if [[ ! -d $dirPath ]]
        then
            echo "$echoPrefix $dirPath not a Directory"
            continue
        fi
        echo "$echoPrefix $dirPath is thinning"
        if [[ ! -d $dirPath/$frameWorkBackup ]]
        then
            subDirs=(`ls $dirPath/`)
            if [[ ${#subDirs[*]} != 0 ]]
            then
                #framework目录下创建backup和temp文件夹，backup是所有架构的文件，供每次切换模拟器和真机使用，temp做瘦身，完成后会删除
                mkdir $dirPath/$frameWorkBackup
                mkdir $dirPath/$frameWorkTemp
            fi
            for subDir in ${subDirs[*]}
            do
                #将framework文件夹下面的所有文件拷贝到backup和temp
                cp -a $dirPath/$subDir $dirPath/$frameWorkBackup
                cp -a $dirPath/$frameWorkBackup/ $dirPath/$frameWorkTemp
            done
        else
            mkdir $dirPath/$frameWorkTemp
            cp -a $dirPath/$frameWorkBackup/ $dirPath/$frameWorkTemp
        fi
        handleFrameworks $dirPath/$frameWorkTemp
        cp -rf $dirPath/$frameWorkTemp/ $dirPath
        rm -rf $dirPath/$frameWorkTemp
        echo "$echoPrefix $dirPath is success"
    done
}

if [[ $# != 0 ]]
then
    NeedThinPath=()
    for arg in "$@"
    do
        if [[ ! $arg =~ "${PODS_ROOT}" ]]
        then
            arg="${PODS_ROOT}/$arg"
        fi
        NeedThinPath+=("$arg")
    done
fi

echo "hello+${NeedThinPath[*]}"

beginThin ${NeedThinPath[*]}

echo $(date "+%Y-%m-%d %H:%M:%S")


