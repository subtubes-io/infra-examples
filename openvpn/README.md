# Set Up

- `ssh root@52.89.28.167`
- `ssh openvpnas@52.89.28.167`
- `sudo passwd`
- Get around chromes https security warning by typing `thisisunsafe`
- Admin  UI: https://52.89.28.167:943/admin
- Client UI: https://52.89.28.167:943/
- in terraform set `enable_public_acess = 0`

# If locked out 

https://openvpn.net/faq/how-do-i-unlock-users-that-are-locked-out-now/ 

```
cd /usr/local/openvpn_as/scripts/ 
sudo ./sacli --key "vpn.server.lockout_policy.reset_time" --value "1" ConfigPut
sudo ./sacli start
sleep 2
sudo ./sacli --key "vpn.server.lockout_policy.reset_time" ConfigDel
sudo ./sacli start
```