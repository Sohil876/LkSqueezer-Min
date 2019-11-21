### LkSqueezer-Mod <v4.5>

**CHANGES:**
- Disabled: dynamic stuneboost(For now), adreno idler/boost, software CRC control.
- CPU min frequency 1ghz, cpu boost off.
- Gpu power level 6, min frequency 133.
- Io scheduler default CFQ on internal and NOOP on MMC, rq affinity 0 and no-merges 2, readahead 256 and nr request 256 on internal and 128/128 on MMC.
- Data partion type needs to be set manually in service.sh FS variable (Ext4 default, Auto detect not working rn).
- Added 7000000.ssusb to wakelock blocker.
- Added transition scale and duration settings.


