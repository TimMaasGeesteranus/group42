RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}Updating files with git:${NC}"
git pull

echo -e "${RED}Deleting container and image:${NC}"
sudo docker stop web_api_application
sudo docker rm web_api_application
sudo docker rmi web_api

echo -e "${RED}Publishing web_api:${NC}"
dotnet publish -c Release

echo -e "${RED}Creating new web_api image: ${NC}"
sudo docker build -t web_api -f Dockerfile .

echo -e "${RED}Creating new web_api_application container: ${NC}"
sudo docker-compose up -d

echo -e "${RED}end"