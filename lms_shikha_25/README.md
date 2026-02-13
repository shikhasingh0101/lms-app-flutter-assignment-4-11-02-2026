# Library Management System (LMS)

A complete Library Management System built with Flutter (Frontend) and Node.js/Express (Backend) with MongoDB database.

## Features

### For Students:
- ✅ User Registration and Login
- ✅ View All Available Books
- ✅ View My Issued Books with details (issue date, return date, status)
- ✅ See overdue books highlighted
- ✅ Profile Management
- ✅ Logout functionality

### For Librarians:
- ✅ User Registration and Login
- ✅ Add New Books to Library
- ✅ Manage Books (View, Edit, Delete)
- ✅ Issue Books to Students
- ✅ View All Issued Books
- ✅ Return Books
- ✅ Track Book Status (Active, Returned, Overdue)
- ✅ Profile Management
- ✅ Logout functionality

## Tech Stack

### Backend:
- Node.js
- Express.js
- MongoDB with Mongoose
- JWT Authentication
- bcryptjs for password hashing

### Frontend:
- Flutter
- Material Design
- SharedPreferences for token storage
- HTTP for API calls

## Project Structure

```
lms/
├── backend/
│   ├── models/
│   │   ├── user.js
│   │   ├── book.js
│   │   └── issueBook.js
│   ├── routes/
│   │   ├── authRouter.js
│   │   ├── bookRouter.js
│   │   └── issueBookRouter.js
│   ├── middlewares/
│   │   └── authMiddleware.js
│   ├── server.js
│   └── package.json
│
└── frontend/
    ├── lib/
    │   ├── models/
    │   │   ├── user.dart
    │   │   └── book.dart
    │   ├── screens/
    │   │   ├── login.dart
    │   │   ├── register.dart
    │   │   ├── profile.dart
    │   │   ├── splash_screen.dart
    │   │   ├── student/
    │   │   │   ├── student_dashboard.dart
    │   │   │   ├── view_books.dart
    │   │   │   └── my_issued_books.dart
    │   │   └── librarian/
    │   │       ├── librarian_dashboard.dart
    │   │       ├── add_book.dart
    │   │       ├── manage_books.dart
    │   │       ├── issue_book.dart
    │   │       └── view_issued_books.dart
    │   ├── services/
    │   │   ├── auth_service.dart
    │   │   ├── user_service.dart
    │   │   ├── book_service.dart
    │   │   └── issue_book_service.dart
    │   ├── utils/
    │   │   └── custom_Alert_box.dart
    │   └── main.dart
    └── pubspec.yaml
```

## Setup Instructions

### Prerequisites:
- Node.js (v14 or higher)
- MongoDB (running on localhost:27017)
- Flutter SDK
- Dart SDK

### Backend Setup:

1. Navigate to backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Make sure MongoDB is running:
```bash
# MongoDB should be running on mongodb://127.0.0.1:27017/lms
```

4. Start the server:
```bash
npm start
```

The backend server will run on `http://localhost:4000`

### Frontend Setup:

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

**Note:** For Android emulator, update the base URL in services to use `http://10.0.2.2:4000` instead of `http://localhost:4000`

## API Endpoints

### Authentication (`/api/auth`)
- `POST /register` - Register new user
- `POST /login` - Login user
- `GET /students` - Get all students (for librarian)

### Books (`/api/books`)
- `GET /` - Get all books
- `GET /:id` - Get single book
- `POST /add` - Add new book (librarian only)
- `PUT /:id` - Update book (librarian only)
- `DELETE /:id` - Delete book (librarian only)

### Issue Books (`/api/issue`)
- `POST /issue` - Issue book to student
- `POST /return/:id` - Return issued book
- `GET /` - Get all issued books (librarian)
- `GET /student/:id` - Get student's issued books

## Database Schema

### User Model:
- name: String
- username: String (unique)
- email: String (unique)
- password: String (hashed)
- userType: Enum ['STUDENT', 'LIBRARIAN']

### Book Model:
- title: String
- author: String
- quantity: Number

### Issue Model:
- book: ObjectId (ref: Book)
- student: ObjectId (ref: User)
- issueDate: Date
- returnDate: Date
- returned: Boolean
- actualReturnDate: Date

## User Flow

1. **Splash Screen** → Shows app logo and name
2. **Login/Register** → User authentication
3. **Profile Screen** → Shows user info and redirects to dashboard
4. **Dashboard** → 
   - **Student**: View books, My issued books
   - **Librarian**: Add book, Manage books, Issue book, View all issued books
5. **Logout** → Returns to login screen

## Features Implemented

✅ Complete authentication system
✅ Role-based access (Student/Librarian)
✅ Book management (CRUD operations)
✅ Book issuing and returning
✅ Issue tracking with dates
✅ Overdue book detection
✅ Beautiful UI with Material Design
✅ Error handling throughout
✅ Form validation
✅ Loading states
✅ Refresh functionality
✅ Logout functionality

## Security Features

- Password hashing with bcryptjs
- JWT token-based authentication
- Input validation
- Error handling

## Future Enhancements

- Email notifications for due dates
- Book search and filter
- Book categories/genres
- Fine calculation for overdue books
- Book reservation system
- Reports and analytics
- Multi-language support

## License

ISC

## Author

Library Management System - Complete Implementation
