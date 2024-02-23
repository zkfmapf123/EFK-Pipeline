tags=kibana,master,slave-1,slave-2

s3-up:
	@aws s3 cp ./compose-files s3://dk-compose-files/files --recursive

ec2-up:
	./shells/up.sh

ec2-down:
	./shells/down.sh
