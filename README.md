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

## Делал без понятия зачем и кому это может быть нужно вообще.

