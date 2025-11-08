This is a simple web application built with the Sinatra framework for managing resources. A "resource" is an information entity stored in a database table (e.g., books, students, products). This app uses "books" as the example resource, but it can be adapted for others.
The app implements standard CRUD (Create, Read, Update, Delete) operations for the resource, along with user authentication (signup, login, logout). It includes a consistent layout for all views, displays success/error messages (e.g., "Login successful", "Book updated successfully"), and features basic CSS styling for an appealing look.
Key technologies:

Ruby (version 3.2.2 recommended)
Sinatra for the web framework
ActiveRecord for ORM and database interactions
SQLite3 as the lightweight database
Bcrypt for secure password hashing
Sinatra-Flash for message display
Puma as the server (via Rack)
