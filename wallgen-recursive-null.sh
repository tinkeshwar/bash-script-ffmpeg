while getopts i:c:m:n: flag
do
    case "${flag}" in
        i) location=${OPTARG};;
        c) number=${OPTARG};;
        m) min=${OPTARG};;
        n) max=${OPTARG};;
    esac
done

function is_power_of_two () {
    declare -i n=$1
    (( n > 0 && (n & (n - 1)) == 0 ))
}

shift "$((OPTIND - 1))"


echo "Measurement no., Width, Height,Samples, Avg Execution time(ms.), " >> $@

while [ $min -le $max ]
do
    num=$(( $min*$min ))
    #echo $num
    if is_power_of_two "$num"; 
    then
        echo $min
        avgTime=0;
        avgTimeSum=0;
        looptime=0
        counter=1
        while [ $looptime -lt $number ]
        do
            start=`date +%s%3N`
            eval bash wallgen-quadtree.sh -i $location -w $min -h $min -- v$min.mp4
            end=`date +%s%3N`
            runtime=$( echo "($end - $start)" | bc -l )
            looptime=`expr $looptime + 1`
            avgTimeSum=$(( avgTime + runtime ))
        done
        avgTime=$(( avgTimeSum/number ))
        echo "$counter,$min,$min,$number,$avgTime" >> $@
        min=`expr $min + 1`
        counter=`expr $counter + 1`
    else
        min=`expr $min + 1`
    fi
done

