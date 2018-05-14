echo ">>User name: " $1
echo ">>Simulator identifier: " $2
echo ">>Copying testing database to destination..."
echo ">>cp ./appData.sqlite /Users/"$1"/Library/Developer/CoreSimulator/Devices/"$2"/data/Containers/Data/Application/384EE59F-4779-4B3D-97D1-2E1483C75E16/Documents/"
cp ./appData.sqlite /Users/Qihao/Library/Developer/CoreSimulator/Devices/1E26E342-BD57-4052-812D-252AB91DDA5D/data/Containers/Data/Application/384EE59F-4779-4B3D-97D1-2E1483C75E16/Documents/

echo "Listing files in destination folder..."
echo ">>ls /Users/"$1"/Library/Developer/CoreSimulator/Devices/"$2"/data/Containers/Data/Application/384EE59F-4779-4B3D-97D1-2E1483C75E16/Documents/"

ls /Users/$1/Library/Developer/CoreSimulator/Devices/$2/data/Containers/Data/Application/384EE59F-4779-4B3D-97D1-2E1483C75E16/Documents/

