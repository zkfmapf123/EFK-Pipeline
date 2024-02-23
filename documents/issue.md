# Issue

## vm.max_map_count is too low issue

```sh
sudo vi /etc/sysctl.conf
vm.max_map_count=262144
sudo sysctl -p
```