while getopts i:c:w:u:h:j: flag
do
    case "${flag}" in
        i) location=${OPTARG};;
        c) number=${OPTARG};;
        w) widthmin=${OPTARG};;
        u) widthmax=${OPTARG};;
        h) heightmin=${OPTARG};;
        j) heightmax=${OPTARG};;
    esac
done

shift "$((OPTIND - 1))"

name="$@"

echo "Measurement no., Width, Height,Samples, n*m, Avg Execution time(ms.), " >> $@
echo "Measurement no., Width, Height,Samples, n, Avg Execution time(ms.), " >> "square_$@"

counter=1
while [ $widthmin -le $widthmax ]
do
    parseheight=$heightmin
    while [ $parseheight -le $heightmax ]
    do
        avgTime=0
        avgTimeSum=0;
        looptime=0
        while [ $looptime -lt $number ]
        do
            start=`date +%s%3N`
            echo "$start"
            eval sh wallgen-onepass.sh -i $location -w $widthmin -h $parseheight -- -f null /dev/null;
            end=`date +%s%3N`
            runtime=$( echo "($end - $start)" | bc -l )
            looptime=`expr $looptime + 1`
            avgTimeSum=$(( avgTime + runtime ))
        done
        avgTime=$(( avgTimeSum/number ))
        sample=$(( widthmin*parseheight))
        echo "$counter,$widthmin,$parseheight,$number,$sample,$avgTime" >> $@

        if [ $widthmin = $parseheight ] 
        then 
            echo "$counter,$widthmin,$parseheight,$number,$sample,$avgTime" >> "square_$@"
        fi
        
        parseheight=`expr $parseheight + 1`
        counter=`expr $counter + 1`
    done
    widthmin=`expr $widthmin + 1`
done