#!/usr/bin/env lua5.2

-- filterpipe.lua - pipe data through an external command and read back the result
-- Written by Jens Oliver John <dev@2ion.de>
-- This code is hereby placed in the Public Domain.

local posix = require 'posix'
local table = table

--
-- SYNOPSIS
--
-- input := Lua string with arbitrary data
-- cmd := command to execute
-- ... := optional arguments to the command
-- Returns a Lua string containing what cmd
-- wrote to stdout.

local function pipe(input, cmd, ...)
  local input = input
  local cmd = cmd
  local d = {}

  local r, w = posix.pipe()
  local pid = posix.fork()
  if pid == 0 then
    posix.close(r)
    posix.write(w, input)
    posix._exit(0)
  end
  posix.close(w)

  local r2, w2 = posix.pipe()
  local pid2 = posix.fork()
  if pid2 == 0 then
    posix.dup2(r, 0)
    posix.dup2(w2, 1)
    local ret = posix.execp(cmd, ...) or 1
    posix._exit(ret)
  end
  posix.close(w2)
  posix.close(r)

  local b = posix.read(r2, 1)
  while #b == 1 do
    table.insert(d, b)
    b = posix.read(r2, 1)
  end
  posix.close(r2)

  posix.wait(pid2)
  posix.wait(pid)
  return table.concat(d)
end

local function _(tubes, input)
  local i = input or ""
  for __,tube in ipairs(tubes) do
    i = pipe(i, table.unpack(tube)) or ""
  end
  return i
end

return { pipe = pipe, _ = _ }
