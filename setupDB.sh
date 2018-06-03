echo ">>User name: " $1
echo ">>Simulator identifier: " $2
echo ">>App identifier: " $3
echo ">>Copying testing database to destination..."
echo ">>cp ./appData.sqlite /Users/"$1"/Library/Developer/CoreSimulator/Devices/"$2"/data/Containers/Data/Application/"$3"/Documents/"
cp ./appData.sqlite /Users/$1/Library/Developer/CoreSimulator/Devices/$2/data/Containers/Data/Application/$3/Documents/

echo "Listing files in destination folder..."
echo ">>ls /Users/"$1"/Library/Developer/CoreSimulator/Devices/"$2"/data/Containers/Data/Application/"$3"/Documents/"

ls /Users/$1/Library/Developer/CoreSimulator/Devices/$2/data/Containers/Data/Application/$3/Documents/

