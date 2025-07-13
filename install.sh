if [ -z "$1" ]; then
  echo "Версия не указана"
  exit 1
fi

sudo apt update -y
sudo apt install software-properties-common -y
sudo apt install jq curl openjdk-21-jre-headless p7zip-full -y

API_URL="https://api.papermc.io/v2/projects/paper/versions/$1"
LATEST_BUILD=$(curl -s "$API_URL" | jq '.builds | max')
JAR_URL="$API_URL/builds/$LATEST_BUILD/downloads/paper-$1-$LATEST_BUILD.jar"

if [[ -d "$HOME/server" ]]; then
echo ""
echo "[Установка] Директория $HOME/server определена. Выполнить чистую установку с удалением данных? (y/n)"
read -r c_answ
case $c_answ in
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
echo "[Установка] Укажите максимальное кол-во потребляемой сервером ОЗУ (только число, гигабайты)"
read -r gb_answ

MAX_RAM="-Xmx${gb_answ}G"

echo "java -Xms100M $MAX_RAM -jar server.jar" > start.sh

chmod +x start.sh

echo ""
echo "[Установка] Установка завершена! Запускай ./start.sh для старта сервера"
echo "[Установка] Если хочешь сразу установить карту, впиши ПРЯМУЮ ССЫЛКУ на карту в zip/7z формате. Если не хочешь - пиши n"
read -r m_answ

case $m_answ in 
n) 
    exit
    ;;
esac

curl -o "mapw" $m_answ
7za x "mapw" -oc:world/

if [[ ! -d world/data ]]; then
  echo ""
  echo "[Установка] Карта распакована, но data/ не найдена. Проверяем вложенные папки..."
  
  for dir in $HOME/server/world/*/; do
    if [[ -d "$dir/data" ]]; then
      echo "[Установка] Найдена папка с картой: $dir"
      
      mv "$dir"/* $HOME/server/world/
      rm -r "$dir"
      break
    fi
  done
  for dir in $HOME/server/c\:world/*/; do
    if [[ -d "$dir/data" ]]; then
      echo "[Установка] Найдена папка с картой: $dir"
      
      mkdir $HOME/server/world
      mv "$dir"/* $HOME/server/world/
      rm -r "$dir"
      break
    fi
  done
fi

cd $HOME/server

echo ""
echo "[Установка] Разрешить подключение с пиратских клиентов и командные блоки? (y/n)"
read -r p_answ

case $p_answ in
y) 
    echo "online-mode=false" > server.properties
    echo "enable-command-block=true" >> server.properties
    ;;
esac

echo ""
echo "[Установка] Готово! Теперь вы можете установить готовый набор плагинов! Выберите одну цифру из предложенных:"
echo ""
echo "---LIST---"
echo "0. Пропустить"
echo "1. SkinsRestorer"
echo "2. SkinsRestorer + PaperCracker (+ MixBukkit)"
echo "---LIST---"
echo ""
echo "Ваш выбор: " 
read -r n_answ

mkdir $HOME/server/plugins
cd $HOME/server/plugins

install_skinsrestorer() {
    echo "[Установка] Устанавливаю SkinsRestorer..."
    echo ""
    wget https://github.com/SkinsRestorer/SkinsRestorer/releases/download/15.6.0/SkinsRestorer.jar
    echo ""
}

install_papercracker() {
    echo "[Установка] Устанавливаю PaperCracker..."
    echo ""
    wget https://github.com/mrsmiler1234/minecraft-server-installation-script/releases/download/1.0/PaperCracker.jar
    echo ""
}

install_mixbukkit() {
    echo "[Установка] Устанавливаю MixBukkit..."
    echo ""
    wget https://github.com/DragonCommissions/MixBukkit/releases/download/1.0/MixBukkit-1.0-SNAPSHOT.jar
    echo ""
}


case $n_answ in
    1)
        install_skinsrestorer
        ;;
    2)
        install_skinsrestorer
        install_papercracker
        install_mixbukkit
        ;;
    0)
        echo "[Установка] Пропущено."
        ;;
    *)
        echo "[Ошибка] Некорректный ввод."
        ;;
esac

echo "[Установка] Готово! Вы можете запускать сервер!"
cd $HOME
