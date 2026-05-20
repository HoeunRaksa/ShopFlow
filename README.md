# ShopFlow

ShopFlow is a full-stack mobile e-commerce application designed to provide a secure, scalable, and modern online shopping experience. The project was developed using **Flutter** for cross-platform mobile development and **Spring Boot (Java)** for backend API services, with **MySQL** used for database management.

The application focuses on clean architecture, responsive UI/UX, secure authentication, and efficient communication between frontend and backend systems. ShopFlow was built as a practical project to strengthen experience in mobile development, backend engineering, API integration, authentication systems, and full-stack application architecture.

---

## Features

### Authentication & Security
- User registration and login
- JWT (JSON Web Token) authentication
- Secure API access
- Protected routes/endpoints
- User profile management

### Product Management
- View product lists
- Product details
- Product categories
- Product search and filtering
- Product image upload
- Product creation and update

### Shopping Features
- Add to cart
- Update cart quantity
- Remove cart items
- Checkout process
- Order creation and management

### Payment System
- QR payment integration
- Payment verification
- Order status tracking

### User Features
- Update profile information
- Upload profile image
- Change password
- View order history

### Backend Features
- RESTful APIs
- Spring Security
- File upload system
- MySQL integration
- Layered architecture
- Data validation
- Exception handling

---

# Tech Stack

## Frontend (Mobile)
- Flutter
- Provider / Riverpod
- Dio
- Go Router
- Shared Preferences
- Cached Network Image

## Backend
- Spring Boot
- Java 17
- Spring Security
- JWT Authentication
- Hibernate / JPA
- Maven

## Database
- MySQL

## Tools
- Git & GitHub
- Postman
- Swagger
- IntelliJ IDEA
- VS Code

---

# Architecture

ShopFlow follows a clean and scalable architecture:

Frontend:

```txt
Presentation Layer
    ↓
State Management (Provider / Riverpod)
    ↓
Repository Layer
    ↓
API Service
```

Backend:

```txt
Controller
    ↓
Service
    ↓
Repository
    ↓
Database
```

---

# Main Functionalities

✔ Authentication System  
✔ Product CRUD  
✔ Category Management  
✔ Cart Management  
✔ Checkout Flow  
✔ Order Processing  
✔ QR Payment Integration  
✔ User Profile System  
✔ File Upload System  
✔ REST API Integration  
✔ JWT Security  
✔ Responsive UI/UX  

---

# API Features

Examples:

```http
POST /api/auth/login
POST /api/auth/register
GET  /api/product
POST /api/product/create
GET  /api/user/me
POST /api/order/create
```

---

# Installation

## Clone repository

```bash
git clone https://github.com/your-username/shopflow.git
```

---

## Frontend Setup (Flutter)

Install packages:

```bash
flutter pub get
```

Run application:

```bash
flutter run
```

---

## Backend Setup (Spring Boot)

Configure database:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/ShopFlowDB
spring.datasource.username=root
spring.datasource.password=your_password

spring.jpa.hibernate.ddl-auto=update
```

Run project:

```bash
mvn spring-boot:run
```

---

# Screenshots

Add application screenshots here:

- Login Screen
- Home Screen
- Product Screen
- Cart Screen
- Checkout Screen
- Payment Screen
- Profile Screen

---

# Project Goals

This project was created to improve practical experience in:

- Flutter development
- Spring Boot backend development
- REST API integration
- Authentication systems
- Payment integration
- Database management
- Full-stack development
- Mobile application architecture

---

# Future Improvements

Planned features:

- Push notifications
- Reviews & ratings
- Wishlist
- Admin dashboard
- Coupon system
- Multi-language support
- Real payment gateway integration

---

# Author

**Hoeun Raksa**

Full Stack Developer  
Flutter • Spring Boot • ReactJS • Laravel

GitHub:
Add your GitHub link here

---

# License

This project is developed for learning purposes and portfolio demonstration.
