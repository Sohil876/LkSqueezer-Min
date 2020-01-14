#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in late_start service mode

###
# Blackened Mod [SenpaiYank LKSqueezer Adaptation] v1.0 by the
# open source loving BlackenedMod team @ XDA; 
# Various strictly selected, carefully optimized & adjusted      
# tweaks for better day to day performance & battery life,
# specially tuned for the Google Pixel 3 (XL) line-up (Mi A1 in this case)
#
# LKsqueezer is based off this gem ^
# most of the credits go to the its dev team, I've only tuned some parameters and added a couple specific tweaks to it 
# @SenpaiYank
#
# LKsM is based on these ^ gems :)
#@Sohil876
###

# Halt the execution to make sure the system is properly ready and minimize the chances of something overwriting the changes;
if [[ $MODDIR == "/system/bin" ]]; then
  echo "Dev mode."
else
  echo "Delaying service..."
  sleep 70
  stop perfd
fi

LOG_FILE=/storage/emulated/0/logs/lksqueezer.txt
#SCHED_FILE=/storage/emulated/0/logs/.lksfour.ios

# Create the dir for the log file in case it doesn't exist;
if [[ ! -e /storage/emulated/0/logs ]]; then
  mkdir /storage/emulated/0/logs
fi

# Redirect all the output to the log file after clearing it and create a dedicated function for logging;
echo -n "" > $LOG_FILE
exec &>> $LOG_FILE
LOG () {
   echo "[$(date +"%r")] $1"
 }

###_---START---_###
# Create the IOsched definition file in case it doesn't exist and default it to cfq;
#if [[ ! -e $SCHED_FILE ]]; then
#  LOG "first time huh? ;]"
#  echo "cfq" > $SCHED_FILE
#fi

# Start logging
echo "LkSqueezer-Mod:"
echo "[$(date +"%Y/%m/%d")]"
LOG "Starting...!"

### DEBUG ###
# Turn off some pretty useless kernel debugging;
echo "N" > /sys/kernel/debug/debug_enabled
# Disable exception-trace and reduce some overhead that is caused by a certain amount and percent of kernel logging, in case your kernel of choice have it enabled;
echo "0" > /proc/sys/debug/exception-trace
# Disable in-kernel sched statistics for reduced overhead;
echo "0" > /proc/sys/kernel/sched_schedstats
# Turn off excessive MSM_VIDC debugging;
echo "0" > /sys/kernel/debug/msm_vidc/fw_debug_mode
# Turn off even more additional useless kernel debuggers, masks and modules that is not really needed & used at all;
echo "0" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo "0" > /sys/module/binder/parameters/debug_mask
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/cryptomgr/parameters/notests
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "1" > /sys/module/hid/parameters/ignore_special_drivers
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "0" > /sys/module/hid_apple/parameters/iso_layout
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "0" > /sys/module/icnss/parameters/dynamic_feature_mask
echo "N" > /sys/module/ip6_tunnel/parameters/log_ecn_error
echo "Y" > /sys/module/libcomposite/parameters/disable_l1_for_hs
echo "0" > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo "0" > /sys/module/msm_smem/parameters/debug_mask
echo "0" > /sys/module/msm_smp2p/parameters/debug_mask
echo "0" > /sys/module/mt20xx/parameters/tv_antenna
echo "Y" > /sys/module/printk/parameters/console_suspend
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/service_locator/parameters/enable
echo "N" > /sys/module/sit/parameters/log_ecn_error
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work
echo "0" > /sys/module/usb_bam/parameters/enable_event_log
echo "Y" > /sys/module/workqueue/parameters/power_efficient
echo "0" > /sys/module/suspend/parameters/pm_test_delay
# Turn off all debug_mask based sysfs kernel tunables;
for i in $(find /sys/ -name debug_mask); do
echo "0" > $i;
done
# Turn off all debug_level based sysfs kernel tunables;
for i in $(find /sys/ -name debug_level); do
echo "0" > $i;
done
# Turn off all edac logging kernel based sysfs tunables;
for i in $(find /sys/ -name edac_mc_log_ce); do
echo "0" > $i;
done
# Turn off all edac logging kernel based sysfs tunables;
for i in $(find /sys/ -name edac_mc_log_ue); do
echo "0" > $i;
done
# Turn off a few event logging based sysfs kernel tunables;
for i in $(find /sys/ -name enable_event_log); do
echo "0" > $i;
done
# Turn off a few ECN kernel based sysfs loggers;
for i in $(find /sys/ -name log_ecn_error); do
echo "0" > $i;
done
# Turn off all snapshot crashdumper modules;
for i in $(find /sys/ -name snapshot_crashdumper); do
echo "0" > $i;
done

