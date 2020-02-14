# drupalindocker
This project share my vision as a [Devops and Drupal Architect](https://drupal.org/u/macherif) of how to use Docker in a Drupal project. At the moment I already use this vision in some of my projects and it's a life saver solution. Letting all developers team share the same environement configuration. And soon I will add more feature.
# Installation:
You can copy and paste default-docker-compose.yml to docker-compose.yml and run docker-compose up.
# Features:
- Tuned composer with a lot of ready scripts.
- PhpStan Ready.
- Nginx container.
- PHP CLI service including drush, drupal console and a lot of cli already installed commands.
- PHP-FPM with a tuned php.ini .
- MariaDB service.
- Adminer service.
- Redis service.
# Next Features:
- ELK with a grabber of services logs messages.
- Solr because it's preffered by a lot of Drupal builders. (personnally I prefers Elasticsearch for many reasons).
- Sonar for code quality test.
- Kubernetes scripts for easy CI/CD.
