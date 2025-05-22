-- Create the database
CREATE DATABASE IF NOT EXISTS lifecare_db;
USE lifecare_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('patient', 'doctor', 'admin') NOT NULL,
    gender ENUM('male', 'female', 'other'),
    date_of_birth DATE,
    blood_group VARCHAR(5),
    emergency_contact VARCHAR(20),
    address TEXT,
    medical_history TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    building VARCHAR(50),
    floor INT,
    specialists_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create doctor_departments table (for many-to-many relationship)
CREATE TABLE IF NOT EXISTS doctor_departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    UNIQUE KEY (doctor_id, department_id)
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(20) NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE
);

-- Create services table
CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    department_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- Insert sample data for departments
INSERT INTO departments (name, description, image_url, building, floor, specialists_count)
VALUES 
('Cardiology', 'Specialized in diagnosing and treating heart diseases and cardiovascular conditions.', 'images/cardiology.jpg', 'Building A', 2, 5),
('Neurology', 'Focused on disorders of the nervous system, including the brain, spinal cord, and nerves.', 'images/neurology.jpg', 'Building B', 1, 4),
('Pediatrics', 'Dedicated to the health and medical care of infants, children, and adolescents.', 'images/pediatrics.jpg', 'Building C', 1, 6),
('Orthopedics', 'Specializes in the diagnosis and treatment of conditions of the musculoskeletal system.', 'images/orthopedics.jpg', 'Building A', 3, 5),
('Dermatology', 'Focuses on the diagnosis and treatment of skin disorders.', 'images/dermatology.jpg', 'Building B', 2, 3);

-- Insert sample admin user
INSERT INTO users (name, username, password, email, phone, role)
VALUES ('Admin User', 'admin', 'admin123', 'admin@lifecare.com', '123-456-7890', 'admin');

-- Insert sample doctor users
INSERT INTO users (name, username, password, email, phone, role, gender)
VALUES 
('Dr. John Smith', 'drsmith', 'doctor123', 'drsmith@lifecare.com', '123-456-7891', 'doctor', 'male'),
('Dr. Sarah Johnson', 'drjohnson', 'doctor123', 'drjohnson@lifecare.com', '123-456-7892', 'doctor', 'female'),
('Dr. Michael Lee', 'drlee', 'doctor123', 'drlee@lifecare.com', '123-456-7893', 'doctor', 'male'),
('Dr. Emily Chen', 'drchen', 'doctor123', 'drchen@lifecare.com', '123-456-7894', 'doctor', 'female');

-- Insert sample patient users
INSERT INTO users (name, username, password, email, phone, role, gender, date_of_birth, blood_group)
VALUES 
('John Doe', 'johndoe', 'patient123', 'johndoe@example.com', '123-456-7895', 'patient', 'male', '1985-05-15', 'O+'),
('Jane Smith', 'janesmith', 'patient123', 'janesmith@example.com', '123-456-7896', 'patient', 'female', '1990-08-22', 'A+'),
('Robert Johnson', 'rjohnson', 'patient123', 'rjohnson@example.com', '123-456-7897', 'patient', 'male', '1978-11-30', 'B-');

-- Assign doctors to departments
INSERT INTO doctor_departments (doctor_id, department_id)
VALUES 
(2, 1), -- Dr. Smith to Cardiology
(3, 2), -- Dr. Johnson to Neurology
(4, 3), -- Dr. Lee to Pediatrics
(5, 4); -- Dr. Chen to Orthopedics

-- Insert sample services
INSERT INTO services (name, description, icon, department_id)
VALUES 
('24/7 Emergency Care', 'Round-the-clock emergency medical services', 'icon-clock', NULL),
('Home Healthcare', 'Medical care provided at your home', 'icon-home', NULL),
('Telemedicine', 'Virtual consultations with our specialists', 'icon-video', NULL),
('Cardiac Rehabilitation', 'Comprehensive cardiac recovery programs', 'icon-heart', 1),
('Neurological Assessment', 'Complete evaluation of neurological functions', 'icon-brain', 2),
('Pediatric Vaccinations', 'Complete vaccination programs for children', 'icon-syringe', 3),
('Joint Replacement', 'Advanced joint replacement surgeries', 'icon-bone', 4),
('Skin Cancer Screening', 'Early detection of skin cancer', 'icon-search', 5);