### BLOCK WAKELOCKS ###
# Block harmless wakelocks to maximize sleeping time
echo "qcom_rx_wakelock;wlan;wlan_wow_wl;wlan_extscan_wl;netmgr_wl;NETLINK;7000000.ssusb" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

### KERNEL ###
# Tweak the kernel task scheduler for improved overall system performance and user interface responsivness during all kind of possible workload based scenarios;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NO_LB_BIAS" > /sys/kernel/debug/sched_features
#echo "TTWU_QUEUE" > /sys/kernel/debug/sched_features
echo "NO_RT_PUSH_IPI" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features
#echo "FBT_STRICT_ORDER" > /sys/kernel/debug/sched_features
#echo "NO_EAS_USE_NEED_IDLE" > /sys/kernel/debug/sched_features
echo "NO_STUNE_BOOST_BIAS_BIG" > /sys/kernel/debug/sched_features
echo "NEXT_BUDDY" > /sys/kernel/debug/sched_features
# Kernel based tweaks that reduces the total amount of wasted CPU cycles and gives back a huge amount of needed performance as well as battery life savings to both the whole system and the user experience itself;
echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "20000000" > /proc/sys/kernel/sched_latency_ns
echo "10000000" > /proc/sys/kernel/sched_wakeup_granularity_ns
# For slightly reducing both overall latency and jitter by a fair and well-deserved amount, then increase the target minimum scheduler period in which a single task is allowed to run;
echo "1000000" > /proc/sys/kernel/sched_min_granularity_ns

### NETWORK ###
# Network tweaks for slightly reduced battery consumption when being "actively" connected to a network connection;
echo "128" > /proc/sys/net/core/netdev_max_backlog
echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "0" > /proc/sys/net/ipv4/cipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv4/cipso_cache_enable
echo "0" > /proc/sys/net/ipv4/cipso_rbm_strictvalid
echo "0" > /proc/sys/net/ipv4/igmp_link_local_mcast_reports
echo "24" > /proc/sys/net/ipv4/ipfrag_time
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
echo "1" > /proc/sys/net/ipv4/tcp_ecn
echo "0" > /proc/sys/net/ipv4/tcp_fwmark_accept
echo "320" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "21600" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "1800" > /proc/sys/net/ipv4/tcp_probe_interval
echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo "0" > /proc/sys/net/ipv6/calipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv6/calipso_cache_enable
echo "48" > /proc/sys/net/ipv6/ip6frag_time
# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len
done
LOG "(Ignore warnings like no file or directory found of ipv6)"

### ReMOUNTs ###
# Mounting tweak for better overall partition performance;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime,noauto_da_alloc,barrier=0 -t auto /
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime -t auto /proc
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime,noauto_da_alloc,barrier=0 -t auto /sys
LOG "Partitions remounted with performance enhancing flags"
# Same for data but disable background gc for f2fs;
#if mount | grep -q f2fs; then
# Set data partition type
LOG "Data Partition Type: "
FS="ext4"
if [ $FS = "f2fs" ]; then
  busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime,background_gc=off,fsync_mode=nobarrier -t auto /data
  LOG "  F2FS"
else
  busybox mount -o remount,nosuid,nodev,noatime,nodiratime,relatime,noauto_da_alloc,discard -t auto /data
  LOG "  EXT4"
fi

