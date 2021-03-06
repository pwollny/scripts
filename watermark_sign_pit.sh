#!/bin/sh
# vim: set sw=4 ts=4 et:
# wirtten by katja socher <katja@linuxfocus.org>
# and guido socher <guido@linuxfocus.org>
#
#
ver="0.1"
twidth=80
theight=80
help()
{
    cat <<HELP
stampimages -- insert a small logo in the lower right corner
of all images

USAGE: stampimages [-h] -l logoimage image1 image2 ...

All output files get the filename stamp_imagename
OPTIONS: -h this help

EXAMPLE: imgsrcline -l lfstamp.gif test.jpg

This will generate the file stamp_test.jpg

version $ver
HELP
    exit 0
}
error()
{
    echo "$1"
    exit "$2"
}

while [ -n "$1" ]; do
case $1 in
    -h) help;shift 1;;
    -l) stamp="$2";shift 1;shift 1;;
    --) break;;
    -*) echo "error: no such option $1. -h for help";exit 1;;
    *)  break;;
esac
done

if [ -z "$stamp" ];then
    error "No image specified after -l parameter, -h for help" 1
fi
if [ -z "$1" ];then
    error "No image specified, -h for help" 1
fi
# process each image
for imgfile in $* ;do
    if [ ! -r "$imgfile" ]; then
        echo "ERROR: can not read $imgfile\n"
    else
        bn=`basename "$imgfile"`
        dn=`dirname "$imgfile"`
        if echo "$bn" | grep "^psign_" > /dev/null ; then
            echo "File $imgfile has already psign_ in its name, ignored..."
            continue
        fi
        outfilename="$dn/psign_$bn"
        echo "writing $outfilename ..."
#        combine -gravity SouthEast -compose Over "$imgfile" "$stamp" "$outfilename"
        composite -gravity SouthEast "$stamp" "$imgfile" "$outfilename"
#        montage -gravity SouthEast -compose Over "$imgfile" "$stamp" "$outfilename"
    fi
done

