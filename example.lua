local fpipe = require 'filterpipe'

print("\nExample 1\n")

io.output():write(
  fpipe.pipe( "abc?def?ghi\njklmnop?qr\nstu\tvwx\n", -- the trailing \n is required by column
    "column", -- the command
    "-t", "-s?")) -- parameters

print("\nExample 2\n")

-- shorthand notation for pipes
io.output():write(fpipe._{{"mount"},{"column", "-t"},{"tac"}})