### CPU ###
# Set the CPU governor to lightningutil (same as above but with the tunings already applied) 
echo "lightningutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# Tune lightningutil governor with new values;
echo "3" > /sys/devices/system/cpu/cpufreq/lightningutil/bit_shift2
echo "3" > /sys/devices/system/cpu/cpufreq/lightningutil/bit_shift1
echo "3" > /sys/devices/system/cpu/cpufreq/lightningutil/bit_shift1_2
echo "94" > /sys/devices/system/cpu/cpufreq/lightningutil/hispeed_load
echo "2016000" > /sys/devices/system/cpu/cpufreq/lightningutil/hispeed_freq
echo "34" > /sys/devices/system/cpu/cpufreq/lightningutil/target_load1
echo "80" > /sys/devices/system/cpu/cpufreq/lightningutil/target_load2
echo "1000" > /sys/devices/system/cpu/cpufreq/lightningutil/up_rate_limit_us
echo "3000" > /sys/devices/system/cpu/cpufreq/lightningutil/down_rate_limit_us
# Set CPU min frequency
# Available frequencies: 652800 1036800 1401600 1689600 1804800 1958400 2016000
echo "0:1036800 1:1036800 2:1036800 3:1036800 4:1036800 5:1036800 6:1036800 7:1036800" > /sys/module/msm_performance/parameters/cpu_min_freq
echo "1036800" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "1036800" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo "1036800" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo "1036800" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
echo "1036800" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo "1036800" > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
echo "1036800" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
echo "1036800" > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
# Set CPU max frequency
# Available frequencies: 652800 1036800 1401600 1689600 1804800 1958400 2016000
echo "0:2016000 1:2016000 2:2016000 3:2016000 4:2016000 5:2016000 6:2016000 7:2016000" > /sys/module/msm_performance/parameters/cpu_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
# Cpu boost duration
echo "0" > /sys/module/cpu_boost/parameters/input_boost_ms
# Aggressively tune stune boost values for better battery life;
#echo "-72" > /dev/stune/background/schedtune.boost
#echo "-32" > /dev/stune/foreground/schedtune.boost
#echo "8" > /dev/stune/top-app/schedtune.boost
#echo "12" > /sys/module/cpu_boost/parameters/dynamic_stune_boost
#echo "128" > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms

### GPU ###
# Set GPU default power level to 7 (19Mhz) for a better batttery life;
echo "6" > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
# Set GPU minimum frequency
echo "133330000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
# Enable and adjust adreno idler for a rather battery aggressive behavior;
echo "N" > /sys/module/adreno_idler/parameters/adreno_idler_active
echo "20" > /sys/module/adreno_idler/parameters/adreno_idler_downdifferential
echo "24" > /sys/module/adreno_idler/parameters/adreno_idler_idlewait
echo "6144" > /sys/module/adreno_idler/parameters/adreno_idler_idleworkload
# Enable adreno boost and set it to low for better gpu up ramping;
echo 0 > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
# Disable frequency scaling throttling of the Adreno GPU circuits;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
# Set opengl renderer
# Default is opengl, skiagl (for opengl skia), skiavk (for vulkan skia).
LOG "OPENGL Renderer: " 
#setprop debug.hwui.renderer skiagl
getprop debug.hwui.renderer
LOG "Forced GPU Rendering: "
#setprop debug.egl.hw 1
getprop debug.egl.hw
LOG "EGL Buffercount: "
#setprop debug.egl.buffcount 0
getprop debug.egl.buffcount

### VIRTUAL MEMORY ###
# Virtual Memory tweaks & enhancements for a (massively?) improved balance between performance and battery life;
echo "0" > /proc/sys/vm/compact_unevictable_allowed
echo "0" > /proc/sys/vm/reap_mem_on_sigkill
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "1" > /proc/sys/vm/oom_kill_allocating_task
echo "1200" > /proc/sys/vm/stat_interval
echo "80" > /proc/sys/vm/swappiness
echo "24" > /proc/sys/vm/dirty_ratio
echo "8" > /proc/sys/vm/dirty_background_ratio
echo "5000" > /proc/sys/vm/dirty_writeback_centisecs
echo "750" > /proc/sys/vm/dirty_expire_centisecs
echo "40" > /proc/sys/vm/vfs_cache_pressure
# VM flush and drop caches;
sync
echo "3" > /proc/sys/vm/drop_caches

