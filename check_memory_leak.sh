#!/bin/bash

echo "Checking memory.."
while true
do
        ps=`ps -e | awk '{print $1}'`
        pss=($(echo $ps | tr "\n" " "))
        vd=("PID")

        for ((i=1;i<=${#pss[@]};i++))
        do
                if [ -e /proc/${pss[$i]}/status ]
                then
                        temp=`cat /proc/${pss[$i]}/status | grep VmData`
                        if [[ "$temp" == *ata*kB* ]]
                        then
                                vd+=(${pss[$i]} "$temp")
                        fi
                fi
        done
        sleep 30
        for ((i=1;i<${#vd[@]};i+=2))
        do
                pid=${vd[$i]}
                if [ -e /proc/$pid/status ]
                then
                        idx=`expr $i + 1`
                        mem=($(echo ${vd[$idx]} | tr " " " "))
                        cur_mem=($(echo `cat /proc/$pid/status | grep VmData` | tr " " " "))

                        if [ "${cur_mem[1]}" -gt "${mem[1]}" ]
                        then
                                pname=`cat /proc/$pid/status | grep Name`
                                echo -e "PID:$pid \t $pname"
                                echo -e "MEM: ${mem[1]} \t > \t ${cur_mem[1]}kB"
                        fi
                fi
        done
done
