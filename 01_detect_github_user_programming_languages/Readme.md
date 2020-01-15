## Задача
Надо написать `CLI`-утилиту, которая
  - на вход получает `username` пользователя на `GitHub`
  - на выходе печатает языки программирования, которыми пользователь владеет

Данные по пользователям и их репозиториям доступны через публичный Github API: `curl https://api.github.com/users/spajic`

Доки тут: https://developer.github.com/v3/users/

В качестве http клиента можно взять `httpoison` (попроще), или `mint` (`api` посложнее, но должен быть побыстрее).

## Сборка и использование
```bash
mix escript.build
./detect_github_user_programming_languages spajic

C++, Python, Ruby, JavaScript, Elixir, Go
```