### IO ###
# Set the IO scheduler on *blk0 Internal storage (SCHED), *blk1 MMC (SCHED2)
SCHED="noop"
SCHED2="noop"
echo $SCHED > /sys/block/mmcblk0/queue/scheduler
echo $SCHED2 > /sys/block/mmcblk1/queue/scheduler
LOG "IO Scheduler: "
LOG "  Internal storage: "
if [[ $SCHED == "cfq" ]]; then
# Disable low latency mode for increased throughput at the cost of latency;
  echo "1" > /sys/block/mmcblk0/queue/iosched/low_latency
  echo "32768" > /sys/block/mmcblk0/queue/iosched/back_seek_max
  echo "1" > /sys/block/mmcblk0/queue/iosched/back_seek_penalty
  echo "0" > /sys/block/mmcblk0/queue/iosched/group_idle
  echo "1" > /sys/block/mmcblk0/queue/iosched/slice_idle
  echo "200" > /sys/block/mmcblk0/queue/iosched/target_latency
  echo "16" > /sys/block/mmcblk0/queue/iosched/quantum
  echo "248" > /sys/block/mmcblk0/queue/iosched/fifo_expire_async
  echo "124" > /sys/block/mmcblk0/queue/iosched/fifo_expire_sync
  LOG "    CFQ"
elif [[ $SCHED == "bfq" ]]; then
# Lower timeout_sync for a lower process time budget;
  echo "92" > /sys/block/mmcblk0/queue/iosched/timeout_sync
  LOG "    BFQ"
elif [[ $SCHED == "tripndroid" ]]; then
  LOG "    TRIPnDROID"
elif [[ $SCHED == "noop" ]]; then
  LOG "    NOOP"
elif [[ $SCHED == "deadline" ]]; then
# Tune deadline for even lower latencies and an ENERGETIC behavior (lmao);
  echo "2" > /sys/block/mmcblk0/queue/iosched/fifo_batch
  echo "10" > /sys/block/mmcblk0/queue/iosched/read_expire
  echo "50" > /sys/block/mmcblk0/queue/iosched/write_expire
  echo "3" > /sys/block/mmcblk0/queue/iosched/writes_starved
  LOG "    DEADLINE"
fi;
LOG "  MMC: "
if [[ $SCHED2 == "cfq" ]]; then
# Disable low latency mode for increased throughput at the cost of latency;
  echo "1" > /sys/block/mmcblk1/queue/iosched/low_latency
  echo "32768" > /sys/block/mmcblk1/queue/iosched/back_seek_max
  echo "1" > /sys/block/mmcblk1/queue/iosched/back_seek_penalty
  echo "0" > /sys/block/mmcblk1/queue/iosched/group_idle
  echo "1" > /sys/block/mmcblk1/queue/iosched/slice_idle
  echo "200" > /sys/block/mmcblk1/queue/iosched/target_latency
  echo "16" > /sys/block/mmcblk1/queue/iosched/quantum
  echo "248" > /sys/block/mmcblk0/queue/iosched/fifo_expire_async
  echo "124" > /sys/block/mmcblk0/queue/iosched/fifo_expire_sync
  LOG "    CFQ"
elif [[ $SCHED2 == "bfq" ]]; then
# Lower timeout_sync for a lower process time budget;
  echo "92" > /sys/block/mmcblk1/queue/iosched/timeout_sync
  LOG "    BFQ"
elif [[ $SCHED == "tripndroid" ]]; then
  LOG "    TRIPnDROID"
elif [[ $SCHED2 == "noop" ]]; then
  LOG "    NOOP"
elif [[ $SCHED2 == "deadline" ]]; then
# Tune deadline for even lower latencies and an ENERGETIC behavior (lmao);
  echo "2" > /sys/block/mmcblk1/queue/iosched/fifo_batch
  echo "10" > /sys/block/mmcblk1/queue/iosched/read_expire
  echo "50" > /sys/block/mmcblk1/queue/iosched/write_expire
  echo "3" > /sys/block/mmcblk1/queue/iosched/writes_starved
  LOG "    DEADLINE"
fi;
# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!);
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random
  echo "0" > $i/rotational
  echo "128" > $i/read_ahead_kb
done;
# Internal storage;
for i in /sys/block/mmcblk0/queue; do
  echo "0" > $i/io_poll
  echo "0" > $i/iostats
  echo "1" > $i/rq_affinity
  echo "1" > $i/nomerges
  echo "512" > $i/nr_requests
  echo "128" > $i/read_ahead_kb
  echo "write through" > $i/write_cache
done;
# MMC;
for i in /sys/block/mmcblk1/queue; do
  echo "0" > $i/io_poll
  echo "0" > $i/iostats
  echo "1" > $i/rq_affinity
  echo "1" > $i/nomerges
  echo "128" > $i/nr_requests
  echo "write through" > $i/write_cache
