import terminal, colors, math, parseopt, strutils, random, unicode, os

var 
  color: Color
  width = terminalWidth() - 1
  text = ""
  freq = 0.1
  seed = 0
  offset = 3
  speed = 0
  read = 0

const test = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus aliquam metus eget imperdiet venenatis.
Ut at dignissim neque, ac iaculis tellus. Proin facilisis ex sed turpis feugiat lacinia. Nullam quis elit lacus. Etiam pulvinar malesuada turpis, eu faucibus purus tincidunt ornare. Morbi ac pellentesque velit, a scelerisque mauris.
"""

proc showVersion() =
  text &= """
  lolcat.nim 0.1.0 - (c) 2019 ohermesjunior
  report bugs / contribute - https://www.github.com/ohermesjunior/lolcat.nim/
  original idea - http://www.github.com/busyloop/lolcat/
"""

proc showHelp() =
  text = """
  Usage: lolcat [flag:val] [FILE]
  
  With no FILE, reads standard input

      -a:, --animate:<i>     Animation speed in milliseconds (default = 0)
         -f:, --freq:<f>     Horizontal rainbow frequency (default = 0.1)
   -s:, --seed:<1 ~ 256>     Seed for the rainbow (default = random)
       -o:, --offset:<i>     Amount of offset in each line (default = 3)
              -h, --help     Show this message
           -v, --version     Show the version

"""
  showVersion()

proc rainbow(freq, i: float): Color =
  let r = sin(freq * i) * 127 + 128
  let g = sin(freq * i + 2 * PI / 3) * 127 + 128
  let b = sin(freq * i + 4 * PI / 3) * 127 + 128
  result = rgb(r.int, g.int, b.int)

proc printLn(line: string) =
  var n = 0
  for l in runes(line):
    n.inc
    read += l.size
    color = rainbow(freq, seed.float + n / offset)
    if speed != 0:
      sleep(speed)
    stdout.write(ansiForegroundColorCode(color))
    stdout.write(l)
    stdout.flushFile
    if Newlines in $l:
      break

proc cat(text: var string) =
  text.removeSuffix
  while read < text.len:
    printLn(text.substr(read, read + width))
    seed.inc
  resetAttributes()
  echo ""

when isMainModule:
  for kind, key, val in getopt(shortNoVal = {'h', 'v'}, longNoVal = @["help", "version", "test"]):
    case kind
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h": showHelp()
      of "version", "v": showVersion()
      of "freq", "f": freq = val.parseFloat
      of "animate", "a": speed = val.parseInt
      of "seed", "s": seed = val.parseInt
      of "offset", "o": offset = val.parseInt
      of "test": text = test
    of cmdArgument: text = readFile(key)
    of cmdEnd: assert(false)
  
  if seed == 0:
    randomize()
    seed = rand(256)

  if text == "":
    if stdin.isatty: text = "  Usage: lolcat [-f:frequency] [-s:seed] [-p:offset] [-a:animation_speed] [FILE]"
    else: text = $stdin.readAll

  cat(text)
