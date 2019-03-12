```
 __          _______  _      _ _       ____
 \ \        / /  __ \| |    (_) |     |  _ \
  \ \  /\  / /| |__) | |     _| |__   | |_) | _____  __
   \ \/  \/ / |  ___/| |    | | '_ \  |  _ < / _ \ \/ /
    \  /\  /  | |    | |____| | |_) | | |_) | (_) >  <
     \/  \/   |_|    |______|_|_.__/  |____/ \___/_/\_\
```

![GearBox](https://github.com/gearboxworks/box-scripts/blob/master/GearBox-100x.png)

# W021 - box-scripts not present.

## Cause
The /opt/gearbox scripts are not present on the Box.

## Common fixes
Pull down the latest box-scripts by doing the following:
* sudo git clone -q https://github.com/gearboxworks/box-scripts/ /opt/gearbox
Run an update:
* /opt/gearbox/bin/box self-update


### 


## See Also
[Complete Error code repository for GearBox](https://github.com/gearboxworks/box-scripts/tree/master/docs/errors)

