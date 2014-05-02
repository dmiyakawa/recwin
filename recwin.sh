#!/bin/bash
#
# X11 screen capture with ffmpeg.
#
# Original:
# https://www.youtube.com/watch?v=_XDa1ahl7fw
# https://gist.github.com/anonymous/3927068
#
# Note:
#  * Has very slight modifications to what is introduced above.
#  * Sound handling seems imperfect.
#
# Ref:
# Option '-sameq' does NOT mean 'same quality'
# http://trac.ffmpeg.org/wiki/Option%20'-sameq'%20does%20NOT%20mean%20'same%20quality'
#
# FFmpeg Howto (copy)
# https://gist.github.com/dmiyakawa/9c217cf53fde91beda3f

if [ $# -eq 0 ]; then
  echo 'Need an argument for a video file.' 1>&2
  exit 1
fi

echo 'Click a window which you want to record.'
INFO=$(xwininfo -frame)

WIN_GEO=$(echo $INFO | grep -oEe 'geometry [0-9]+x[0-9]+' |\
    grep -oEe '[0-9]+x[0-9]+')
WIN_XY=$(echo $INFO | grep -oEe 'Corners:\s+\+[0-9]+\+[0-9]+' |\
    grep -oEe '[0-9]+\+[0-9]+' | sed -e 's/+/,/' )

ffmpeg -y \
  -f x11grab -r 24 -s $WIN_GEO -i $DISPLAY+$WIN_XY \
  -vcodec ffv1 \
  -f alsa -ac 2 \
  -i pulse -acodec ac3 \
  -threads auto $1
