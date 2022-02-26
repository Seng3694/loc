# LoC script written in Ruby #
Counts and prints out the non empty lines of code used by files in a directory.

## Command Line Interface ##

| Option   | Short | Explanation                                                                |
|----------|-------|----------------------------------------------------------------------------|
| --filter | -f    | File extension filter. (e.g. "hpp cpp lua asm")                            |
| --exclude| -e    | Directories to exclude. (e.g. "ext .vs .git")                              |
| --comment| -c    | Flag to ignore comments while counting lines                               |
| --help   | -h    | Prints help text.                                                          |

## Example usages ##

Count lines of code in all `.cpp` and `.hpp` files in the `..\root\directory` directory. Skip files in `..\root\directory\ext\*` and `..\root\directory\.vs\*`.

```bat
>ruby loc.rb -f "cpp hpp" -e "ext .vs" ..\root\directory
```

Count all non comment lines in **all** files in the current directory.

```bat
>ruby loc.rb -c
```

## Example output ##

```bat
>ruby loc.rb -f "c h" -e "ext example .git .vs" ..\..\c\deque
```

```
src/deque.c     161
src/test.c       94
include/deque.h  24
___________________
total           279
```

## Notes ##
- Script was made mainly for getting a feel for Ruby. Feel free to suggest changes!
- Currently only the following languages are supported for comment exclusion: C, C++, C#, Lua, Ruby, Python

## License ##

MIT License: see [License][1] for more information.

[1]:LICENSE
