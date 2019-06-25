# lolcat.nim
lolcat implemented with nim
It's a simple program I made to learn the Nim language

- Fast and with no dependencies (compiles to C)
- Handles lines with terminal width and EOL
- Always uses truecolor
- Animates text print

![](/lolcat.png)

## Comparison

Here is a comparison of lolcat versions running `time dmesg | lolcat`

| lolcat edition | real time | user time | sys time | correct line ending | implemented in |
| -------------- |:---------:|:---------:|:--------:|:-------------------:| --------------:|
| lolcat.nim     | 0,289s    | 0,152s    | 0,102s   | yes                 | Nim            |
| [clolcat](https://github.com/IchMageBaume/clolcat)| 0,055s    | 0,019s    | 0,043s   | no                  | C |

Even with my little experience and probably not the best implementation, Nim shows an impressive speed in comparison with pure C.

The original Ruby version wasn't tested, but in other comparisons it's 10x slower than the C version, while my Nim version is just 5x.

Of course, that's all in my computer, the times may vary.
