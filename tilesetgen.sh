while getopts n: flag
do
    case "${flag}" in
        n) number=${OPTARG};;
    esac
done

shift "$((OPTIND - 1))"

if [ -d "$@" ]; then
  echo "Generating files in $@...";
else
  echo "Creating: $@ ";
  eval `mkdir -p "$@"`;
fi

a=0;
while [ $a -lt $number ]
do 
    name="$a.mp4";
    eval sh ./tilegen.sh -n $a -- $@/$name
    a=`expr $a + 1`
done