done;
# Flash storages dont come with any back seeking problems, so set this as low as possible for performance;
echo "1" > /sys/block/mmcblk0rpmb/queue/iosched/back_seek_penalty
# A couple of minor kernel entropy tweaks & enhancements for a slight UI responsivness boost;
echo "72" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "384" > /proc/sys/kernel/random/write_wakeup_threshold

### FS ###
# FileSystem (FS) optimized tweaks & enhancements for a improved userspace experience;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time
# Disable fsync for more IO throughput (thus faster initialization once again);
# echo "N" > /sys/module/sync/parameters/fsync_enabled
# Dyanamic fsync:
#  When enabled and screen is on, fsync operation is asynchronous;
#  When screen is off, this operation is done synchronously;
#echo '1'> /sys/kernel/dyn_fsync/Dyn_fsync_active
# fstrim the respective partitions for a faster initialization process;
fstrim /cache
fstrim /system
fstrim /data
LOG "FS Timmed (Cache/System/Data)"

### MISC ###
# Disable software crc control;
echo "0" > /sys/module/mmc_core/parameters/use_spi_crc
# Set the power suspend mode to 3 (Hybrid, a combination between LCD and Autosleep modes);
echo "3" > /sys/kernel/power_suspend/power_suspend_mode
# Set animation scale and durations;
settings put global window_animation_scale 1.0
settings put global transition_animation_scale 1.0
settings put global animator_duration_scale 1.0
echo "Transitions: "
echo "  Window animation scale: "
settings get global window_animation_scale
echo "  Transition animation scale: "
settings get global transition_animation_scale
echo "  Animator duration: "
settings get global animator_duration_scale

### IN TESTING ###
# Set-up the CPUSet groups for performance and efficiency;
echo "0-1" > /dev/cpuset/background/cpus
echo "0-7" > /dev/cpuset/camera-daemon/cpus
echo "0-3,5-6" > /dev/cpuset/foreground/cpus
echo "0-3" > /dev/cpuset/restricted/cpus
echo "0-1" > /dev/cpuset/system-background/cpus
echo "0-7" > /dev/cpuset/top-app/cpus
# Migration of tasks from one core to one another is a excessively expensive process for the system and may introduce some extra latency in a possible "worst case scenario". For 'fighting' this, then slightly increase the interval(s) that's required before the kernel considers migrating a task from one core to one another core;
echo "2500000" > /proc/sys/kernel/sched_migration_cost_ns
# Increase the usage of LITTLE cluster for saving power;
#echo "94" > /proc/sys/kernel/sched_downmigrate
# Use RCU_normal instead of RCU_expedited for improved real-time latency, CPU utilization and energy efficiency;
#echo "1" > /sys/kernel/rcu_expedited
echo "1" > /sys/kernel/rcu_normal
# Blackenedmods tunings from pixel4 Q;
# Disable / prevent the possibility of autoloading ldiscs;
echo "0" > /proc/sys/dev/tty/ldisc_autoload
# 
echo "0" > /sys/module/ramoops/parameters/dump_oops
#
# Enable the IOwait_boost flag exclusively on the low power cluster for better performance during heavier IO workloads;
echo "1" > /sys/devices/system/cpu/cpufreq/lightningutil/iowait_boost_enable
#
# ZRAM and swap;
#swapoff /dev/block/zram0
#echo 1 > /sys/block/zram0/reset
#echo 0 > /sys/block/zram0/disksize
#swapon -p 32767 /dev/block/zram0
#  IO tuning for ram and zram
for i in /sys/block/ram*/queue; do
  echo "256" > $i/read_ahead_kb
done;
echo "256" > /sys/block/zram0/queue/read_ahead_kb
#
echo "Y" > /sys/kernel/debug/mdss_panel_fb0/intf0/ulps_feature_enabled
echo "Y" > /sys/kernel/debug/mdss_panel_fb0/intf0/ulps_suspend_enabled
# Fully disable kernel printk console log spamming directly for less amount of useless wakeups (reduces overhead);
echo "0 0 0 0" > /proc/sys/kernel/printk

###_---END---_###
# Everything done, report it in the log file;
if [[ $MODDIR != "/system/bin" ]]; then
  LOG "Module ran successfully!"
  start perfd
fi