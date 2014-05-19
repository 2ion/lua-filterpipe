local fpipe = require 'filterpipe'

io.output():write(
  fpipe( "abc?def?ghi\njklmnop?qr\nstu\tvwx\n", -- the trailing \n is required by column
    "column", -- the command
    "-t", "-s?")) -- parameters
