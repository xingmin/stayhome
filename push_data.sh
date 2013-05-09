#!/bin/bash
function pull(){
    sr=$1
    dr=$2
    if ! [ -e "$dr/.git" ]; then
        git clone $sr .
    else
        git pull origin master
    fi
}
function push(){
    lr=$1
    #lrgd="$lr/.git"
    for i in {1..10} 
    do  
        echo "Trying push my data to remote repo: $i time(s)"
		#git --git-dir="$lrgd" add "$lr"
		git add .
		git commit -a -m "test"
	        git pull origin master
	        git push origin master
		if [ $? -ne 0 ]; then
		    sleep 5
		    continue
		fi
		break
    done
}
function usage(){
    echo "usage:$1 -m pull/push -s \"remote repo\" -d \"local repo path\""
}
mode="pull"
drepo=""
srepo=""

while getopts "m:s:d:h" opt;do
    case $opt in
        m) 
	    mode=$OPTARG
	    case $mode in
	        "push") mode="push"
		;;
	        "pull") mode="pull"
		;;
	    esac
	;;
	s) 
	    srepo="$OPTARG"
	;;
	d)
	    drepo="$OPTARG"
	;;
	h|\?)
	    usage $0
	    exit 0
	;;
    esac
        
done

if [ -z $drepo ]||[ -z $srepo ]; then
    usage $0
    exit 1
fi

if ! [ -d "$drepo" ]; then
    mkdir -p "$drepo"
fi

pushd . > /dev/null 2>&1
cd "$drepo" > /dev/null 2>&1


case $mode in
    "pull")
        pull $srepo $drepo > /dev/null 2>&1
        ;;
    "push")
        push $drepo > /dev/null 2>&1
esac

popd > /dev/null 2>&1
    





