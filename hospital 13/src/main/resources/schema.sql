-- Create database
CREATE DATABASE IF NOT EXISTS lifecare_db;
USE lifecare_db;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'doctor', 'patient') NOT NULL DEFAULT 'patient',
    gender ENUM('male', 'female', 'other'),
    date_of_birth DATE,
    blood_group VARCHAR(5),
    emergency_contact VARCHAR(20),
    address TEXT,
    medical_history TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Departments table
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

-- Doctor-Department relationship
CREATE TABLE IF NOT EXISTS doctor_departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    UNIQUE KEY (doctor_id, department_id)
);

-- Services table
CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(20) NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Scheduled',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE
);

-- Medical Records table
CREATE TABLE IF NOT EXISTS medical_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    record_date DATE,
    record_type VARCHAR(50),
    status VARCHAR(20),
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT,
    notes TEXT,
    symptoms TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

-- Insert sample data for departments
INSERT INTO departments (name, description, image_url, building, floor, specialists_count) VALUES
('Cardiology', 'Specialized in diagnosing and treating heart diseases and cardiovascular conditions.', 'images/cardiology.jpg', 'A', 2, 5),
('Neurology', 'Focused on disorders of the nervous system, including the brain, spinal cord, and nerves.', 'images/neurology.jpg', 'B', 1, 4),
('Pediatrics', 'Dedicated to the health and medical care of infants, children, and adolescents.', 'images/pediatrics.jpg', 'C', 1, 6),
('Orthopedics', 'Specializing in conditions affecting the musculoskeletal system, including bones, joints, and muscles.', 'images/orthopedics.jpg', 'A', 3, 4),
('Dermatology', 'Focused on diagnosing and treating conditions related to the skin, hair, and nails.', 'images/dermatology.jpg', 'B', 2, 3),
('Ophthalmology', 'Specializing in the diagnosis and treatment of eye disorders and vision problems.', 'images/ophthalmology.jpg', 'A', 1, 3);

-- Insert sample data for services
INSERT INTO services (name, description, icon, category) VALUES
('24/7 Emergency Care', 'Round-the-clock emergency medical services', 'icon-clock', 'Emergency'),
('Home Healthcare', 'Medical care provided at your home', 'icon-home', 'Special'),
('Telemedicine', 'Virtual consultations with our specialists', 'icon-video', 'Special'),
('Cardiac Rehabilitation', 'Comprehensive cardiac recovery programs', 'icon-heart', 'Rehabilitation'),
('X-Ray Imaging', 'Advanced X-ray imaging for accurate diagnosis of bone fractures and other conditions', 'icon-xray', 'Diagnostic'),
('MRI Scanning', 'High-resolution magnetic resonance imaging for detailed visualization of organs and tissues', 'icon-brain', 'Diagnostic'),
('Laboratory Services', 'Comprehensive laboratory testing for blood work, urine analysis, and other diagnostic procedures', 'icon-lab', 'Diagnostic');

-- Insert sample admin user
INSERT INTO users (name, username, password, email, phone, role) VALUES
('Admin User', 'admin', 'admin123', 'admin@lifecare.com', '123-456-7890', 'admin');