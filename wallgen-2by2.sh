while getopts i:p:q:r:x:n:j: flag
do
    case "${flag}" in
        i) path=${OPTARG};;
        p) v0=${OPTARG};;
        q) v1=${OPTARG};;
        r) v2=${OPTARG};;
        x) v3=${OPTARG};;
        n) name=${OPTARG};;
        j) new=${OPTARG};;
    esac
done

if [ -d "$new" ]; then
  echo "Generating files in $new...";
else
  echo "Creating: $new ";
  eval `mkdir -p "$new"`;
fi

exec ffmpeg \
-i $path/$v0.mp4 \
-i $path/$v1.mp4 \
-i $path/$v2.mp4 \
-i $path/$v3.mp4 \
-filter_complex \
"[0:v][1:v]hstack=inputs=2[r0];\
[2:v][3:v]hstack=inputs=2[r1];\
[r0][r1]vstack=inputs=2" \
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
"$new/$name"

# echo "Done";