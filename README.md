🎥 Vídeo de Apresentação (API + Client)

Para facilitar a visualização do funcionamento completo do sistema, disponibilizamos um vídeo demonstrativo no YouTube:

👉 Assista aqui: https://www.youtube.com/watch?v=RXcHbLuPCGk

---

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
* JWT Authentication

---

# 📂 **Estrutura do Projeto**

## **📱 Estrutura do App Flutter**

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

```css
📦 backend/
│
├── 📁 agendamento/
├── 📁 backend/          /* Configurações principais do Django */
├── 📁 cliente/
├── 📁 profissional/
├── 📁 salao/
├── 📁 servico/
├── 📁 usuario/
│
├── 📁 venv/             /* Ambiente virtual (não enviar para o GitHub) */
│
├── 📄 .gitignore
├── 📄 db.sqlite3        /* Banco local SQLite */
├── 📄 diagrama.puml     /* Diagrama do sistema (PlantUML) */
├── 📄 manage.py         /* Entrada principal do Django */
└── 📄 requirements.txt  /* Dependências da API */
```

---

# ⚙️ **Como Rodar o Projeto Flutter**

### 1️⃣ Instalar dependências

```bash
flutter pub get
```

### 2️⃣ Configurar URL da API

Edite a baseURL:

```dart
const String baseUrl = "http://127.0.0.1:8000/api";
```

Para celular físico:

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

### 2️⃣ Ativar ambiente

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

### 4️⃣ Aplicar migrações

```bash
python manage.py migrate
```

### 5️⃣ Criar superusuário

```bash
python manage.py createsuperuser
```

### 6️⃣ Iniciar servidor

```bash
python manage.py runserver
```

---

# 🔗 **Principais Endpoints da API**

### Cadastro

```
POST /api/register/
```

### Login

```
POST /api/login/
```

### Definir Perfil

```
POST /api/definir-perfil/
```

### Cadastrar Salão

```
POST /api/salao/cadastrar/
```

---

# 🧪 **Como Testar o Fluxo Completo**

### 1. Criar uma conta

### 2. Selecionar o perfil

* Cliente
* Profissional/Salão

### 3. Se cliente

➡ Redireciona para login
➡ Entra no sistema

### 4. Se profissional/salão

➡ Tela de cadastro da empresa
➡ Salvar dados
➡ Entra no dashboard

---




# 📜 **Licença**

Projeto interno — uso restrito.

---
