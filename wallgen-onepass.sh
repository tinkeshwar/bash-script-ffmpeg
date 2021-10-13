while getopts i:w:h: flag
do
    case "${flag}" in
        i) path=${OPTARG};;
        w) width=${OPTARG};;
        h) height=${OPTARG};;
    esac
done

shift "$((OPTIND - 1))"
name="$@"
tiles=""

for video in `ls $path/* | sort -V`
do
    tiles="${tiles} -i ${video} ";
done

echo "$tiles"

hstacks=""
vstacks=""
hi=0
wid=0
while [ $hi -lt $height ]
do
    wi=0
    while [ $wi -lt $width ]
    do
        hstacks="${hstacks}[$wid:v]"
        wi=`expr $wi + 1`
        wid=`expr $wid + 1`
    done
    hstacks="${hstacks}hstack=inputs=$width[r$hi];"
    vstacks="${vstacks}[r$hi]"
    hi=`expr $hi + 1`
done
vstacks="${vstacks}vstack=inputs=$height"

exec ffmpeg \
$tiles \
-filter_complex \
"$hstacks $vstacks" \
-c:v libx264 \
-profile:v high \
-pix_fmt yuv420p \
-bsf h264_mp4toannexb \
-x264-params "nal-hrd=cbr" \
-minrate 2300k \
-maxrate 2372k \
-bufsize 2400k \
-b:v 2300k \
-an \
-y \
"$@"

echo "Done";