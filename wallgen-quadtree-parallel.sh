while getopts i:w:h: flag
do
    case "${flag}" in
        i) path=${OPTARG};;
        w) width=${OPTARG};;
        h) height=${OPTARG};;
    esac
done

shift "$((OPTIND - 1))"

if [ $width -ne $height ]
then
    echo "Error! height and width not equal"
    exit
fi

function is_power_of_two () {
    declare -i n=$1 
    (( n > 0 && (n & (n - 1)) == 0 ))
}

pnum=$(( $width*$height ))

if is_power_of_two "$pnum"; 
then
    num=`expr $width \* $height`
    half=$(( width/2 ))
    n=$width

    exponent=0
    number=2
    i=1
    while [ $i -lt $width ]
    do
        i=$(( $i * $number ))
        exponent=`expr $exponent + 1`
    done

    iteration=1
    while [ $iteration -lt $exponent ]
    do
        start=0
        counter=1
        video=0
        while [ $start -lt $num ]
        do
            v0=$start
            v1=`expr $start + 1`
            v2=`expr $start + $n`
            v3=`expr $start + $n + 1`

            if [ $counter = $half ]
            then
                start=`expr $start + $n + 2`
                counter=1
            else
                start=`expr $start + 2`
                counter=`expr $counter + 1`
            fi

            eval bash "wallgen-2by2.sh -i $path -p $v0 -q $v1 -r $v2 -x $v3 -n $video.mp4 -j temp/$iteration"

            video=`expr $video + 1`
        done
	    wait
        path="temp/$iteration"
        n=$(( $n/2 ))
        num=$(( $n*$n ))
        half=$(( $n/2 ))
        last=$(( $exponent-$iteration ))
        if [ $last = 1 ]
        then
            eval sh wallgen-onepass.sh -i $path -w 2 -h 2 -- $@
        fi

        iteration=`expr $iteration + 1`
    done
else
    echo "Error! number is not in power two"
    exit
fi


