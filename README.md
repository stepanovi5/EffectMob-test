# EffectMob-test

Мониторинг процесса `test` через systemd timer.

## Возможности
- Проверяет процесс `test` каждую минуту.
- Если процесс запущен — обращается по HTTPS к `https://test.com/monitoring/test/api`.
- Если процесс перезапущен — пишет запись в `/var/log/monitoring.log`.
- Если сервер мониторинга недоступен — пишет об этом в лог.

## Проверка

```bash
systemctl status monitor_test.timer
journalctl -u monitor_test.service -n 20
sudo tail -n 20 /var/log/monitoring.log
```

## Делал на домашнем сервере RaspberryPi5 @blackgring0

vless://a891b535-518b-47a2-871d-070ce4306994@93.100.183.144:50590?type=tcp&encryption=none&security=reality&pbk=U9ZsjDxzC-XruJizW0Ur3R005ANvXmCOz0NuH_PiRhE&fp=firefox&sni=google.com&sid=f4&spx=%2F&flow=xtls-rprx-vision#vless-reality-EffectMob-test

