watch -n 1 '
NCPU=$(nproc)

echo "[me]";
ps -u $USER -o %cpu=,rss= | awk "{cpu+=\$1; rss+=\$2} END{printf \"CPU used: %.1f%% (%.2f CPUs) | MEM: %.2f GB\n\", cpu, cpu/100, rss/1024/1024}";

echo;
echo "[all users]";
ps -eo user=,%cpu=,%mem= | awk "{cpu[\$1]+=\$2; mem[\$1]+=\$3} END{for(u in cpu) printf \"%-20s CPU:%8.1f%% (%.2f CPUs)  MEM:%8.1f%%\n\", u, cpu[u], cpu[u]/100, mem[u]}" | sort -k2,2nr;

echo;
echo "[system]";
top -bn1 | awk -v ncpu="$NCPU" "
/^%Cpu/{
  for(i=1;i<=NF;i++){
    if(\$i ~ /id,?/) idle=\$(i-1)
  }
  used=100-idle
  free_cpu=idle/100*ncpu
  used_cpu=used/100*ncpu
  printf \"CPU total: %d | used: %.1f%% (%.2f CPUs) | free: %.1f%% (%.2f CPUs)\n\", ncpu, used, used_cpu, idle, free_cpu
}
/^MiB Mem/{
  printf \"MEM used: %s MiB | MEM free: %s MiB | MEM total: %s MiB\n\", \$8, \$6, \$4
}"'