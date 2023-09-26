
#  Дипломная работа по профессии «Системный администратор» - Корольков Денис

Выполнение:

Установил YC CLI, Terraform (Ansible еще не устанавливал) и понеслось... описал основу моей инфраструктуры в конфигурационном файле vpc.tf, параметры создания ВМ в файле main.tf. Благодаря заданным параметрам из этих файлов-конфигурации средствами terraform и формируется инфраструктура в Yandex Cloud. В качестве ОС использую Ubuntu 20.04.

Итак, в Yandex Cloud формируется сеть - korolkov-network-diplom, с подсетями - web-srv-1, web-srv-2, subnet-zabbix, subnet-grafana, subnet-elasticsearch, subnet-kibana, subnet-ssh-gw.
Разворачиваются следующие сервера:  
1. web-srv-1.srv, web-srv-2.srv - веб-серверы nginx. На группу этих web-серверов настроена балансировка нагрузки, а также установлены сервисы zabbix-agent2 и filebeats, позволяющие передавать информацию мониторинга и содержимое логов на серверы zabbix и elasticsearch соответственно;
2. zabbix.srv - сервер мониторинга zabbix;
3. grafana.srv - сервер визуализации информации, собираемой сервером мониторинга zabbix;
4. elasticsearch.srv - сервер сбора логов, на котором будут подняты сервисы elasticsearch и logstash, входяшие в стек ELK;
5. kibana.srv - сервер визуализации логов (также из стека ELK);
6. ssh-gw.srv - (ssh gateway) - bastion host, сервер, позволяющий получить доступ к остальным серверам инфраструктуры по протоколу ssh.

Так должно быть )) и сеть у меня строится и ВМ устанавливаюися, но ...есть вопросы по дальнейшим моим действиям..тонким настройкам так сказать.

1. Настройка Zabbix? Подключаться по ssh  и настраивать вручную или есть способ настройки zabbix - установки нужных дашбордов через терминал?
2. Ansible еще не ставил...но вопрос есть - с помощью ansible ставить nginx, zabbix, postgres и иное ПО?
3. Bastion host срабатывает на отлично! Теперь вопрос - правильно будет ставить на него ansible - для распространнения ПО на ВМ внутри сети? Или когда всё ПО на ВМ будет установлено и эти ВМ будут настроены bastion host ставится как заглушка безопасности?
4. Попробовал установить полезное ПО с помощью meta-...yml файлов, но что то пошло не так. Вопрос - есть ли хорошее описание как правильно описывать установку и запуск ПО с помощью средств terraform?
5. Мне необходимо еще время для доработки проекта. ))

скрины запущенной сети прилагаю:

![screen1](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen1.jpg)
![screen2](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen2.jpg)
![screen3](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen3.jpg)
![screen4](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen4.jpg)
![screen5](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen5.jpg)
![screen6](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen6.jpg)
![screen7](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen7.jpg)
![screen8](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen8.jpg)
![screen9](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen9.jpg)
![screen10](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen10.jpg)
![screen11](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen11.jpg)
![screen12](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen12.jpg)
![screen13](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen13.jpg)
![screen14](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen14.jpg)
![screen15](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen15.jpg)
![screen16](https://github.com/KorolkovDenis/Diplom/blob/main/screenshots/screen16.jpg)
