while getopts p: flag
do
    case "${flag}" in
        p) project=${OPTARG};;
    esac
done

shift "$((OPTIND - 1))"

echo 'Connecting please wait..!'

sleep 3 && echo 'Loading now..'

case $project in
    your-project)
        exec ssh -i "file path" user@host
        ;;
    *)
        echo 'Opps!! you guessed it wrong :)'
        ;;
esac

#
