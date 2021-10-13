while getopts n: flag
do
    case "${flag}" in
        n) number=${OPTARG};;
    esac
done

shift "$((OPTIND - 1))"

#256*256# exec ffmpeg -f lavfi -i color=size=256x256:duration=6:rate=25:color="#$(openssl rand -hex 3)" -vf "drawtext=fontsize=150:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='$number'" "$@"
exec ffmpeg -f lavfi -i color=size=32x32:duration=6:rate=25:color="#$(openssl rand -hex 3)" -vf "drawtext=fontsize=15:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='$number'" "$@"
echo "Done";