#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<EOF
Usage: $0 [-o OUTDIR] [input.mp4 ...]

Convert 10-bit MP4 (HEVC/H.264) files to DNxHR HQX in a .mov container
for DaVinci Resolve. Quality-preserving (visually lossless).

With no input files, all video files in the current directory are processed.

Options:
  -o OUTDIR   Output directory (default: /home/jseto/Videos/editing.local)
  -h          Show this help

DNxHR HQX is 10-bit 4:2:2, lossless audio (PCM), ideal for Resolve.
EOF
}

outdir="/home/jseto/Videos/editing.local"
while getopts "ho:" opt; do
    case "$opt" in
        h) usage; exit 0 ;;
        o) outdir="$OPTARG" ;;
        *) usage; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

if [ $# -ge 1 ]; then
    inputs=("$@")
else
    shopt -s nullglob
    inputs=(*.mp4 *.mov *.mkv *.m4v *.avi)
    shopt -u nullglob
    [ ${#inputs[@]} -ge 1 ] || { echo "No video files found in current directory." >&2; exit 1; }
fi

if [ -n "$outdir" ]; then
    mkdir -p "$outdir"
fi

fail=0
for input in "${inputs[@]}"; do
    [ -f "$input" ] || { echo "SKIP: not a file: $input" >&2; fail=1; continue; }

    base="$(basename "${input%.*}")"
    output="$outdir/${base}.mov"

    echo "== Converting: $input -> $output"

    if ! ffmpeg -hide_banner -loglevel warning -y \
        -i "$input" \
        -map 0:v:0 -map 0:a? \
        -c:v dnxhd -profile:v dnxhr_hqx -pix_fmt yuv422p10le \
        -c:a pcm_s24le \
        -f mov \
        "$output"; then
        echo "FAIL: $input" >&2
        fail=1
    fi
done

if [ "$fail" -eq 1 ]; then
    echo "One or more conversions failed." >&2
    exit 1
fi
echo "Done."