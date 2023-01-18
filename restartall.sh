echo 'START...'

echo 'HERŞEY BAŞTAN KURULUYOR SAKİN OL :) ...'

apt-get update
apt-get install tcpdump


pgrep ftcollector+ | xargs kill
docker stop miner && docker rm miner
docker stop provision && docker rm provision


crontab -r
{ crontab -l; echo ""; } | crontab -


cd /root && git clone https://github.com/Farukest/minereferance.git minereferance
chmod 700 /root/minereferance/configs/sys.config


# gateway_ID Example
# AA555A0000000001


pf_files=(miner)


for i in {0..1}
do
    collector_address=0.0.0.0
	
	start_listen_port=11429
	listen_port=$(( start_listen_port + i ))
	
	start_gateway_id=429
	gateway_ID_num=$(( start_gateway_id + i ))
	gateway_ID=AA555A0000000$gateway_ID_num
	
	ft_file_name=${pf_files[$i]}
	
	echo "DOSYA ADI : " $ft_file_name
	# exit 0
	
	# which_miner=miner$i
	which_miner=${pf_files[$i]}
	minereferance=minereferance
	
	i2c_value_num=1
	i2c_value_cal=$(( i2c_value_num + i ))
	i2c_value=i2c-$i2c_value_cal

	start_docker_miner_start_port=1429
	docker_miner_start_port=$(( start_docker_miner_start_port + i ))
	
	start_docker_other_start_port=44429
	docker_other_start_port=$(( start_docker_other_start_port + i ))

	pifolder=/root/$which_miner
	if [ -d "$pifolder" ]; then
		echo $which_miner
		echo 'Miner Pi Hnt KLASORU SILINIYOR ...'
		rm -rf /root/$which_miner
	fi

	# ftfolder=/home/$ft_file_name
	# if [ -d "$ftfolder" ]; then
		# echo $ft_file_name
		# echo 'FT KLASORU SILINIYOR ...' $ft_file_name
		# rm -rf /home/$ft_file_name/
	# fi

	# cd /home/ && git clone https://github.com/Farukest/ft_pscs_simple.git $ft_file_name

	#home pi hnt miner altındaki referans alınan sys.configi replace edilebilen dosya
	mkdir /root/$which_miner
	cp -r /root/$minereferance/* /root/$which_miner
	chmod 700 /root/$which_miner/configs/sys.config
	sed -i 's/"replace_i2c_value"/"'${i2c_value}'"/g' /root/$which_miner/configs/sys.config


	sleep 1

	docker stop $which_miner && docker rm $which_miner


	docker run -d \
	--publish $docker_miner_start_port:1680/udp \
	--publish $docker_other_start_port:44158/tcp \
	--name $which_miner \
	--restart always \
	--mount type=bind,source=/root/$which_miner/log,target=/var/log/miner --device /dev/$i2c_value  --privileged -v /var/run/dbus:/var/run/dbus \
	--mount type=bind,source=/root/$which_miner,target=/var/data \
	--mount type=bind,source=/root/$which_miner/configs/sys.config,target=/config/sys.config \
	quay.io/team-helium/miner:miner-arm64_2022.10.28.0_GA



	# chmod 777 /home/$ft_file_name/ftmiddle_configs/conf1.json
	# sed -i 's/"replace_listen_port_address"/'${listen_port}'/g' /home/$ft_file_name/ftmiddle_configs/conf1.json
	# sed -i 's/"replace_serv_port_up"/'${docker_miner_start_port}'/g' /home/$ft_file_name/ftmiddle_configs/conf1.json
	# sed -i 's/"replace_serv_port_down"/'${docker_miner_start_port}'/g' /home/$ft_file_name/ftmiddle_configs/conf1.json

	# chmod 777 /home/$ft_file_name/ftmiddle_configs/conf1.json
	# sed -i 's/"replace_gateway_id"/"'${gateway_ID}'"/g' /home/$ft_file_name/ftmiddle_configs/conf1.json

	# chmod 700 /home/$ft_file_name/first.sh
	# cd /home/$ft_file_name/ && ./first.sh $ft_file_name



	# echo 'Jobs adding to cron..'
	# cd /home/$ft_file_name/ && ./addcron.sh $ft_file_name $which_miner

	echo 'SUCCESS THAT IS ALL..'
	
	exit
done

echo "Miner ismi 6 saniye içinde gelecek..  "

sleep 6

echo $(docker exec miner miner print_keys)


