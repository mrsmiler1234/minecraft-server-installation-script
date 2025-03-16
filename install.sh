if [ -z "$1" ]; then
  echo "Версия не указана"
  exit 1
fi

sudo apt update -y
sudo apt install jq curl openjdk-17-jre-headless p7zip-full -y

API_URL="https://api.papermc.io/v2/projects/paper/versions/$1"
LATEST_BUILD=$(curl -s "$API_URL" | jq '.builds | max')
JAR_URL="$API_URL/builds/$LATEST_BUILD/downloads/paper-$1-$LATEST_BUILD.jar"

if [[ -d "$HOME/server" ]]; then
echo ""
echo "[Установка] Директория $HOME/server определена. Выполнить чистую установку с удалением данных? (y/n)"
read -r answer
case $answer in
y) 
    rm -rf $HOME/server
    mkdir $HOME/server 
    ls
    echo ""
    echo "[Установка] Директория $HOME/server удалена. Продолжаем установку"
    ;;
esac
fi

mkdir $HOME/server
cd $HOME/server

echo ""
echo "----INFO----"
echo "Version: $1"
echo "Latest build: $LATEST_BUILD"
echo "URL to download: $JAR_URL"
echo "----INFO----"

echo ""
echo "[Установка] Скачиваю ядро..."
echo ""

curl -o "server.jar" $JAR_URL

echo "eula=true" > eula.txt

echo ""
echo "[Установка] Укажите максимальное кол-во потребляемой сервером ОЗУ (только число!)"
read -r gb

MAX_RAM="-Xmx${gb}G"

echo "java -Xms100M $MAX_RAM -jar server.jar" > start.sh

chmod +x start.sh

echo ""
echo "[Установка] Установка завершена! Запускай ./start.sh для старта сервера"
echo "[Установка] Если хочешь сразу установить карту, впиши ПРЯМУЮ ССЫЛКУ на карту в zip/7z формате. Если не хочешь - пиши n"
read -r answ

case $answ in 
n) 
    exit
    ;;
esac

curl -o "mapw" $answ
7za x "mapw" -oc:world/

if [[ ! -d world/data ]]; then
  echo "[Установка] Карта распакована, но data/ не найдена. Проверяем вложенные папки..."
  
  for dir in $HOME/server/world/*/; do
    if [[ -d "$dir/data" ]]; then
      echo "[Установка] Найдена папка с картой: $dir"
      
      mv "$dir"/* $HOME/server/world/
      rm -r "$dir"
      break
    fi
  done
fi

cd $HOME/server

echo "[Установка] Установка карты завершена! Можешь запускать сервер через ./start.sh"
