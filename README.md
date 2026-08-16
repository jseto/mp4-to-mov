# mp4-to-mov

Convert 10-bit MP4 (HEVC/H.264) video files to DNxHR HQX in a `.mov` container for DaVinci Resolve.

DNxHR HQX is a 10-bit 4:2:2 codec, making this conversion visually lossless and ideal as an intermediate for editing in Resolve. Audio is converted to lossless PCM (24-bit).

## Requirements

- `ffmpeg` (with `libx265` only needed for creating test files)

## Usage

```sh
./mp4-to-dnxhr.sh [-o OUTDIR] [input.mp4 ...]
```

With no input files, all video files (`*.mp4`, `*.mov`, `*.mkv`, `*.m4v`, `*.avi`) in the current directory are processed.

### Options

| Option       | Description                                               |
|--------------|-----------------------------------------------------------|
| `-o OUTDIR`  | Output directory (default: `/home/jseto/Videos/editing.local`) |
| `-h`         | Show help                                                 |

## Examples

```sh
# Convert a single file
./mp4-to-dnxhr.sh myvideo.mp4

# Convert multiple files to a custom output directory
./mp4-to-dnxhr.sh -o /path/to/edits a.mp4 b.mp4

# Convert all video files in the current directory
./mp4-to-dnxhr.sh
```

Output files keep the input basename with a `.mov` extension (e.g. `myvideo.mp4` -> `myvideo.mov`).

## Notes

- Frames are re-encoded from the original (DNxHR HQX is high bitrate, so quality is preserved in practice).
- Requires `-o OUTDIR` to precede input files when both are used.