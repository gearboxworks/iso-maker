```
 __          _______  _      _ _       ____
 \ \        / /  __ \| |    (_) |     |  _ \
  \ \  /\  / /| |__) | |     _| |__   | |_) | _____  __
   \ \/  \/ / |  ___/| |    | | '_ \  |  _ < / _ \ \/ /
    \  /\  /  | |    | |____| | |_) | | |_) | (_) >  <
     \/  \/   |_|    |______|_|_.__/  |____/ \___/_/\_\
```

![GearBox](https://github.com/gearboxworks/box-scripts/blob/master/GearBox-100x.png)

# W010 - Error image doesn't conform to JSON config format in 0.16 or later.

## Cause
Usually an error returned from the `box` command with any of the sub-commands `install`, `start`, `stop`, `rm`, `clean` and `refresh`.
The specified container image is not using the GearBox JSON string that is present in all images from GearBox version 0.16 and onwards.

## Common fixes
You may have to upgrade to GearBox 0.16 or later.
Alternatively start the container manually.

### 


## See Also
[Complete Error code repository for GearBox](https://github.com/gearboxworks/box-scripts/tree/master/docs/errors)

