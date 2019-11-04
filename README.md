### LkSqueezer-Mod <v4.0b>

**CHANGES:**
- Disabled: dynamic stuneboost(For now), adreno idler/boost, software CRC control.
- CPU min frequency 1ghz, cpu boost off.
- Gpu power level 6, min frequency 133.
- Io scheduler default NOOP, readahead 128, rq affinity 0 and no-merges 2.
- Data partion type needs to be set manually in service.sh FS variable (Ext4 default, Auto detect not working rn).
- Added 7000000.ssusb to wakelock blocker.


