
begin_time=`(date +%s.%N)`

#./parallel -j 5 --xapply ./task1.sh ::: `seq 1 5` ::: `seq 11 15`

parallel -j 100 ./run.sh ::: `seq 1 1000`

end_time=`(date +%s.)`

start_s=$(echo $begin_time | cut -d '.' -f 1)
end_s=$(echo $end_time | cut -d '.' -f 1)

time=$(($end_s-$start_s))

echo "duration:" $time "s"

#空包发送 1000个382s，100个17s，10000个（失败未测出）