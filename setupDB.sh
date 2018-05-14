echo ">>User name: " $1
echo ">>Simulator identifier: " $2
echo ">>Copying testing database to destination..."
echo ">>cp ./appData.sqlite /Users/"$1"/Library/Developer/CoreSimulator/Devices/"$2"/data/Containers/Data/Application/384EE59F-4779-4B3D-97D1-2E1483C75E16/Documents/"
cp ./appData.sqlite /Users/$1/Library/Developer/CoreSimulator/Devices/$2/data/Containers/Data/Application/384EE59F-4779-4B3D-97D1-2E1483C75E16/Documents/

echo "Listing files in destination folder..."
echo ">>ls /Users/"$1"/Library/Developer/CoreSimulator/Devices/"$2"/data/Containers/Data/Application/384EE59F-4779-4B3D-97D1-2E1483C75E16/Documents/"

ls /Users/$1/Library/Developer/CoreSimulator/Devices/$2/data/Containers/Data/Application/384EE59F-4779-4B3D-97D1-2E1483C75E16/Documents/

