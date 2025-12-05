
# 📘 **README — Barber Reserve (Flutter + Django API)**

## 🧾 **Descrição do Projeto**

O **Barber Reserve** é um sistema completo composto por **aplicativo Flutter** e **API Django**, permitindo que usuários realizem:

* Cadastro
* Login
* Seleção de perfil (Cliente ou Profissional/Salão)
* Cadastro de empresa (para profissionais)
* Fluxo completo de agendamento e gerenciamento

O objetivo é oferecer uma plataforma moderna, rápida e escalável.

---

# 🛠 **Tecnologias Utilizadas**

### **Frontend — Flutter**

* Flutter 3+
* Dart


### **Backend — Django**

* Python 3.10+
* Django 4+
* Django REST Framework
* SQLite
* JWT Authentication (caso exista)

---

# 📂 **Estrutura do Projeto**

## **📱 Estrutura do App Flutter**

*(baseada na sua imagem enviada)*

```
lib/
 ├── modules/
 │    ├── usuario/
 │    ├── salao/
 │    ├── servico/
 │    ├── agendamento/
 │    └── profissional/
 │
 ├── widgets/
 ├── theme/
 ├── utils/
 └── main.dart
```

---

## **🖥 Estrutura da API Django**

📌 **COLOQUE A IMAGEM AQUI**

> 🔲 *INSERIR A IMAGEM DA ESTRUTURA DA API DJANGO AQUI*
> (Quando você conseguir gerar a imagem, basta adicioná-la nesta seção do README)

---

# ⚙️ **Como Rodar o Projeto Flutter**

### 1️⃣ Instalar dependências

```bash
flutter pub get
```

### 2️⃣ Configurar URL da API

Edite o arquivo onde fica sua baseURL:

```dart
const String baseUrl = "http://127.0.0.1:8000/api";
```

Para celular físico via USB:

```dart
const String baseUrl = "http://SEU_IP:8000/api";
```

### 3️⃣ Rodar o app

```bash
flutter run
```

---

# ⚙️ **Como Rodar a API Django**

### 1️⃣ Criar ambiente virtual

```bash
python -m venv venv
```

### 2️⃣ Ativar

Windows:

```bash
venv\Scripts\activate
```

Linux/Mac:

```bash
source venv/bin/activate
```

### 3️⃣ Instalar dependências

```bash
pip install -r requirements.txt
```

### 4️⃣ Rodar migrações

```bash
python manage.py migrate
```

### 5️⃣ Criar superusuário

```bash
python manage.py createsuperuser
```

### 6️⃣ Rodar servidor

```bash
python manage.py runserver
```

---

# 🔗 **Principais Endpoints da API**

### **Cadastro**

```
POST /api/register/
```

### **Login**

```
POST /api/login/
```

### **Definir Perfil**

```
POST /api/definir-perfil/
```

### **Cadastrar salão / empresa**

```
POST /api/salao/cadastrar/
```

---

# 🧪 **Como Testar o Fluxo Completo**

### 1. Criar uma conta

✔ OK

### 2. Sistema redireciona para tela de escolha do perfil

✔ Cliente
✔ Profissional/Salão

### 3. Se escolher Cliente

➡ Volta para login
➡ Acessa o app normalmente

### 4. Se escolher Profissional/Salão

➡ Vai para o cadastro de empresa
➡ Preenche dados
➡ Salva
➡ É redirecionado para o dashboard

---

# 🐞 **Erros Comuns e Soluções**

### ❗ CORS ERROR

Adicionar no Django:

```python
CORS_ALLOW_ALL_ORIGINS = True
```

### ❗ Não cadastra

* Banco não tem migrações
* Endpoint errado
* URL errada no Flutter
* Model mudou e não foi migrado

### ❗ 400 ou 500 no login

* Campo JSON diferente do esperado
* Senha não está sendo enviada corretamente

---

# 🚀 **Roadmap Futuro**

* Adicionar sistema de pagamentos
* Criar módulo de avaliações
* Criar painel web administrativo
* Melhorar sistema de agenda inteligente

---

# 📜 **Licença**

Projeto interno — uso restrito.

