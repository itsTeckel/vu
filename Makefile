build:
	docker build -t itsteckel/vu:latest .

push:
	docker push itsteckel/vu:latest

pull:
	docker image pull itsteckel/vu:latest

run:
	-mkdir volume
	-docker stop vu
	-docker rm vu
	docker run --name vu -it \
	-d itsteckel/vu:latest /bin/bash
	docker exec -it vu /bin/bash

clean:
	docker system prune

