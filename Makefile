s3-up:
	@aws s3 cp ./compose-files s3://dk-compose-files/files --recursive